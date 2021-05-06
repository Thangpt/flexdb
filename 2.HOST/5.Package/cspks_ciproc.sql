CREATE OR REPLACE PACKAGE cspks_ciproc
IS
    /*----------------------------------------------------------------------------------------------------
     ** Module   : COMMODITY SYSTEM
     ** and is copyrighted by FSS.
     **
     **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
     **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
     **    graphic, optic recording or otherwise, translated in any language or computer language,
     **    without the prior written permission of Financial Software Solutions. JSC.
     **
     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  FSS      20-mar-2010    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/


  FUNCTION fn_PaidAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
  FUNCTION fn_PaidDayAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
  FUNCTION fn_DayAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
  FUNCTION fn_GenRemittanceTrans(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
  PROCEDURE pr_CIAutoAdvance(p_txmsg in tx.msg_rectype,p_orderid varchar,p_advamt number,p_rcvamt number,p_err_code  OUT varchar2);
  PROCEDURE pr_DFAutoAdvance(p_groupid varchar,p_vndselldf number,p_err_code  OUT varchar2);
  FUNCTION fn_OrderAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
  PROCEDURE pr_ETSOrderAdvancePayment(p_txmsg in tx.msg_rectype,p_orderid varchar,p_amount number,p_err_code  OUT varchar2);
FUNCTION fn_cimastcidfpofeeacr(strACCTNO IN varchar2, strTXDATE IN DATE, dblAMT IN NUMBER)
  RETURN  number;
FUNCTION fn_cidatefeeacr(strACCTNO IN varchar2, strNumDATE IN  NUMBER)
  RETURN  number;

FUNCTION fn_cidatedepofeeacr(strACCTNO IN varchar2, strNumDATE IN  NUMBER)
  RETURN  number;

FUNCTION pr_IRCalcCreditInterest(pv_ACType In VARCHAR2, pv_AMT in Number, pv_RuleType Out VARCHAR2)
RETURN NUMBER;

FUNCTION fn_ApproveAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;

FUNCTION fn_DrowdownAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;

FUNCTION fn_RejectAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
  FUNCTION fn_FeeDepoMaturityBackdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;

END;
/
CREATE OR REPLACE PACKAGE BODY cspks_ciproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

---------------------------------pr_ETSOrderAdvancePayment------------------------------------------------
  PROCEDURE pr_ETSOrderAdvancePayment(p_txmsg in tx.msg_rectype,p_orderid varchar,p_amount number,p_err_code  OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_blnVietnamese BOOLEAN;
      l_err_param varchar2(300);
      l_MaxRow NUMBER(20,0);
      v_overdfqtty number(20,0);
      v_dfqtty number(20,0);
      v_dfrlsqtty   number(20,0);
      v_totalpaidamt number(20,4);
      v_paidamt number(20,4);
      v_advamt number(20,4);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_ETSOrderAdvancePayment');

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    v_overdfqtty:=0;
    v_dfqtty:=0;
    for rec in
    (
        select b.txdate, b.orderid,c.autoid,a.afacctno, a.codeid,a.trade-nvl(vse.SECUREAMT,0) trading,
            c.qtty orderqtty,
            nvl(vdf.overdftrading,0) overdfqtty,
            nvl(vdf.dftrading,0)    dfqtty
        from semast a, odmast b, stschd c,
            v_getsellorderinfo vse,
            (
                select v.afacctno,v.codeid,
                sum(case when overamt>0 or (v.basicprice<=v.triggerprice or v.FLAGTRIGGER='T') then v.dftrading else 0 end) overdftrading,
                sum(case when overamt>0 or (v.basicprice<=v.triggerprice or v.FLAGTRIGGER='T') then 0 else v.dftrading end) dftrading  from
                (SELECT v.*, nvl(NML,0) DUEAMT,v.prinovd + v.oprinovd + nvl(NML,0) overamt
                FROM v_getdealinfo v,
                (SELECT S.ACCTNO, SUM(NML) NML, M.TRFACCTNO FROM LNSCHD S, LNMAST M
                        WHERE S.OVERDUEDATE <= TO_DATE((select varvalue from sysvar where grname ='SYSTEM' and varname ='CURRDATE'),'DD/MM/YYYY')
                            AND S.NML > 0 AND S.REFTYPE IN ('P')
                            AND S.ACCTNO = M.ACCTNO AND M.STATUS NOT IN ('P','R','C')
                        GROUP BY S.ACCTNO, M.TRFACCTNO
                        ORDER BY S.ACCTNO) sts
                where v.lnacctno = sts.acctno (+)
                ) v WHERE v.status='A'
                group by v.afacctno,v.codeid
            ) vdf
        where a.acctno = b.seacctno and b.orderid = c.orgorderid
        and b.via ='W'   --Lenh quan ETS
        --and a.acctno='0021085668000103'
        and c.duetype='RM' and c.status='N' and c.deltd<>'Y'
        and a.acctno = vse.seacctno(+)
        and a.afacctno = vdf.afacctno(+)
        and a.codeid= vdf.codeid(+)
        and b.orderid =p_orderid
    )
    loop
        if rec.txdate =v_strCURRDATE then
            v_overdfqtty:=least(rec.orderqtty,rec.overdfqtty);
            plog.debug (pkgctx,'v_overdfqtty ' || v_overdfqtty);
            v_dfqtty:=least(rec.orderqtty-v_overdfqtty,rec.dfqtty,-v_overdfqtty-rec.trading);
            plog.debug (pkgctx,'v_dfqtty ' || v_dfqtty);
            v_totalpaidamt:=0;
            --1.Tra no cho cac deal den va qua han
            if v_overdfqtty>0 then
                for rec1 in
                (
                    select v.*
                    FROM v_getdealinfo v,LNSCHD S, LNMAST M
                    where v.lnacctno = m.acctno and m.acctno = s.acctno and s.REFTYPE IN ('P')
                    and (S.OVERDUEDATE <= TO_DATE((select varvalue from sysvar where grname ='SYSTEM' and varname ='CURRDATE'),'DD/MM/YYYY')
                        or v.prinovd + v.oprinovd>0 or (v.basicprice<=v.triggerprice or v.FLAGTRIGGER='T'))
                    and v.afacctno =rec.afacctno and v.codeid = rec.codeid
                    order by (case when (v.basicprice<=v.triggerprice or v.FLAGTRIGGER='T')
                                    then (v.triggerprice-v.basicprice)/greatest(v.basicprice ,1)
                                    else 0 end
                             ) desc,S.OVERDUEDATE
                )
                loop
                    if v_overdfqtty> rec1.dftrading then
                        v_dfrlsqtty:=rec1.dftrading;
                    else
                        v_dfrlsqtty:=v_overdfqtty;
                    end if;
                    cspks_dfproc.pr_DealAutoPayment(p_txmsg,rec1.acctno,rec.autoid ,v_dfrlsqtty,1,v_paidamt ,p_err_code);
                    plog.debug (pkgctx,'v_paidamt ' || v_paidamt);
                    v_totalpaidamt:=v_totalpaidamt+v_paidamt;

                    v_overdfqtty:=v_overdfqtty-v_dfrlsqtty;
                    if p_err_code <> 0 then
                        return;
                    end if;
                    exit when v_overdfqtty<=0;
                end loop;
            end if;
            --2.Tra no cho cac deal trong han
            if v_dfqtty>0 then
                for rec1 in
                (
                    select v.*
                    FROM v_getdealinfo v,LNSCHD S, LNMAST M
                    where v.lnacctno = m.acctno and m.acctno = s.acctno and s.REFTYPE IN ('P')
                    and S.OVERDUEDATE > TO_DATE((select varvalue from sysvar where grname ='SYSTEM' and varname ='CURRDATE'),'DD/MM/YYYY')
                    and v.prinovd + v.oprinovd<=0
                    and v.afacctno =rec.afacctno and v.codeid = rec.codeid
                    order by S.OVERDUEDATE
                )
                loop
                    if v_dfqtty> rec1.dftrading then
                        v_dfrlsqtty:=rec1.dftrading;
                    else
                        v_dfrlsqtty:=v_dfqtty;
                    end if;
                    cspks_dfproc.pr_DealAutoPayment(p_txmsg ,rec1.acctno,rec.autoid ,v_dfrlsqtty,1,v_paidamt ,p_err_code);
                    plog.debug (pkgctx,'v_paidamt ' || v_paidamt);
                    v_totalpaidamt:=v_totalpaidamt+v_paidamt;
                    v_dfqtty:=v_dfqtty-v_dfrlsqtty;
                    if p_err_code <> 0 then
                        return;
                    end if;
                    exit when v_dfqtty<=0;
                end loop;
            end if;
            --3.Ung truoc tien ban bu cho cac deal
            if p_amount>0 then
                plog.debug (pkgctx,'Begin advance amount ' || p_amount);
                cspks_ciproc.pr_CIAutoAdvance(p_txmsg,rec.orderid,p_amount,v_advamt,p_err_code);
                if p_err_code <> 0 then
                    return;
                end if;
                plog.debug (pkgctx,'End advance amount ' || v_advamt);
            end if;
        else
            if p_amount>0 then
                plog.debug (pkgctx,'Begin advance amount ' || p_amount);
                cspks_ciproc.pr_CIAutoAdvance(p_txmsg,rec.orderid,p_amount,v_advamt,p_err_code);
                if p_err_code <> 0 then
                    return;
                end if;
                plog.debug (pkgctx,'End advance amount ' || v_advamt);
            end if;
        end if;

    end loop;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_ETSOrderAdvancePayment');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_ETSOrderAdvancePayment');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_ETSOrderAdvancePayment');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ETSOrderAdvancePayment;

 ---------------------------------fn_PaidAdvancedPayment------------------------------------------------
FUNCTION fn_PaidAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_count number(20,0);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_PaidAdvancedPayment');
    plog.debug (pkgctx, '<<BEGIN OF fn_PaidAdvancedPayment');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    if not v_blnREVERSAL then
        --CHieu lam thuan giao dich
        SELECT COUNT(*) INTO v_count FROM STSCHD WHERE AUTOID=p_txmsg.txfields('09').value;
        if v_count <=0 then
            plog.error(pkgctx,'l_lngErrCode: ' || errnums.C_OD_STSCHD_NOTFOUND);
            p_err_code :=errnums.C_OD_STSCHD_NOTFOUND;
            return l_lngErrCode;
        else
            UPDATE STSCHD SET PAIDAMT=round(PAIDAMT + p_txmsg.txfields('10').value,0),
                            PAIDFEEAMT=round(PAIDFEEAMT + p_txmsg.txfields('11').value,0)
            WHERE AUTOID=p_txmsg.txfields('09').value;
        end if;
    else
        UPDATE STSCHD SET PAIDAMT=round(PAIDAMT - ( p_txmsg.txfields('10').value),0),
                        PAIDFEEAMT=round(PAIDFEEAMT -( p_txmsg.txfields('11').value),0)
        WHERE AUTOID=p_txmsg.txfields('09').value;
    end if;
    plog.debug (pkgctx, '<<END OF fn_PaidAdvancedPayment');
    plog.setendsection (pkgctx, 'fn_PaidAdvancedPayment');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_PaidAdvancedPayment');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_PaidAdvancedPayment;



 ---------------------------------fn_GenRemittanceTrans------------------------------------------------
FUNCTION fn_GenRemittanceTrans(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_count number(20,0);
v_dblFEEAMT number(20,4);
v_bankID	varchar2(20);
v_BENEFBANK varchar2(500);
v_vpblimit  number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_GenRemittanceTrans');
    plog.debug (pkgctx, '<<BEGIN OF fn_GenRemittanceTrans');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;

    if not v_blnREVERSAL then
        --CHieu lam thuan giao dich
/*        if p_txmsg.tltxcd in ('1108') THEN
            v_dblFEEAMT:=p_txmsg.txfields('11').value+p_txmsg.txfields('12').value;
            INSERT INTO CIREMITTANCE (TXDATE, TXNUM, ACCTNO,BANKID, BENEFBANK, BENEFACCT, BENEFCUSTNAME, BENEFLICENSE, AMT, FEEAMT, DELTD, BENEFIDDATE, BENEFIDPLACE,FEETYPE,CITYEF, CITYBANK)
              VALUES (TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('03').value,
              p_txmsg.txfields('05').value,p_txmsg.txfields('80').value,p_txmsg.txfields('81').value,
              p_txmsg.txfields('82').value,p_txmsg.txfields('83').value,
              p_txmsg.txfields('10').value,p_txmsg.txfields('11').value, 'N',
              --TO_DATE(p_txmsg.txfields('95').value,systemnums.c_date_format),p_txmsg.txfields('96').value,to_char(p_txmsg.txfields('09').value),
              TO_DATE(p_txmsg.txfields('97').value,systemnums.c_date_format),p_txmsg.txfields('96').value,to_char(p_txmsg.txfields('09').value),
              to_char(p_txmsg.txfields('85').value),to_char(p_txmsg.txfields('84').value));
        ELS*/
        IF p_txmsg.tltxcd in ('1133') THEN
            --v_dblFEEAMT:=p_txmsg.txfields('11').value+p_txmsg.txfields('12').value;
            --81  1133    BENEFBANK
            --84  1133    CITYBANK
            v_dblFEEAMT:=0;
            INSERT INTO CIREMITTANCE (TXDATE, TXNUM, ACCTNO,BANKID, BENEFBANK, BENEFACCT, BENEFCUSTNAME, BENEFLICENSE, AMT, FEEAMT, DELTD, BENEFIDDATE, BENEFIDPLACE,FEETYPE,CITYEF, CITYBANK)
                VALUES (TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('03').value,
                p_txmsg.txfields('05').value,p_txmsg.txfields('81').value,'',
                p_txmsg.txfields('82').value,p_txmsg.txfields('83').value,
                p_txmsg.txfields('10').value,0, 'N',
                TO_DATE(p_txmsg.txfields('95').value,systemnums.c_date_format),p_txmsg.txfields('96').value,'0',
                to_char(p_txmsg.txfields('85').value),to_char(p_txmsg.txfields('84').value));
        ELSIF p_txmsg.tltxcd in ('1120','1134') THEN -- GD CHUYEN KHOAN NOI BO, TRANG THAI = C
            INSERT INTO CIREMITTANCE (TXDATE, TXNUM, ACCTNO,BANKID, BENEFBANK, BENEFACCT, BENEFCUSTNAME, BENEFLICENSE,
                                        AMT, FEEAMT, DELTD, BENEFIDDATE, BENEFIDPLACE,FEETYPE,CITYEF, CITYBANK,RMSTATUS)
               VALUES (TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('03').value,
               p_txmsg.txfields('03').value,p_txmsg.txfields('89').value,p_txmsg.txfields('05').value,
               p_txmsg.txfields('93').value,p_txmsg.txfields('95').value,
               p_txmsg.txfields('10').value,0, 'N',
               TO_DATE(p_txmsg.txfields('98').value,systemnums.c_date_format),p_txmsg.txfields('99').value,'0','','','C');

        ELSIF p_txmsg.tltxcd in ('1101','1111','1185') THEN
            v_dblFEEAMT:=p_txmsg.txfields('15').value;
            plog.debug( pkgctx,' FEEAMT: ' || v_dblFEEAMT );
            INSERT INTO CIREMITTANCE (TXDATE, TXNUM, ACCTNO,BANKID, BENEFBANK, BENEFACCT, BENEFCUSTNAME, BENEFLICENSE, AMT, FEEAMT, DELTD, BENEFIDDATE, BENEFIDPLACE,FEETYPE,CITYEF, CITYBANK)
                      VALUES (TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('03').value,
                      p_txmsg.txfields('05').value,p_txmsg.txfields('80').value,p_txmsg.txfields('81').value,
                      p_txmsg.txfields('82').value,p_txmsg.txfields('83').value,
                      p_txmsg.txfields('10').value,v_dblFEEAMT, 'N',
                      TO_DATE(p_txmsg.txfields('95').value,systemnums.c_date_format),p_txmsg.txfields('96').value,to_char(p_txmsg.txfields('09').value),
                      to_char(p_txmsg.txfields('85').value),to_char(p_txmsg.txfields('84').value));
        --1.3.0.4: chuyen tien giua 2 tk lưu ky
        ELSIF p_txmsg.tltxcd in ('1201') THEN
		   BEGIN
            SELECT TO_NUMBER(VARVALUE)
            INTO v_vpblimit
            FROM SYSVAR WHERE VARNAME = 'VPBANKLIMIT';
          EXCEPTION WHEN OTHERS THEN
            v_vpblimit := 300000000;
          END;
		  IF p_txmsg.txfields('10').value < v_vpblimit THEN
		    v_bankID := '309';
		  ELSE
		    v_bankID := '202';
		  END IF;
		   select min (FULL_NAME) into v_BENEFBANK  from bank_info  where bank_no= v_bankID;
          
          INSERT INTO CIREMITTANCE (TXDATE, TXNUM, ACCTNO,BANKID, BENEFBANK, BENEFACCT, BENEFCUSTNAME,
                                        AMT, FEEAMT, DELTD, FEETYPE,CITYEF, CITYBANK,RMSTATUS)
               VALUES (TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('03').value,
               v_bankID, v_BENEFBANK, --fn_gettcdtdesbankname(substr( p_txmsg.txfields('03').value,1,4)),
               fn_gettcdtdesbankacc_c(substr(p_txmsg.txfields('05').value,1,4), v_bankID),
               fn_gettcdtdesbankname_c(substr( p_txmsg.txfields('05').value,1,4), v_bankID),
               p_txmsg.txfields('10').value,p_txmsg.txfields('15').value, 'N',
               '0','','','P');

        ELSE
            v_dblFEEAMT:=p_txmsg.txfields('11').value+p_txmsg.txfields('12').value;
            INSERT INTO CIREMITTANCE (TXDATE, TXNUM, ACCTNO,BANKID, BENEFBANK, BENEFACCT, BENEFCUSTNAME, BENEFLICENSE, AMT, FEEAMT, DELTD, BENEFIDDATE, BENEFIDPLACE,FEETYPE,CITYEF, CITYBANK)
                      VALUES (TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('03').value,
                      p_txmsg.txfields('05').value,p_txmsg.txfields('80').value,p_txmsg.txfields('81').value,
                      p_txmsg.txfields('82').value,p_txmsg.txfields('83').value,
                      p_txmsg.txfields('10').value,p_txmsg.txfields('11').value, 'N',
                      TO_DATE(p_txmsg.txfields('95').value,systemnums.c_date_format),p_txmsg.txfields('96').value,to_char(p_txmsg.txfields('09').value),
                      to_char(p_txmsg.txfields('85').value),to_char(p_txmsg.txfields('84').value));
        END IF;
    else
        SELECT count(1) into v_count FROM CIREMITTANCE WHERE TXDATE=TO_DATE(p_txmsg.txdate,systemnums.c_date_format) AND TXNUM=p_txmsg.txnum AND RMSTATUS not in ('C','R') and deltd <> 'Y';
        if not v_count>0 then
            plog.error(pkgctx,'l_lngErrCode: ' || errnums.C_CI_REMITTANCE_CLOSE);
            p_err_code :=errnums.C_CI_REMITTANCE_CLOSE;
            return l_lngErrCode;
        else
            UPDATE CIREMITTANCE SET DELTD='Y' WHERE TXDATE=TO_DATE(p_txmsg.txdate,systemnums.c_date_format) AND TXNUM=p_txmsg.txnum;
        end if;
    end if;
    plog.debug (pkgctx, '<<END OF fn_GenRemittanceTrans');
    plog.setendsection (pkgctx, 'fn_GenRemittanceTrans');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_GenRemittanceTrans');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_GenRemittanceTrans;

/*---------------------------------fn_PaidDayAdvancedPayment------------------------------------------------
FUNCTION fn_PaidDayAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_count number(20,0);
v_strSTSDATE varchar2(20);
v_dblStsID number(20,4);
v_dblSTSAMT number(20,4);
v_dbltSTSFAMT number(20,4);
v_dblAMT    number(20,4);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_PaidDayAdvancedPayment');
    plog.debug (pkgctx, '<<BEGIN OF fn_PaidDayAdvancedPayment');

    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    v_dblAMT:=round(p_txmsg.txfields('10').value,0);
    begin
        SELECT TO_CHAR(CLEARDT,'DD/MM/YYYY') TXDATE
        into v_strSTSDATE
        FROM ADSCHD WHERE AUTOID=p_txmsg.txfields('09').value;
    exception when others then
        plog.error(pkgctx,'l_lngErrCode: ' || errnums.C_OD_STSCHD_NOTFOUND);
        p_err_code :=errnums.C_OD_STSCHD_NOTFOUND;
        return l_lngErrCode;
    end;
    if not v_blnREVERSAL then
        UPDATE ADSCHD
            SET PAIDAMT=round(PAIDAMT+v_dblAMT + p_txmsg.txfields('11').value,0),
            STATUS='C' WHERE AUTOID=p_txmsg.txfields('09').value;
        for rec in
        (
            SELECT AUTOID,STS.AFACCTNO,STS.AAMT-STS.PAIDAMT AMT,STS.FAMT-STS.PAIDFEEAMT FAMT
                 FROM STSCHD STS,ODMAST OD,SBSECURITIES SB
                 WHERE OD.CODEID=SB.CODEID AND STS.ORGORDERID=OD.ORDERID
                 AND STS.DELTD <> 'Y' AND STS.STATUS='C' AND STS.DUETYPE='RM'
                 --AND (CASE WHEN OD.EXECTYPE='MS' THEN 1 ELSE 0 END)=p_txmsg.txfields('60').value
                 AND STS.AFACCTNO=p_txmsg.txfields('03').value
                 AND GETDUEDATE(STS.TXDATE,STS.CLEARCD,SB.TRADEPLACE,STS.CLEARDAY) =TO_DATE(v_strSTSDATE,systemnums.c_date_format)
                 ORDER BY STS.AMT DESC
        )
        loop
            v_dblStsID := rec.AUTOID;
            v_dblSTSAMT := round(rec.AMT,0);
            v_dbltSTSFAMT := round(rec.FAMT,0);
            If v_dblSTSAMT > v_dblAMT Then
                UPDATE STSCHD SET PAIDAMT=round(PAIDAMT+  v_dblAMT,0) ,
                                  PAIDFEEAMT=round(FAMT*(PAIDAMT+  v_dblAMT )/AAMT)
                WHERE AUTOID=v_dblStsID;
                v_dblAMT := 0;
            else
                UPDATE STSCHD SET PAIDAMT=round(PAIDAMT+ v_dblSTSAMT,0) ,PAIDFEEAMT=FAMT
                WHERE AUTOID=v_dblStsID;
                v_dblAMT:=v_dblAMT-v_dblSTSAMT;
            end if;
            EXIT WHEN v_dblAMT <= 0;
        end loop;
    else
        UPDATE ADSCHD SET PAIDAMT=round(PAIDAMT-v_dblAMT - p_txmsg.txfields('11').value,0),
            STATUS='N'
        WHERE AUTOID=p_txmsg.txfields('09').value;
        for rec in
        (
            SELECT AUTOID,STS.AFACCTNO,STS.PAIDAMT AMT,PAIDFEEAMT FAMT
                  FROM STSCHD STS,ODMAST OD,SBSECURITIES SB
                  WHERE SB.CODEID=OD.CODEID AND STS.ORGORDERID=OD.ORDERID
                  AND STS.DELTD <> 'Y' AND STS.STATUS='C' AND STS.DUETYPE='RM'
                  --AND (CASE WHEN OD.EXECTYPE='MS' THEN 1 ELSE 0 END)=p_txmsg.txfields('60').value
                  AND STS.AFACCTNO=p_txmsg.txfields('03').value
                  AND GETDUEDATE(STS.TXDATE,STS.CLEARCD,SB.TRADEPLACE,STS.CLEARDAY) =TO_DATE(v_strSTSDATE,systemnums.c_date_format)
        )
        loop
            v_dblStsID := rec.AUTOID;
            v_dblSTSAMT := round(rec.AMT,0);
            v_dbltSTSFAMT := round(rec.FAMT,0);
            If v_dblSTSAMT > v_dblAMT Then
                UPDATE STSCHD SET PAIDAMT=round(PAIDAMT- v_dblAMT,0) ,
                                PAIDFEEAMT=round(FAMT*(PAIDAMT-  v_dblAMT )/AAMT,0)
                                WHERE AUTOID=v_dblStsID;
                v_dblAMT := 0;
            Else
                UPDATE STSCHD SET PAIDAMT=round(PAIDAMT-  v_dblSTSAMT,0) ,PAIDFEEAMT=FAMT  WHERE AUTOID=v_dblStsID;
                v_dblAMT := v_dblAMT - v_dblSTSAMT;
            End If;
            EXIT WHEN v_dblAMT <= 0;
        end loop;
    end if;
    plog.debug (pkgctx, '<<END OF fn_PaidDayAdvancedPayment');
    plog.setendsection (pkgctx, 'fn_PaidDayAdvancedPayment');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_PaidDayAdvancedPayment');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_PaidDayAdvancedPayment;*/

---------------------------------fn_PaidDayAdvancedPayment------------------------------------------------
FUNCTION fn_PaidDayAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_count number(20,0);
v_strSTSDATE varchar2(20);
v_dblStsID number(20,4);
v_dblSTSAMT number(20,4);
v_dbltSTSFAMT number(20,4);
v_dblAMT    number(20,4);
v_orderid  varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_PaidDayAdvancedPayment');
    plog.debug (pkgctx, '<<BEGIN OF fn_PaidDayAdvancedPayment');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    v_dblAMT:=round(p_txmsg.txfields('10').value,0) + round(p_txmsg.txfields('11').value,0);
    begin
        SELECT TO_CHAR(CLEARDT,'DD/MM/YYYY') TXDATE
        into v_strSTSDATE
        FROM ADSCHD WHERE AUTOID=p_txmsg.txfields('09').value;
    exception when others then
        plog.error(pkgctx,'l_lngErrCode: ' || errnums.C_OD_STSCHD_NOTFOUND);
        p_err_code :=errnums.C_OD_STSCHD_NOTFOUND;
        return l_lngErrCode;
    end;

    IF p_txmsg.txfields('99').value = 'ALL' OR p_txmsg.txfields('99').value IS NULL THEN
        v_orderid := '%';
    ELSE
        v_orderid := p_txmsg.txfields('99').value;
    END IF;

    if not v_blnREVERSAL then
        UPDATE ADSCHD
            SET PAIDAMT=round(PAIDAMT+v_dblAMT,0), STATUS='C', PAIDDATE=TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)
        WHERE AUTOID=p_txmsg.txfields('09').value;

        UPDATE adsource SET STATUS='C' WHERE AUTOID=p_txmsg.txfields('09').value;


        for rec in
        (
            SELECT AUTOID,STS.AFACCTNO,STS.AAMT-STS.PAIDAMT AMT,STS.FAMT-STS.PAIDFEEAMT FAMT
                 FROM STSCHD STS,ODMAST OD,SBSECURITIES SB
                 WHERE OD.CODEID=SB.CODEID AND STS.ORGORDERID=OD.ORDERID
                 AND STS.DELTD <> 'Y' AND STS.STATUS='C' AND STS.DUETYPE='RM'
                 --AND (CASE WHEN OD.EXECTYPE='MS' THEN 1 ELSE 0 END)=p_txmsg.txfields('60').value
                 AND STS.AFACCTNO=p_txmsg.txfields('03').value
                 AND GETDUEDATE(STS.TXDATE,STS.CLEARCD,SB.TRADEPLACE,STS.CLEARDAY) =TO_DATE(v_strSTSDATE,systemnums.c_date_format)
                 AND sts.orgorderid LIKE v_orderid
                 ORDER BY STS.AMT DESC
        )
        loop
            v_dblStsID := rec.AUTOID;
            v_dblSTSAMT := round(rec.AMT,0);
            If v_dblSTSAMT > v_dblAMT Then
                UPDATE STSCHD SET PAIDAMT=round(PAIDAMT+  v_dblAMT,0)
                WHERE AUTOID=v_dblStsID;
                v_dblAMT := 0;
            else
                UPDATE STSCHD SET PAIDAMT=round(PAIDAMT+ v_dblSTSAMT,0)
                WHERE AUTOID=v_dblStsID;
                v_dblAMT:=v_dblAMT-v_dblSTSAMT;
            end if;
            EXIT WHEN v_dblAMT <= 0;
        end loop;
    else
        UPDATE ADSCHD SET PAIDAMT=round(PAIDAMT-v_dblAMT,0), STATUS='N', PAIDDATE= ''
        WHERE AUTOID=p_txmsg.txfields('09').value;

         UPDATE ADSCHD SET  STATUS='N' WHERE AUTOID=p_txmsg.txfields('09').value;

        for rec in
        (
            SELECT AUTOID,STS.AFACCTNO,STS.PAIDAMT AMT,PAIDFEEAMT FAMT
                  FROM STSCHD STS,ODMAST OD,SBSECURITIES SB
                  WHERE SB.CODEID=OD.CODEID AND STS.ORGORDERID=OD.ORDERID
                  AND STS.DELTD <> 'Y' AND STS.STATUS='C' AND STS.DUETYPE='RM'
                  --AND (CASE WHEN OD.EXECTYPE='MS' THEN 1 ELSE 0 END)=p_txmsg.txfields('60').value
                  AND STS.AFACCTNO=p_txmsg.txfields('03').value
                  AND GETDUEDATE(STS.TXDATE,STS.CLEARCD,SB.TRADEPLACE,STS.CLEARDAY) =TO_DATE(v_strSTSDATE,systemnums.c_date_format)
                  AND sts.orgorderid LIKE v_orderid
        )
        loop
            v_dblStsID := rec.AUTOID;
            v_dblSTSAMT := round(rec.AMT,0);
            If v_dblSTSAMT > v_dblAMT Then
                UPDATE STSCHD SET PAIDAMT=round(PAIDAMT- v_dblAMT,0)
                                WHERE AUTOID=v_dblStsID;
                v_dblAMT := 0;
            Else
                UPDATE STSCHD SET PAIDAMT=round(PAIDAMT-  v_dblSTSAMT,0)  WHERE AUTOID=v_dblStsID;
                v_dblAMT := v_dblAMT - v_dblSTSAMT;
            End If;
            EXIT WHEN v_dblAMT <= 0;
        end loop;
    end if;
    plog.debug (pkgctx, '<<END OF fn_PaidDayAdvancedPayment');
    plog.setendsection (pkgctx, 'fn_PaidDayAdvancedPayment');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_PaidDayAdvancedPayment');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_PaidDayAdvancedPayment;

/*---------------------------------fn_DayAdvancedPayment------------------------------------------------
FUNCTION fn_DayAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_count number(20,0);
v_dblMaxAdvanceAmount   number(20,4);
v_dblADAMT  number(20,4);
v_dblADFAMT  number(20,4);
v_dblADFeeRate number;
v_dblStsID  number(20,4);
v_dblSTSEXAMT number(20,4);
v_dblSTSAMT number(20,4);
v_dblSTSFAMT   number(20,4);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_DayAdvancedPayment');
    plog.debug (pkgctx, '<<BEGIN OF fn_DayAdvancedPayment');
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    v_dblADAMT:=round(p_txmsg.txfields('10').value,0);
    v_dblADFAMT:=round(p_txmsg.txfields('11').value + p_txmsg.txfields('14').value,0);
    v_dblADFeeRate:=v_dblADFAMT/v_dblADAMT;

    if not v_blnREVERSAL then
        insert into adschd (autoid, ismortage, acctno, txdate, txnum, refadno, cleardt,
                       amt, feeamt, vatamt, bankfee, paidamt)
                SELECT seq_adschd.nextval autoid,0,--p_txmsg.txfields('60').value ismortage,
                        p_txmsg.txfields('03').value acctno,to_date(p_txmsg.txdate,systemnums.c_date_format) txdate,
                        p_txmsg.txnum txnum, '' refadno,to_date(p_txmsg.txfields('08').value,systemnums.c_date_format) cleardt,
                       p_txmsg.txfields('10').value amt,p_txmsg.txfields('11').value feeamt,0 vatamt,
                       p_txmsg.txfields('14').value bankfee,0 paidamt
                  FROM dual;

        for rec in
            (SELECT AUTOID,STS.AMT EXECAMT,
                STS.AMT-STS.AAMT-STS.FAMT+STS.PAIDAMT+STS.PAIDFEEAMT AMT,
                STS.FAMT FAMT
                FROM STSCHD STS,ODMAST OD,SBSECURITIES SEC
                WHERE STS.CODEID=SEC.CODEID AND STS.ORGORDERID=OD.ORDERID AND STS.DELTD <> 'Y' AND STS.STATUS='N' AND STS.DUETYPE='RM'
                --AND (CASE WHEN OD.EXECTYPE='MS' THEN 1 ELSE 0 END)=p_txmsg.txfields('60').value
                AND STS.AFACCTNO=p_txmsg.txfields('03').value
                --AND ( OD.VIA <> 'W' or OD.txdate < p_txmsg.txdate)
                --AND GETDUEDATE(STS.TXDATE,STS.CLEARCD,SEC.TRADEPLACE,STS.CLEARDAY)=TO_DATE(p_txmsg.txfields('08').value,systemnums.c_date_format)
                AND sts.cleardate=TO_DATE(p_txmsg.txfields('08').value,systemnums.c_date_format)
                ORDER BY amt desc--(CASE WHEN OD.VIA='W' THEN 1 ELSE 0 END)
            )
        loop
            v_dblStsID:=rec.AUTOID;
            v_dblSTSEXAMT:=round(rec.EXECAMT,0);
            v_dblSTSAMT:=round(rec.AMT,0);
            v_dblSTSFAMT:=round(rec.FAMT,0);
            If v_dblSTSAMT > v_dblADAMT * (1 + v_dblADFeeRate) Then
                UPDATE STSCHD
                    SET AAMT=AAMT+ v_dblADAMT ,
                        FAMT=FAMT + ROUND( (p_txmsg.txfields('14').value + p_txmsg.txfields('11').value) * v_dblADAMT / p_txmsg.txfields('10').value ,0)
                        WHERE AUTOID= v_dblStsID;
                v_dblADAMT:=0;
            else
                UPDATE STSCHD
                    SET AAMT=AAMT+  round(v_dblSTSAMT / (1 + v_dblADFeeRate),0) ,
                        FAMT=FAMT + ROUND( v_dblSTSAMT / (1 + v_dblADFeeRate) * v_dblADFeeRate ,0)
                        WHERE AUTOID= v_dblStsID;
                v_dblADAMT:=round(v_dblADAMT-v_dblSTSAMT / (1 + v_dblADFeeRate),0);
            end if;
            exit when v_dblADAMT <= 0;
        end loop;
        --Neu con du tien khong phan bo het thi bao loi vuot qua so tien ung truoc
        if v_dblADAMT>2 then
             p_err_code := '-400101'; --Ung qua so tien duoc phep
             RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

    else
        --Giao dich batch khong thuc hien revert.
        --Neu muon giao dich bang tay di qua day thi viet them phan revert tai day
        p_err_code:=0;
    end if;
    plog.debug (pkgctx, '<<END OF fn_DayAdvancedPayment');
    plog.setendsection (pkgctx, 'fn_DayAdvancedPayment');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_DayAdvancedPayment');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_DayAdvancedPayment;*/

/*---------------------------------fn_DayAdvancedPayment------------------------------------------------
FUNCTION fn_DayAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL           boolean;
l_lngErrCode            number(20,0);
v_count                 number(20,0);
v_dblMaxAdvanceAmount   number(20,4);
v_dblADAMT              number(20,4);
v_dblADFAMT             number(20,4);
v_dblStsID              number(20,4);
v_dblSTSEXAMT           number(20,4);
v_dblSTSAMT             number(20,4);
v_dblSTSFAMT            number(20,4);
l_RRTYPE                VARCHAR2(1);
l_CIACCTNO              VARCHAR2(10);

BEGIN
    plog.setbeginsection (pkgctx, 'fn_DayAdvancedPayment');
    plog.debug (pkgctx, '<<BEGIN OF fn_DayAdvancedPayment');
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    v_dblADAMT:=round(p_txmsg.txfields('10').value,0) + round(p_txmsg.txfields('11').value + p_txmsg.txfields('14').value,0);

    plog.debug (pkgctx, 'reftxnum:' || p_txmsg.txfields('99').value);

    if not v_blnREVERSAL then

        for rec in
               (SELECT AUTOID,STS.AMT EXECAMT, OD.AFACCTNO, STS.cleardate, od.orderid,
                   STS.AMT-STS.AAMT-STS.FAMT+STS.PAIDAMT+STS.PAIDFEEAMT AMT,
                   STS.FAMT FAMT
                   FROM STSCHD STS,ODMAST OD,SBSECURITIES SEC
                   WHERE STS.CODEID=SEC.CODEID AND STS.ORGORDERID=OD.ORDERID AND STS.DELTD <> 'Y' AND STS.STATUS='N' AND STS.DUETYPE='RM'
                   AND STS.AFACCTNO=p_txmsg.txfields('03').value
                   AND sts.cleardate=TO_DATE(p_txmsg.txfields('08').value,systemnums.c_date_format)
                   AND sts.txdate=TO_DATE(p_txmsg.txfields('42').value,systemnums.c_date_format)
                   ORDER BY amt desc
               )
         loop
             v_dblStsID := rec.AUTOID;
             v_dblSTSEXAMT := round(rec.EXECAMT,0);
             v_dblSTSAMT := round(rec.AMT,0);
             If v_dblSTSAMT > v_dblADAMT Then
                -- Log thong tin lenh ung
                INSERT INTO adschddtl(autoid, acctno, txdate, txnum, cleardate, orderid, aamt, feeamt, vatamt, DELTD, STATUS)
                VALUES (SEQ_ADSCHDDTL.NEXTVAL , rec.AFACCTNO, TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum, rec.cleardate, rec.orderid, v_dblADAMT, 0, 0, p_txmsg.deltd, 'A');

                UPDATE STSCHD
                     SET AAMT = AAMT + v_dblADAMT
                         WHERE AUTOID = v_dblStsID;
                v_dblADAMT := 0;
             else
                -- Log thong tin lenh ung
                INSERT INTO adschddtl(autoid, acctno, txdate, txnum, cleardate, orderid, aamt, feeamt, vatamt, DELTD, STATUS)
                VALUES (SEQ_ADSCHDDTL.NEXTVAL , rec.AFACCTNO, TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum, rec.cleardate, rec.orderid, v_dblADAMT, 0, 0, p_txmsg.deltd, 'A');

                UPDATE STSCHD
                     SET AAMT=AAMT + v_dblSTSAMT
                         WHERE AUTOID= v_dblStsID;
                v_dblADAMT:=v_dblADAMT-v_dblSTSAMT;
             end if;
             exit when v_dblADAMT <= 0;
         end loop;
         --Neu con du tien khong phan bo het thi bao loi vuot qua so tien ung truoc
         if v_dblADAMT>2 then
              p_err_code := '-400101'; --Ung qua so tien duoc phep
              RETURN errnums.C_BIZ_RULE_INVALID;
         end if;

        -- TH Tu dong GN
        If to_char(p_txmsg.txfields('95').value) <> '0' Then
            INSERT INTO adschd (autoid, ismortage, acctno, txdate, txnum, refadno, cleardt,
                        amt, feeamt, vatamt, bankfee, paidamt, adtype, rrtype, ciacctno, custbank, oddate)
            SELECT  seq_adschd.nextval autoid,
                    0 ismortage,
                    p_txmsg.txfields('03').value acctno,
                    To_date(p_txmsg.txdate,systemnums.c_date_format) txdate,
                    p_txmsg.txnum txnum,
                    '' refadno,
                    To_date(p_txmsg.txfields('08').value, systemnums.c_date_format) cleardt,
                    p_txmsg.txfields('10').value amt,
                    p_txmsg.txfields('11').value feeamt,
                    p_txmsg.txfields('18').value vatamt,
                    p_txmsg.txfields('14').value bankfee,
                    0 paidamt,
                    p_txmsg.txfields('46').value adtype,
                    p_txmsg.txfields('44').value rrtype,
                    p_txmsg.txfields('43').value ciacctno ,
                    p_txmsg.txfields('05').value custbank ,
                    To_date(p_txmsg.txfields('42').value, systemnums.c_date_format) oddate
            FROM dual;
        Else -- TH khong tu dong GN

            INSERT INTO adschdtemp(autoid, ismortage, status, deltd, acctno, txdate, txnum, refadno, cleardt,
                        amt, feeamt, vatamt, bankfee, paidamt, adtype, rrtype, ciacctno, custbank, oddate, reftxdate, reftxnum)
            SELECT  seq_adschd.nextval autoid,
                    0 ismortage,
                    'P' status,
                    p_txmsg.deltd deltd,
                    p_txmsg.txfields('03').value acctno,
                    To_date(p_txmsg.txdate,systemnums.c_date_format) txdate,
                    p_txmsg.txnum txnum, '' refadno,
                    To_date(p_txmsg.txfields('08').value, systemnums.c_date_format) cleardt,
                    p_txmsg.txfields('10').value amt,
                    p_txmsg.txfields('11').value feeamt,
                    p_txmsg.txfields('18').value vatamt,
                    p_txmsg.txfields('14').value bankfee,
                    0 paidamt,
                    p_txmsg.txfields('46').value adtype,
                    p_txmsg.txfields('44').value rrtype,
                    p_txmsg.txfields('43').value ciacctno,
                    p_txmsg.txfields('05').value custbank,
                    To_date(p_txmsg.txfields('42').value, systemnums.c_date_format) oddate,
                    To_date(p_txmsg.txdate, systemnums.c_date_format) reftxdate,
                    p_txmsg.txfields('99').value reftxnum
            From DUAL;

            Begin
                Select Count(1) into v_count
                from admast
                where txnum = p_txmsg.txfields('99').value
                        and txdate = To_date(p_txmsg.txdate, systemnums.c_date_format);
            EXCEPTION
            WHEN OTHERS THEN
                v_count := 0;
            End;

            If v_count = 0 then
               INSERT INTO admast(autoid, txnum, txdate, acctno, amt, feeamt, deltd, status, brid, tlid, DESCRIPTION)
               Select   seq_admast.nextval autoid,
                        p_txmsg.txfields('99').value txnum,
                        To_date(p_txmsg.txdate, systemnums.c_date_format) txdate,
                        p_txmsg.txfields('05').value acctno,
                        round(p_txmsg.txfields('10').value,0) amt,
                        round(p_txmsg.txfields('11').value + p_txmsg.txfields('14').value,0) feeamt,
                        p_txmsg.deltd deltd,
                        'P' status,
                        p_txmsg.brid brid,
                        p_txmsg.tlid tlid,
                        '' description
               From Dual;
            Else
                Update admast
                    Set amt = amt + round(p_txmsg.txfields('10').value,0),
                    feeamt = feeamt + round(p_txmsg.txfields('11').value + p_txmsg.txfields('14').value,0)
                Where txnum = p_txmsg.txfields('99').value and txdate = p_txmsg.txdate;
            End If;
        End If;
    else
        --Giao dich batch khong thuc hien revert.
        --Neu muon giao dich bang tay di qua day thi viet them phan revert tai day
        p_err_code:=0;
    end if;
    plog.debug (pkgctx, '<<END OF fn_DayAdvancedPayment');
    plog.setendsection (pkgctx, 'fn_DayAdvancedPayment');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_DayAdvancedPayment');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_DayAdvancedPayment;*/


---------------------------------fn_DayAdvancedPayment------------------------------------------------
FUNCTION fn_DayAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    v_blnREVERSAL           boolean;
    l_lngErrCode            number(20,0);
    v_count                 number(20,0);
    v_dblMaxAdvanceAmount   number(20,4);
    v_dblADAMT              number(20,4);
    v_dblADFAMT             number(20,4);
    v_dblStsID              number(20,4);
    v_dblSTSEXAMT           number(20,4);
    v_dblSTSAMT             number(20,4);
    v_dblSTSFAMT            number(20,4);
    l_RRTYPE                VARCHAR2(1);
    l_CIACCTNO              VARCHAR2(10);
    v_strRRtype varchar2(10);
    v_strCIacctno varchar2(20);
    v_strCustbank varchar2(20);
    l_ISVSD     NUMBER;
    l_autoid    NUMBER ;
    V_AvlBankLimit NUMBER;
    v_stradtype varchar2(20);
    V_AvlBankLimitCF NUMBER;
    L_ISVAT                 NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_DayAdvancedPayment');
    plog.debug (pkgctx, '<<BEGIN OF fn_DayAdvancedPayment');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    v_dblADAMT:=round(p_txmsg.txfields('10').value,0) + round(p_txmsg.txfields('11').value,0); --+ p_txmsg.txfields('14').value,0);
    L_ISVAT:=1;
    BEGIN
         SELECT (CASE WHEN AFT.VAT='Y' THEN 1 ELSE 0 END)
         INTO L_ISVAT
         FROM AFMAST AF, AFTYPE AFT
         WHERE AF.ACTYPE=AFT.ACTYPE AND AF.ACCTNO=p_txmsg.txfields('03').VALUE;
    EXCEPTION WHEN OTHERS THEN
        L_ISVAT:=1;
    END;

    --plog.debug (pkgctx, 'reftxnum:' || p_txmsg.txfields('99').value);

    if not v_blnREVERSAL THEN
        IF to_number(p_txmsg.txfields('60').value) = 0 THEN
            for rec in
               (
                   /*SELECT AUTOID,STS.AMT EXECAMT, OD.AFACCTNO, STS.cleardate, od.orderid,
                        STS.AMT-STS.AAMT-STS.FAMT+STS.PAIDAMT+STS.PAIDFEEAMT AMT,
                        STS.FAMT FAMT
                    FROM STSCHD STS,ODMAST OD,SBSECURITIES SEC
                    WHERE STS.CODEID=SEC.CODEID AND STS.ORGORDERID=OD.ORDERID AND STS.DELTD <> 'Y' AND STS.STATUS='N' AND STS.DUETYPE='RM'
                        and od.errod ='N'
                        AND STS.AFACCTNO=p_txmsg.txfields('03').value
                        AND sts.cleardate=TO_DATE(p_txmsg.txfields('08').value,systemnums.c_date_format)
                        AND sts.txdate=TO_DATE(p_txmsg.txfields('42').value,systemnums.c_date_format)
                    ORDER BY amt desc*/
                    --THENN SUA PHAN BO GIA TRI UNG TRUOC VAO TUNG LENH
                    -- GIA TRI PHAN BO MAX = GIA TRI KHOP - PHI GD - THUE BAN
                    SELECT AUTOID,STS.AMT EXECAMT, OD.AFACCTNO, STS.cleardate, od.orderid,
                        STS.AMT-STS.AAMT-STS.FAMT+STS.PAIDAMT+STS.PAIDFEEAMT
                        - CASE WHEN OD.FEEACR<=0 THEN round(ODT.DEFFEERATE*STS.AMT/100) ELSE OD.FEEACR END
                        - L_ISVAT*(case when OD.TAXSELLAMT > 0 then OD.TAXSELLAMT else round(TO_NUMBER(SYS.VARVALUE)*STS.AMT/100) END + STS.ARIGHT) AMT,
                        STS.FAMT FAMT
                    FROM STSCHD STS,ODMAST OD,SBSECURITIES SEC, ODTYPE ODT, SYSVAR SYS,ODMAPEXT ODM
                    WHERE STS.CODEID=SEC.CODEID AND STS.ORGORDERID=OD.ORDERID AND STS.DELTD <> 'Y' AND STS.STATUS='N' AND STS.DUETYPE='RM'
                        AND OD.ACTYPE = ODT.ACTYPE
                        AND od.errod ='N'
                         AND OD.orderid = ODM.orderid (+) AND NVL(ODM.isvsd,'N') = 'N'
                        AND SYS.VARNAME = 'ADVSELLDUTY' AND SYS.GRNAME = 'SYSTEM'
                        AND STS.AFACCTNO=p_txmsg.txfields('03').value
                        AND sts.cleardate=TO_DATE(p_txmsg.txfields('08').value,systemnums.c_date_format)
                        AND sts.txdate=TO_DATE(p_txmsg.txfields('42').value,systemnums.c_date_format)
                    ORDER BY amt DESC
                )
            loop
                v_dblStsID := rec.AUTOID;
                v_dblSTSEXAMT := round(rec.EXECAMT,0);
                v_dblSTSAMT := round(rec.AMT,0);
                If v_dblSTSAMT > v_dblADAMT Then
                    -- Log thong tin lenh ung
                    INSERT INTO adschddtl(autoid, acctno, txdate, txnum, cleardate, orderid, aamt, feeamt, vatamt, DELTD, STATUS)
                    VALUES (SEQ_ADSCHDDTL.NEXTVAL , rec.AFACCTNO, TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum, rec.cleardate, rec.orderid, v_dblADAMT, 0, 0, p_txmsg.deltd, 'A');

                    UPDATE STSCHD
                         SET AAMT = AAMT + v_dblADAMT
                    WHERE AUTOID = v_dblStsID;

                    /*--- HaiLT them de cap nhap so tien da ung truoc vao ODMAPEXT doi voi ung truoc VSD (cap nhap vao dong dau tien lay dc)
                    if p_txmsg.txfields('60').value <> 0 then
                        for rec1 in (select * from odmapext where  ORDERID = rec.orderid and isvsd <> 'N' and deltd <> 'Y' and rownum =1 )
                        loop
                            UPDATE ODMAPEXT SET AAMT = AAMT + v_dblADAMT
                                WHERE ORDERID = rec1.orderid and refid = rec1.refid;
                        end loop;
                    end if;*/

                    v_dblADAMT := 0;
                else
                    -- Log thong tin lenh ung
                    INSERT INTO adschddtl(autoid, acctno, txdate, txnum, cleardate, orderid, aamt, feeamt, vatamt, DELTD, STATUS)
                    VALUES (SEQ_ADSCHDDTL.NEXTVAL , rec.AFACCTNO, TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum, rec.cleardate, rec.orderid, v_dblSTSAMT, 0, 0, p_txmsg.deltd, 'A');

                    UPDATE STSCHD
                         SET AAMT=AAMT + v_dblSTSAMT
                     WHERE AUTOID= v_dblStsID;

                    /*--- HaiLT them de cap nhap so tien da ung truoc vao ODMAPEXT doi voi ung truoc VSD (cap nhap vao dong dau tien lay dc)
                    if p_txmsg.txfields('60').value <> 0 then
                        for rec2 in (select * from odmapext where  ORDERID = rec.orderid and isvsd <> 'N' and deltd <> 'Y' and rownum =1 )
                        loop
                            UPDATE ODMAPEXT SET AAMT = AAMT + v_dblSTSAMT
                                WHERE ORDERID = rec2.orderid and refid = rec2.refid;
                        end loop;
                    end if;*/

                    v_dblADAMT:=v_dblADAMT-v_dblSTSAMT;
                end if;
            exit when v_dblADAMT <= 0;
            end loop;
        ELSE
            for rec in
               (
                   /*SELECT AUTOID,STS.AMT EXECAMT, OD.AFACCTNO, STS.cleardate, od.orderid,
                        STS.AMT-STS.AAMT-STS.FAMT+STS.PAIDAMT+STS.PAIDFEEAMT AMT,
                        STS.FAMT FAMT
                    FROM STSCHD STS,ODMAST OD,SBSECURITIES SEC
                    WHERE STS.CODEID=SEC.CODEID AND STS.ORGORDERID=OD.ORDERID AND STS.DELTD <> 'Y' AND STS.STATUS='N' AND STS.DUETYPE='RM'
                        and od.errod ='N'
                        AND STS.AFACCTNO=p_txmsg.txfields('03').value
                        AND sts.cleardate=TO_DATE(p_txmsg.txfields('08').value,systemnums.c_date_format)
                        AND sts.txdate=TO_DATE(p_txmsg.txfields('42').value,systemnums.c_date_format)
                    ORDER BY amt desc*/
                    --THENN SUA PHAN BO GIA TRI UNG TRUOC VAO TUNG LENH
                    -- GIA TRI PHAN BO MAX = GIA TRI KHOP - PHI GD - THUE BAN
                    SELECT AUTOID,STS.AMT EXECAMT, OD.AFACCTNO, STS.cleardate, od.orderid,
                        STS.AMT-STS.AAMT-STS.FAMT+STS.PAIDAMT+STS.PAIDFEEAMT
                        - CASE WHEN OD.FEEACR<=0 THEN round(ODT.DEFFEERATE*STS.AMT/100) ELSE OD.FEEACR END
                        - L_ISVAT*(case when OD.TAXSELLAMT > 0 then OD.TAXSELLAMT else round(TO_NUMBER(SYS.VARVALUE)*STS.AMT/100) END + STS.ARIGHT) AMT,
                        STS.FAMT FAMT
                    FROM STSCHD STS,ODMAST OD,SBSECURITIES SEC, ODTYPE ODT, SYSVAR SYS, ODMAPEXT ODM
                    WHERE STS.CODEID=SEC.CODEID AND STS.ORGORDERID=OD.ORDERID AND STS.DELTD <> 'Y' AND STS.STATUS='N' AND STS.DUETYPE='RM'
                        AND OD.ACTYPE = ODT.ACTYPE
                        AND od.errod ='N'
                        AND OD.orderid = ODM.orderid AND ODM.isvsd = 'Y'
                        AND SYS.VARNAME = 'ADVSELLDUTY' AND SYS.GRNAME = 'SYSTEM'
                        AND STS.AFACCTNO=p_txmsg.txfields('03').value
                        AND sts.cleardate=TO_DATE(p_txmsg.txfields('08').value,systemnums.c_date_format)
                        AND sts.txdate=TO_DATE(p_txmsg.txfields('42').value,systemnums.c_date_format)
                    ORDER BY amt DESC
                )
            loop
                v_dblStsID := rec.AUTOID;
                v_dblSTSEXAMT := round(rec.EXECAMT,0);
                v_dblSTSAMT := round(rec.AMT,0);
                If v_dblSTSAMT > v_dblADAMT Then
                    -- Log thong tin lenh ung
                    INSERT INTO adschddtl(autoid, acctno, txdate, txnum, cleardate, orderid, aamt, feeamt, vatamt, DELTD, STATUS)
                    VALUES (SEQ_ADSCHDDTL.NEXTVAL , rec.AFACCTNO, TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum, rec.cleardate, rec.orderid, v_dblADAMT, 0, 0, p_txmsg.deltd, 'A');

                    UPDATE STSCHD
                         SET AAMT = AAMT + v_dblADAMT
                    WHERE AUTOID = v_dblStsID;

                    --- HaiLT them de cap nhap so tien da ung truoc vao ODMAPEXT doi voi ung truoc VSD (cap nhap vao dong dau tien lay dc)
                    if p_txmsg.txfields('60').value <> 0 then
                        for rec1 in (select * from odmapext where  ORDERID = rec.orderid and isvsd <> 'N' and deltd <> 'Y' and rownum =1 )
                        loop
                            UPDATE ODMAPEXT SET AAMT = AAMT + v_dblADAMT
                                WHERE ORDERID = rec1.orderid and refid = rec1.refid;
                        end loop;
                end if;

                v_dblADAMT := 0;
                else
                    -- Log thong tin lenh ung
                    INSERT INTO adschddtl(autoid, acctno, txdate, txnum, cleardate, orderid, aamt, feeamt, vatamt, DELTD, STATUS)
                    VALUES (SEQ_ADSCHDDTL.NEXTVAL , rec.AFACCTNO, TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum, rec.cleardate, rec.orderid, v_dblSTSAMT, 0, 0, p_txmsg.deltd, 'A');

                    UPDATE STSCHD
                         SET AAMT=AAMT + v_dblSTSAMT
                             WHERE AUTOID= v_dblStsID;

                    --- HaiLT them de cap nhap so tien da ung truoc vao ODMAPEXT doi voi ung truoc VSD (cap nhap vao dong dau tien lay dc)
                    if p_txmsg.txfields('60').value <> 0 then
                        for rec2 in (select * from odmapext where  ORDERID = rec.orderid and isvsd <> 'N' and deltd <> 'Y' and rownum =1 )
                        loop
                            UPDATE ODMAPEXT SET AAMT = AAMT + v_dblSTSAMT
                                WHERE ORDERID = rec2.orderid and refid = rec2.refid;
                        end loop;
                    end if;

                    v_dblADAMT:=v_dblADAMT-v_dblSTSAMT;
                end if;
            exit when v_dblADAMT <= 0;
            end loop;
        END IF;

         --Neu con du tien khong phan bo het thi bao loi vuot qua so tien ung truoc
         if v_dblADAMT>2 then
              p_err_code := '-400101'; --Ung qua so tien duoc phep
              RETURN errnums.C_BIZ_RULE_INVALID;
         end if;

        if  p_txmsg.txfields('06').value='NULL' or p_txmsg.txfields('06').value is null then
            v_strRRtype :='';
            v_strCIacctno:='';
            v_strCustbank:='';
        else
            begin
                select rrtype, ciacctno, custbank into v_strRRtype,v_strCIacctno,v_strCustbank
                from adtype
                where actype =p_txmsg.txfields('06').value;
            exception when others then
                v_strRRtype :='';
                v_strCIacctno:='';
                v_strCustbank:='';
            end ;
        end if;

        l_autoid:=seq_adschd.nextval ;

        INSERT INTO adschd (autoid, ismortage, acctno, txdate, txnum, refadno, cleardt,
                        amt, feeamt, vatamt, bankfee, paidamt, adtype, rrtype, ciacctno, custbank,oddate, freeadvfeedays, PaidADVType)
            SELECT  l_autoid autoid,
                    0 ismortage,
                    p_txmsg.txfields('03').value acctno,
                    To_date(p_txmsg.txdate,systemnums.c_date_format) txdate,
                    p_txmsg.txnum txnum,
                    '' refadno,
                    To_date(p_txmsg.txfields('08').value, systemnums.c_date_format) cleardt,
                    p_txmsg.txfields('10').value amt,
                    p_txmsg.txfields('11').value feeamt,
                    p_txmsg.txfields('18').value vatamt,
                    p_txmsg.txfields('14').value bankfee,
                    0 paidamt,
                    p_txmsg.txfields('06').value adtype,
                    v_strRRtype rrtype,
                    v_strCiacctno ciacctno ,
                    v_strCustbank custbank,
                    To_date(p_txmsg.txfields('42').value, systemnums.c_date_format) oddate,
                    p_txmsg.txfields('13').value adjdays,
                    p_txmsg.txfields('23').value PAIDADVTYPE
            FROM dual;

    --phan bo nguon ung truoc
    v_dblADAMT:= p_txmsg.txfields('10').value ;
    v_dblADFAMT := p_txmsg.txfields('11').value ;

--    IF  p_txmsg.txfields('06').value ='AUTO' THEN

    FOR REC IN (SELECT adtype.rrtype,adtype.custbank , adtype.actype, cf.custid FROM afidtype afid, afmast af,adtype,cfmast cf
                      WHERE afid.aftype= af.actype
                      AND af.acctno = p_txmsg.txfields('03').value
                      AND afid.actype=adtype.actype
                      AND af.custid = cf.custid
                      AND objname ='AD.ADTYPE' ORDER BY odrnum)
     LOOP
     --neu nguon tien chua phan bo =0 thi ket thuc

     IF  v_dblADAMT =0  THEN   EXIT;   END IF;

     -- neu la nguon cong ty thi phan bo het va ket thuc
     IF rec.rrtype ='C'  THEN
          INSERT INTO adsource(id,autoid,acctno ,txdate,txnum ,cleardt,amt,rrtype,ciacctno,custbank,adtype,feeamt)
              SELECT seq_adsource.nextval, l_autoid autoid,p_txmsg.txfields('03').value acctno ,To_date(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,
                To_date(p_txmsg.txfields('08').value, systemnums.c_date_format) cleardt,  v_dblADAMT amt,rec.rrtype rrtype,
               v_strCiacctno ciacctno , rec.custbank custbank,rec.actype adtype, v_dblADFAMT FROM dual ;
               v_dblADAMT:=0;
               v_dblADFAMT:=0;

     EXIT;
     END IF;


     IF rec.rrtype ='B' THEN

      SELECT cspks_cfproc.fn_getavlbanklimit(rec.custbank,'ADV') INTO  V_AvlBankLimit FROM DUAL ;
      SELECT cspks_cfproc.fn_getavlbanklimitCF(rec.custbank,rec.custid,'ADV') INTO  V_AvlBankLimitCF FROM DUAL ;


          IF  v_dblADAMT<= LEAST( V_AvlBankLimit,V_AvlBankLimitCF) THEN
              INSERT INTO adsource(id,autoid,acctno ,txdate,txnum ,cleardt,amt,rrtype,ciacctno,custbank,adtype,feeamt)
              SELECT seq_adsource.nextval, l_autoid autoid,p_txmsg.txfields('03').value acctno ,To_date(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,
                To_date(p_txmsg.txfields('08').value, systemnums.c_date_format) cleardt,  v_dblADAMT amt,rec.rrtype rrtype,
               v_strCiacctno ciacctno , rec.custbank custbank,rec.actype adtype, v_dblADFAMT FROM dual ;
               v_dblADAMT:=0;
               v_dblADFAMT:=0;
          ELSE
              IF LEAST( V_AvlBankLimit,V_AvlBankLimitCF) >0 THEN
               INSERT INTO adsource(id,autoid,acctno ,txdate,txnum ,cleardt,amt,rrtype,ciacctno,custbank,adtype,feeamt)
               SELECT seq_adsource.nextval, l_autoid autoid,p_txmsg.txfields('03').value acctno ,To_date(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,
                To_date(p_txmsg.txfields('08').value, systemnums.c_date_format) cleardt,  LEAST( V_AvlBankLimit,V_AvlBankLimitCF) amt,rec.rrtype rrtype,
                 v_strCiacctno ciacctno , rec.custbank custbank,rec.actype adtype,TRUNC(LEAST( V_AvlBankLimit,V_AvlBankLimitCF)*p_txmsg.txfields('11').value / p_txmsg.txfields('10').value)
                FROM dual ;

               v_dblADFAMT:=v_dblADFAMT-TRUNC(LEAST( V_AvlBankLimit,V_AvlBankLimitCF)*p_txmsg.txfields('11').value / p_txmsg.txfields('10').value);
               v_dblADAMT:=v_dblADAMT-LEAST( V_AvlBankLimit,V_AvlBankLimitCF);
              END IF;
           END IF ;
       END IF ;

      END LOOP;
      -- phan con lai se vao nguon chinh
      IF v_dblADAMT>0 THEN

      BEGIN
      SELECT rrtype,custbank,actype  INTO v_strRRtype,v_strCustbank, v_stradtype
      FROM ADTYPE WHERE ACTYPE IN (SELECT ADTYPE FROM AFTYPE WHERE actype =p_txmsg.txfields('89').value );
      EXCEPTION WHEN OTHERS THEN
                v_strRRtype :='';
                v_strCIacctno:='';
                v_strCustbank:='';
                v_stradtype:='';
      END ;

           INSERT INTO adsource(id,autoid,acctno ,txdate,txnum ,cleardt,amt,rrtype,ciacctno,custbank,adtype,feeamt)
           SELECT seq_adsource.nextval, l_autoid autoid,p_txmsg.txfields('03').value acctno ,To_date(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,
            To_date(p_txmsg.txfields('08').value, systemnums.c_date_format) cleardt,   v_dblADAMT amt,v_strRRtype rrtype,
           v_strCiacctno ciacctno , v_strCustbank custbank,v_stradtype adtype,v_dblADFAMT FROM dual ;

      END IF  ;

  --   END IF;


    else
        --Giao dich batch khong thuc hien revert.
        --Neu muon giao dich bang tay di qua day thi viet them phan revert tai day
        update adschd set deltd ='Y' where txnum = p_txmsg.txnum and txdate =To_date(p_txmsg.txdate,systemnums.c_date_format);
        update adsource set deltd ='Y' where txnum = p_txmsg.txnum and txdate =To_date(p_txmsg.txdate,systemnums.c_date_format);

        for rec in (select * from adschddtl where txnum = p_txmsg.txnum and txdate =To_date(p_txmsg.txdate,systemnums.c_date_format))
        loop
            update stschd set aamt = aamt-rec.aamt where orgorderid = rec.orderid and duetype ='RM';
            --- HaiLT them de cap nhap so tien da ung truoc vao ODMAPEXT doi voi ung truoc VSD (cap nhap vao dong dau tien lay dc)
            if p_txmsg.txfields('60').value <> 0 then
                for rec4 in (select * from odmapext where  ORDERID = rec.orderid and isvsd <> 'N' and deltd <> 'Y' and rownum =1 )
                loop
                    UPDATE ODMAPEXT SET AAMT = AAMT - rec.aamt
                        WHERE ORDERID = rec4.orderid and refid = rec4.refid;
                end loop;
            end if;

            update adschddtl set deltd ='Y' where autoid = rec.autoid;
        end loop;
        p_err_code:=0;
    end if;
    plog.debug (pkgctx, '<<END OF fn_DayAdvancedPayment');
    plog.setendsection (pkgctx, 'fn_DayAdvancedPayment');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_DayAdvancedPayment' || dbms_utility.format_error_backtrace);
      RAISE errnums.E_SYSTEM_ERROR;
END fn_DayAdvancedPayment;


---------------------------------fn_DrowdownAdvancedPayment------------------------------------------------
FUNCTION fn_DrowdownAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL           boolean;
l_lngErrCode            number(20,0);
v_count                 number(20,0);
v_dblMaxAdvanceAmount   number(20,4);
v_dblADAMT              number(20,4);
v_dblADFAMT             number(20,4);
v_dblStsID              number(20,4);
v_dblSTSEXAMT           number(20,4);
v_dblSTSAMT             number(20,4);
v_dblSTSFAMT            number(20,4);
l_RRTYPE                VARCHAR2(1);
l_CIACCTNO              VARCHAR2(10);
l_autoid                number(20);
l_txnum                 VARCHAR2(10);

BEGIN
    plog.setbeginsection (pkgctx, 'fn_DrowdownAdvancedPayment');
    plog.debug (pkgctx, '<<BEGIN OF fn_DrowdownAdvancedPayment');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    -- v_dblADAMT:=round(p_txmsg.txfields('10').value,0) + round(p_txmsg.txfields('11').value + p_txmsg.txfields('14').value,0);
    Begin
        select txnum into l_txnum from ADSCHDTEMP
            where acctno = p_txmsg.txfields('03').value
                and rrtype =  p_txmsg.txfields('44').value
                and cleardt =  To_date(p_txmsg.txfields('08').value, systemnums.c_date_format)
                and oddate = To_date(p_txmsg.txfields('42').value, systemnums.c_date_format)
                and reftxnum = p_txmsg.txfields('99').value;
    EXCEPTION
        WHEN OTHERS THEN    l_txnum := '';
    END;

    if not v_blnREVERSAL then
        INSERT INTO adschd (autoid, ismortage, acctno, txdate, txnum, refadno, cleardt,
                    amt, feeamt, vatamt, bankfee, paidamt, adtype, rrtype, ciacctno, custbank, oddate)
        SELECT  seq_adschd.nextval autoid,
                0 ismortage,
                p_txmsg.txfields('03').value acctno,
                To_date(p_txmsg.txdate,systemnums.c_date_format) txdate,
                --p_txmsg.txnum txnum,
                l_txnum,
                '' refadno,
                To_date(p_txmsg.txfields('08').value, systemnums.c_date_format) cleardt,
                p_txmsg.txfields('10').value amt,
                p_txmsg.txfields('11').value feeamt,
                p_txmsg.txfields('18').value vatamt,
                p_txmsg.txfields('14').value bankfee,
                0 paidamt,
                p_txmsg.txfields('46').value adtype,
                p_txmsg.txfields('44').value rrtype,
                p_txmsg.txfields('43').value ciacctno ,
                p_txmsg.txfields('05').value custbank ,
                To_date(p_txmsg.txfields('42').value, systemnums.c_date_format) oddate
        FROM dual;
    else
        --Giao dich batch khong thuc hien revert.
        --Neu muon giao dich bang tay di qua day thi viet them phan revert tai day
        p_err_code:=0;
    end if;
    plog.debug (pkgctx, '<<END OF fn_DrowdownAdvancedPayment');
    plog.setendsection (pkgctx, 'fn_DrowdownAdvancedPayment');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_DrowdownAdvancedPayment');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_DrowdownAdvancedPayment;

FUNCTION fn_ApproveAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

l_txmsg                 tx.msg_rectype;
v_blnREVERSAL           boolean;
l_lngErrCode            number(20,0);
v_count                 number(20,0);
v_dblMaxAdvanceAmount   number(20,4);
v_dblADAMT              number(20,4);
v_dblADFAMT             number(20,4);
v_dblStsID              number(20,4);
v_dblSTSEXAMT           number(20,4);
v_dblSTSAMT             number(20,4);
v_dblSTSFAMT            number(20,4);
l_RRTYPE                VARCHAR2(1);
l_CIACCTNO              VARCHAR2(10);
v_strDesc               VARCHAR2(1000);
v_strEN_Desc            VARCHAR2(1000);
l_AdvDays               Number;
l_err_param             varchar2(300);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_ApproveAdvancedPayment');
    plog.debug (pkgctx, '<<BEGIN OF fn_ApproveAdvancedPayment');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='1156';

    l_txmsg.msgtype     :='T';
    l_txmsg.local       :='N';
    l_txmsg.tlid        := p_txmsg.tlid;
    l_txmsg.brid        := p_txmsg.brid;
    l_txmsg.wsname      := p_txmsg.wsname;
    l_txmsg.ipaddress   := p_txmsg.ipaddress;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := p_txmsg.deltd;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := '1155';
    l_txmsg.txdate      := to_date(p_txmsg.txdate,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(p_txmsg.txdate,systemnums.c_date_format);
    l_txmsg.tltxcd      := '1156';

    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;

    If Not v_blnREVERSAL then

        For rec in
        (
            Select  SCH.AUTOID, SCH.ISMORTAGE, SCH.STATUS, SCH.DELTD, SCH.ACCTNO, SCH.TXDATE, SCH.TXNUM,
                    SCH.REFADNO, SCH.CLEARDT, SCH.AMT, SCH.FEEAMT, SCH.VATAMT, SCH.BANKFEE, SCH.PAIDAMT,
                    SCH.ODDATE, SCH.ADTYPE, SCH.RRTYPE, SCH.CUSTBANK, SCH.CIACCTNO, SCH.PAIDDATE, SCH.REFTXDATE, SCH.REFTXNUM,
                    TYP.ADVRATE, TYP.VATRATE, TYP.ADVBANKRATE, TYP.ADVMINFEE, TYP.ADVMINFEEBANK,
                    CF.FULLNAME, 0 CIDRAWNDOWN, 1 BANKDRAWNDOWN, 0 CMPDRAWNDOWN, 1 AUTODRAWNDOWN,
                    'Giai ngan UTTB giao dich ngay ' || to_char(SCH.ODDATE,systemnums.c_date_format) || ' thanh toan ngay '  || to_char(SCH.CLEARDT,systemnums.c_date_format) || '''' DES
            FROM ADMAST AD, ADSCHDTEMP SCH, ADTYPE TYP, CFMAST CF, AFMAST AF
            WHERE AD.TXNUM = SCH.REFTXNUM AND AD.TXDATE = SCH.REFTXDATE
                  AND SCH.ADTYPE = TYP.ACTYPE  AND CF.CUSTID = AF.CUSTID AND AF.ACCTNO = SCH.ACCTNO
                  AND AD.AUTOID = P_TXMSG.TXFIELDS('02').VALUE

            )
        Loop
            --Set txnum
            plog.debug(pkgctx, 'Loop for account:' || rec.ACCTNO || ' ngay' || to_char(rec.CLEARDT));
            SELECT systemnums.C_BATCH_PREFIXED
                             || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                      INTO l_txmsg.txnum
                      FROM DUAL;

            l_AdvDays := To_date(rec.CLEARDT,systemnums.c_date_format) - To_date(rec.TXDATE,systemnums.c_date_format);

            --Set cac field giao dich
            --03   ACCTNO       C
            l_txmsg.txfields ('03').defname   := 'ACCTNO';
            l_txmsg.txfields ('03').TYPE      := 'C';
            l_txmsg.txfields ('03').VALUE     := REC.ACCTNO;
            --05    BANKID      C
            l_txmsg.txfields ('05').defname   := 'BANKID';
            l_txmsg.txfields ('05').TYPE      := 'C';
            l_txmsg.txfields ('05').VALUE     := REC.CUSTBANK;
            --08    ORDATE      C
            l_txmsg.txfields ('08').defname   := 'ORDATE';
            l_txmsg.txfields ('08').TYPE      := 'C';
            l_txmsg.txfields ('08').VALUE     := to_char(REC.CLEARDT,systemnums.c_date_format);
             --09   ADVAMT          N
            l_txmsg.txfields ('09').defname   := 'ADVAMT';
            l_txmsg.txfields ('09').TYPE      := 'N';
            l_txmsg.txfields ('09').VALUE     := ROUND(REC.AMT + REC.FEEAMT + REC.BANKFEE,0);
            --10    AMT         N
            l_txmsg.txfields ('10').defname   := 'AMT';
            l_txmsg.txfields ('10').TYPE      := 'N';
            l_txmsg.txfields ('10').VALUE     := ROUND(REC.AMT,0);
            --11    FEEAMT      N
            l_txmsg.txfields ('11').defname   := 'FEEAMT';
            l_txmsg.txfields ('11').TYPE      := 'N';
            l_txmsg.txfields ('11').VALUE     := ROUND(REC.FEEAMT,0);

            --12    INTRATE     N
            l_txmsg.txfields ('12').defname   := 'INTRATE';
            l_txmsg.txfields ('12').TYPE      := 'N';
            l_txmsg.txfields ('12').VALUE     := REC.ADVRATE;
            --13    DAYS        N
            l_txmsg.txfields ('13').defname   := 'DAYS';
            l_txmsg.txfields ('13').TYPE      := 'N';
            l_txmsg.txfields ('13').VALUE     := l_AdvDays;
            --14    BNKFEEAMT   N
            l_txmsg.txfields ('14').defname   := 'BNKFEEAMT';
            l_txmsg.txfields ('14').TYPE      := 'N';
            l_txmsg.txfields ('14').VALUE     := ROUND(REC.BANKFEE,0);
            --15    BNKRATE     N
            l_txmsg.txfields ('15').defname   := 'BNKRATE';
            l_txmsg.txfields ('15').TYPE      := 'N';
            l_txmsg.txfields ('15').VALUE     := REC.ADVBANKRATE;
            --16    CMPMINBAL   N
            l_txmsg.txfields ('16').defname   := 'CMPMINBAL';
            l_txmsg.txfields ('16').TYPE      := 'N';
            l_txmsg.txfields ('16').VALUE     := REC.ADVMINFEE;
            --17    BNKMINBAL   N
            l_txmsg.txfields ('17').defname   := 'BNKMINBAL';
            l_txmsg.txfields ('17').TYPE      := 'N';
            l_txmsg.txfields ('17').VALUE     := REC.ADVMINFEEBANK;
            --18    VATAMT  N
            l_txmsg.txfields ('18').defname   := 'VATAMT';
            l_txmsg.txfields ('18').TYPE      := 'N';
            l_txmsg.txfields ('18').VALUE     := REC.VATAMT;
            --19    VAT     N
            l_txmsg.txfields ('19').defname   := 'VAT';
            l_txmsg.txfields ('19').TYPE      := 'N';
            l_txmsg.txfields ('19').VALUE     := ROUND(REC.BANKFEE,0);
            --20    MAXAMT      N
            l_txmsg.txfields ('20').defname   := 'MAXAMT';
            l_txmsg.txfields ('20').TYPE      := 'N';
            l_txmsg.txfields ('20').VALUE     := ROUND(REC.AMT + REC.FEEAMT + REC.BANKFEE,0);
            --30    DESC        C
            l_txmsg.txfields ('30').defname   := 'DESC';
            l_txmsg.txfields ('30').TYPE      := 'C';
            l_txmsg.txfields ('30').VALUE     := REC.DES;
            --40    3600        C
            l_txmsg.txfields ('40').defname   := '3600';
            l_txmsg.txfields ('40').TYPE      := 'C';
            l_txmsg.txfields ('40').VALUE     := 3600;
            --41    100         C
            l_txmsg.txfields ('41').defname   := '100';
            l_txmsg.txfields ('41').TYPE      := 'C';
            l_txmsg.txfields ('41').VALUE     := 100;
            --90    CUSTNAME    C
            l_txmsg.txfields ('90').defname   := 'CUSTNAME';
            l_txmsg.txfields ('90').TYPE      := 'C';
            l_txmsg.txfields ('90').VALUE     := rec.FULLNAME;

            -- TruongLD Add 21/09/2011
            --42    TXDATE     C
            l_txmsg.txfields ('42').defname   := 'TXDATE';
            l_txmsg.txfields ('42').TYPE      := 'C';
            l_txmsg.txfields ('42').VALUE     := rec.ODDATE;

            --43    CIACCTNO     C
            l_txmsg.txfields ('43').defname   := 'CIACCTNO';
            l_txmsg.txfields ('43').TYPE      := 'C';
            l_txmsg.txfields ('43').VALUE     := rec.CIACCTNO;

            --44    RRTYPE     C
            l_txmsg.txfields ('44').defname   := 'RRTYPE';
            l_txmsg.txfields ('44').TYPE      := 'C';
            l_txmsg.txfields ('44').VALUE     := rec.RRTYPE;

            --46    ACTYPE     C
            l_txmsg.txfields ('46').defname   := 'ACTYPE';
            l_txmsg.txfields ('46').TYPE      := 'C';
            l_txmsg.txfields ('46').VALUE     := rec.ADTYPE;


            --96    CIDRAWNDOWN     C
            l_txmsg.txfields ('96').defname   := 'CIDRAWNDOWN';
            l_txmsg.txfields ('96').TYPE      := 'C';
            l_txmsg.txfields ('96').VALUE     := rec.CIDRAWNDOWN;

            --97    BANKDRAWNDOWN     C
            l_txmsg.txfields ('97').defname   := 'BANKDRAWNDOWN';
            l_txmsg.txfields ('97').TYPE      := 'C';
            l_txmsg.txfields ('97').VALUE     := rec.BANKDRAWNDOWN;

             --98    CMPDRAWNDOWN     C
            l_txmsg.txfields ('98').defname   := 'CMPDRAWNDOWN';
            l_txmsg.txfields ('98').TYPE      := 'C';
            l_txmsg.txfields ('98').VALUE     := rec.CMPDRAWNDOWN;

             --95    AUTODRAWNDOWN     C
            l_txmsg.txfields ('95').defname   := 'AUTODRAWNDOWN';
            l_txmsg.txfields ('95').TYPE      := 'C';
            l_txmsg.txfields ('95').VALUE     := rec.AUTODRAWNDOWN;

             --99    ADTXNUM     C
            l_txmsg.txfields ('99').defname   := 'ADTXNUM';
            l_txmsg.txfields ('99').TYPE      := 'C';
            l_txmsg.txfields ('99').VALUE     := rec.REFTXNUM;
            -- End TruongLD
            BEGIN
                IF txpks_#1156.fn_batchtxprocess (l_txmsg,
                                                 p_err_code,
                                                 l_err_param
                   ) <> systemnums.c_success
                THEN
                   plog.debug (pkgctx,
                               'got error 1156: ' || p_err_code
                   );
                   ROLLBACK;
                   RETURN errnums.C_SYSTEM_ERROR;
                END IF;

                Update ADSCHDTEMP set Status ='C' where acctno = rec.acctno and reftxnum = rec.reftxnum;

            END;
        End Loop;

        Update admast set status='C' where autoid = P_TXMSG.TXFIELDS('02').VALUE;

    Else
        --Giao dich batch khong thuc hien revert.
        --Neu muon giao dich bang tay di qua day thi viet them phan revert tai day
        p_err_code:=0;
    End If;

    plog.debug (pkgctx, '<<END OF fn_ApproveAdvancedPayment');
    plog.setendsection (pkgctx, 'fn_ApproveAdvancedPayment');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_ApproveAdvancedPayment');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_ApproveAdvancedPayment;


FUNCTION fn_RejectAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

l_txmsg                 tx.msg_rectype;
v_blnREVERSAL           boolean;
l_lngErrCode            number(20,0);
v_count                 number(20,0);
v_dblMaxAdvanceAmount   number(20,4);
v_dblADAMT              number(20,4);
v_dblADFAMT             number(20,4);
v_dblStsID              number(20,4);
v_dblSTSEXAMT           number(20,4);
v_dblSTSAMT             number(20,4);
v_dblSTSFAMT            number(20,4);
l_RRTYPE                VARCHAR2(1);
l_CIACCTNO              VARCHAR2(10);
v_strDesc               VARCHAR2(1000);
v_strEN_Desc            VARCHAR2(1000);
l_AdvDays               Number;
l_err_param             varchar2(300);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_RejectAdvancedPayment');
    plog.debug (pkgctx, '<<BEGIN OF fn_RejectAdvancedPayment');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;

    If Not v_blnREVERSAL then

        For RootRec in
        (
            Select  SCH.AUTOID, SCH.ISMORTAGE, SCH.STATUS, SCH.DELTD, SCH.ACCTNO, SCH.TXDATE, SCH.TXNUM,
                    SCH.REFADNO, SCH.CLEARDT, SCH.AMT, SCH.FEEAMT, SCH.VATAMT, SCH.BANKFEE, SCH.PAIDAMT,
                    SCH.ODDATE, SCH.ADTYPE, SCH.RRTYPE, SCH.CUSTBANK, SCH.CIACCTNO, SCH.PAIDDATE, SCH.REFTXDATE, SCH.REFTXNUM,
                    'Giai ngan UTTB giao dich ngay ' || to_char(SCH.ODDATE,systemnums.c_date_format) || ' thanh toan ngay '  || to_char(SCH.CLEARDT,systemnums.c_date_format) || '''' DES
            FROM ADMAST AD, ADSCHDTEMP SCH
            WHERE AD.TXNUM = SCH.REFTXNUM AND AD.TXDATE = SCH.REFTXDATE
                  AND AD.AUTOID = P_TXMSG.TXFIELDS('02').VALUE
            )
        Loop

            Update ADSCHDTEMP set Status = 'R'
            where REFTXNUM = RootRec.REFTXNUM
                    and RefTxdate = TO_DATE(RootRec.REFTXDATE,systemnums.c_date_format);

            v_dblADAMT := RootRec.AMT;

            for rec in
               (
                    SELECT AUTOID,STS.AMT EXECAMT, STS.AAMT-STS.FAMT AMT,STS.FAMT FAMT, OD.AFACCTNO, STS.cleardate, od.orderid
                    FROM STSCHD STS,ODMAST OD,SBSECURITIES SEC
                    WHERE STS.CODEID = SEC.CODEID AND STS.ORGORDERID = OD.ORDERID
                          AND STS.DELTD <> 'Y' AND STS.STATUS='N' AND STS.DUETYPE='RM'
                          AND STS.AFACCTNO = RootRec.Acctno
                          AND sts.cleardate = TO_DATE(RootRec.CLEARDT,systemnums.c_date_format)
                          AND sts.txdate = TO_DATE(RootRec.ODDATE,systemnums.c_date_format)
                    ORDER BY amt desc
               )
             loop

                 v_dblStsID := rec.AUTOID;
                 v_dblSTSEXAMT := round(rec.EXECAMT,0);
                 v_dblSTSAMT := round(rec.AMT,0);

                 plog.debug (pkgctx,'v_dblStsID =' || v_dblStsID);
                 plog.debug (pkgctx,'v_dblSTSEXAMT =' || v_dblSTSEXAMT);
                 plog.debug (pkgctx,'v_dblSTSAMT =' || v_dblSTSAMT);
                 plog.debug (pkgctx,'v_dblADAMT =' || v_dblADAMT);

                 If v_dblSTSAMT >= v_dblADAMT Then

                    Update ADSCHDDTL Set AAMT = AAMT - v_dblADAMT, STATUS ='R' where ORDERID = rec.ORDERID and CLEARDATE = to_date(rec.cleardate, systemnums.c_date_format);

                    UPDATE STSCHD
                         SET AAMT = AAMT - v_dblADAMT
                             WHERE AUTOID = v_dblStsID;
                    v_dblADAMT:=0;
                 else

                    Update ADSCHDDTL Set AAMT = AAMT - v_dblADAMT, STATUS ='R' where ORDERID= rec.ORDERID and CLEARDATE = to_date(rec.cleardate, systemnums.c_date_format);

                    UPDATE STSCHD
                         SET AAMT = AAMT - v_dblSTSAMT
                             WHERE AUTOID = v_dblStsID;
                    v_dblADAMT:= v_dblADAMT - v_dblSTSAMT;

                 end if;
                 exit when v_dblADAMT <= 0;
             end loop;
        End Loop; -- Rootrec

        Update ADMAST Set Status = 'R' where AUTOID = P_TXMSG.TXFIELDS('02').VALUE;
    Else
        --Giao dich batch khong thuc hien revert.
        --Neu muon giao dich bang tay di qua day thi viet them phan revert tai day
        p_err_code:=0;
    End If;

    plog.debug (pkgctx, '<<END OF fn_RejectAdvancedPayment');
    plog.setendsection (pkgctx, 'fn_RejectAdvancedPayment');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_RejectAdvancedPayment');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_RejectAdvancedPayment;


 ---------------------------------fn_OrderAdvancedPayment------------------------------------------------
FUNCTION fn_OrderAdvancedPayment(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_count number(20,0);
v_dblMaxAdvanceAmount   number(20,4);
v_dblADAMT  number(20,4);
v_dblADFAMT  number(20,4);
v_dblADFeeRate number(20,4);
v_dblStsID  number(20,4);
v_dblSTSEXAMT number(20,4);
v_dblSTSAMT number(20,4);
v_dblSTSFAMT   number(20,4);
v_dblautoid number(20,0);
v_DealPaid number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_OrderAdvancedPayment');
    plog.debug (pkgctx, '<<BEGIN OF fn_OrderAdvancedPayment');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    if not v_blnREVERSAL then
        select autoid into v_dblautoid from stschd where STATUS='N' AND DUETYPE='RM' AND DELTD='N' and ORGORDERID=p_txmsg.txfields('05').value;
        UPDATE STSCHD SET AAMT=round(AAMT+p_txmsg.txfields('10').value+p_txmsg.txfields('15').value,0), FAMT=round(FAMT+p_txmsg.txfields('11').value,0)
        WHERE autoid=v_dblautoid;

        v_DealPaid:=round(to_number(p_txmsg.txfields('15').value)+to_number(p_txmsg.txfields('22').value)+to_number(p_txmsg.txfields('23').value)-to_number(p_txmsg.txfields('25').value),0);
        plog.debug (pkgctx, 'begin fn_OrderAdvancedPayment');
        if v_DealPaid>0 then
            CSPKS_DFPROC.pr_ADVDFPayment(p_txmsg,v_dblautoid,v_DealPaid,p_err_code);
        end if;
    else
        --Giao dich batch khong thuc hien revert.
        --Neu muon giao dich bang tay di qua day thi viet them phan revert tai day
        p_err_code:=0;
    end if;
    plog.debug (pkgctx, '<<END OF fn_OrderAdvancedPayment');
    plog.setendsection (pkgctx, 'fn_OrderAdvancedPayment');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_OrderAdvancedPayment');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_OrderAdvancedPayment;

  ---------------------------------pr_CIAutoAdvance------------------------------------------------
  PROCEDURE pr_CIAutoAdvance(p_txmsg in tx.msg_rectype,p_orderid varchar,p_advamt number,p_rcvamt number,p_err_code  OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_blnVietnamese BOOLEAN;
      l_err_param varchar2(300);
      l_MaxRow NUMBER(20,0);
      l_dblamount number(20,0);
      l_dblbalance number(20,0);
      l_dblfee number(20,0);
      l_dbladvamt number(20,0);
      --l_dblDEBTAMT number(20,0);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_CIAutoAdvance');


    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='1143';
     SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';

    begin
        l_txmsg.tlid        := p_txmsg.tlid;
    exception when others then
        l_txmsg.tlid        := systemnums.c_system_userid;
    end;
    plog.debug(pkgctx, 'l_txmsg.tlid' || l_txmsg.tlid);
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.txtime      := to_char(sysdate,'HH24:MM:SS');
    begin
        l_txmsg.batchname   := p_txmsg.TXNUM;
    exception when others then
        l_txmsg.batchname   := 'ADV';
    end;

    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='1143';
    plog.debug(pkgctx, 'Begin loop');
    l_dblamount:=0;


    --Xac dinh xem lenh co lich ung truoc ma CI khong du thanh toan
    for rec in
    (
       SELECT ISMORTAGE,AFACCTNO,AMT,QTTY,FULLNAME,ADDRESS,LICENSE,FAMT,CUSTODYCD,SYMBOL,AAMT,ORGORDERID,PAIDAMT,
            PAIDFEEAMT,FEERATE,MINBAL,TXDATE,DES,CLEARDATE,DAYS,
            GREATEST(LEAST(ROUND(ADVAMT*(1-FEERATE*DAYS/100/360)), ADVAMT-MINBAL),0) DEPOAMT,
            GREATEST(LEAST(ROUND(ADVAMT*(1-FEERATE*DAYS/100/360)), ADVAMT-MINBAL),0) MAXDEPOAMT,
            GREATEST(ADVAMT,0) ADVAMT
        FROM (
            SELECT  1 ISMORTAGE,STSCHD.AFACCTNO,AMT,QTTY,CFMAST.FULLNAME,CFMAST.ADDRESS,CFMAST.idcode LICENSE,FAMT,
                    CUSTODYCD,STSCHD.SYMBOL,AAMT,ORGORDERID,PAIDAMT,PAIDFEEAMT,
                    SYSVAR1.VARVALUE FEERATE,SYSVAR2.VARVALUE MINBAL,STSCHD.TXDATE,
                    'UTTB cua lenh ' || STSCHD.SYMBOL || ' so ' || substr(ORGORDERID,11,6) || ' khop ngay ' || STSCHD.TXDATE  DES, STSCHD.CLEARDATE,
                (CASE WHEN CLEARDATE -(CASE WHEN LENGTH(SYSVAR.VARVALUE)=10 THEN TO_DATE(SYSVAR.VARVALUE,'DD/MM/YYYY') ELSE CLEARDATE END)=0 THEN 1 ELSE   CLEARDATE -(CASE WHEN LENGTH(SYSVAR.VARVALUE)=10 THEN TO_DATE(SYSVAR.VARVALUE,'DD/MM/YYYY') ELSE CLEARDATE END)END) DAYS,
                ROUND(LEAST(AMT*(100-ODTYPE.DEFFEERATE-STSCHD.SECDUTY)/100,
                      AMT*(100-STSCHD.SECDUTY)/100-ODTYPE.MINFEEAMT)-AAMT-FAMT+PAIDAMT+PAIDFEEAMT) ADVAMT
            FROM
            (SELECT STS.ORGORDERID,STS.TXDATE,MAX(STS.AFACCTNO) AFACCTNO, MAX(STS.CODEID) CODEID,
                    MAX(STS.CLEARDAY) CLEARDAY,MAX(STS.CLEARCD) CLEARCD,SUM(STS.AMT) AMT,
                    SUM(STS.QTTY) QTTY,SUM(STS.FAMT) FAMT,SUM(STS.AAMT) AAMT,SUM(STS.PAIDAMT) PAIDAMT,
                    SUM(STS.PAIDFEEAMT) PAIDFEEAMT,MAX(MST.actype) ACTYPE,MAX(MST.EXECTYPE) EXECTYPE,
                    MAX(AF.custid) CUSTID,max(sts.CLEARDATE) CLEARDATE,MAX(SEC.SYMBOL) SYMBOL,
                   (CASE WHEN MAX(TYP.VAT)='Y' THEN TO_NUMBER(MAX(SYS.VARVALUE)) ELSE 0 END) SECDUTY
                FROM STSCHD STS,ODMAST MST,AFMAST AF,SBSECURITIES SEC, AFTYPE TYP, SYSVAR SYS
                WHERE STS.codeid=SEC.codeid AND STS.orgorderid=MST.orderid and mst.afacctno=af.acctno
                AND STS.DELTD <> 'Y' AND STS.STATUS='N' AND STS.DUETYPE='RM'
                    AND AF.ACTYPE=TYP.ACTYPE AND SYS.VARNAME='ADVSELLDUTY' AND SYS.GRNAME='SYSTEM'
                    GROUP BY STS.ORGORDERID,STS.TXDATE
             ) STSCHD,SYSVAR,SYSVAR SYSVAR1,SYSVAR SYSVAR2,ODTYPE,CFMAST
            WHERE AMT+PAIDAMT-AAMT>0
            AND SYSVAR.VARNAME='CURRDATE' AND SYSVAR.GRNAME='SYSTEM'
            AND SYSVAR1.VARNAME='AINTRATE' AND SYSVAR1.GRNAME='SYSTEM'
            AND SYSVAR2.VARNAME='AMINBAL' AND SYSVAR2.GRNAME='SYSTEM'
            AND STSCHD.CUSTID=CFMAST.CUSTID
            AND STSCHD.ACTYPE=ODTYPE.ACTYPE
        ) A WHERE DAYS>0 AND ADVAMT>0 AND ORGORDERID=p_orderid
    )
    loop
        if rec.DEPOAMT + 2 < p_advamt then
            p_err_code := '-700061'; --Ung qua so tien duoc phep
            RETURN;
        end if;
        l_dblamount :=round(least(rec.DEPOAMT,p_advamt),0);
        l_dblfee:=round(greatest(l_dblamount*(rec.days*rec.feerate/36000)/(1-rec.days*rec.feerate/36000),rec.MINBAL),0);
        l_dbladvamt:=round(l_dblamount+l_dblfee,0);
        IF l_dblamount>0 THEN
            --Set txnum
            plog.debug(pkgctx, 'Loop for account:' || rec.AFACCTNO || ' ngay' || to_char(rec.cleardate));
            SELECT systemnums.C_BATCH_PREFIXED
                             || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                      INTO l_txmsg.txnum
                      FROM DUAL;
            --l_txmsg.brid        := substr(rec.AFACCTNO,1,4);
            begin
                l_txmsg.brid        := p_txmsg.BRID;
            exception when others then
                l_txmsg.brid        := substr(rec.AFACCTNO,1,4);
            end;

            --Set cac field giao dich
            --03   ACCTNO       C
            l_txmsg.txfields ('03').defname   := 'ACCTNO';
            l_txmsg.txfields ('03').TYPE      := 'C';
            l_txmsg.txfields ('03').VALUE     := rec.AFACCTNO;
            --05    ORGORDERID  C
            l_txmsg.txfields ('05').defname   := 'ORGORDERID';
            l_txmsg.txfields ('05').TYPE      := 'C';
            l_txmsg.txfields ('05').VALUE     := rec.ORGORDERID;
             --07   ADVAMT          N
            l_txmsg.txfields ('07').defname   := 'ADVAMT';
            l_txmsg.txfields ('07').TYPE      := 'N';
            l_txmsg.txfields ('07').VALUE     := round(l_dbladvamt,0);
            --08    ORDATE      C
            l_txmsg.txfields ('08').defname   := 'ORDATE';
            l_txmsg.txfields ('08').TYPE      := 'C';
            l_txmsg.txfields ('08').VALUE     := to_char(rec.CLEARDATE,'DD/MM/RRRR');
            --09    DUEDATE      C
            l_txmsg.txfields ('09').defname   := 'DUEDATE';
            l_txmsg.txfields ('09').TYPE      := 'C';
            l_txmsg.txfields ('09').VALUE     := to_char(rec.TXDATE,'DD/MM/RRRR');
            --10    AMT         N
            l_txmsg.txfields ('10').defname   := 'AMT';
            l_txmsg.txfields ('10').TYPE      := 'N';
            l_txmsg.txfields ('10').VALUE     := round(l_dblamount,0);
            --11    FEEAMT      N
            l_txmsg.txfields ('11').defname   := 'FEEAMT';
            l_txmsg.txfields ('11').TYPE      := 'N';
            l_txmsg.txfields ('11').VALUE     := round(l_dblfee,0);

            --12    INTRATE     N
            l_txmsg.txfields ('12').defname   := 'INTRATE';
            l_txmsg.txfields ('12').TYPE      := 'N';
            l_txmsg.txfields ('12').VALUE     := rec.FEERATE;
            --13    DAYS        N
            l_txmsg.txfields ('13').defname   := 'DAYS';
            l_txmsg.txfields ('13').TYPE      := 'N';
            l_txmsg.txfields ('13').VALUE     := rec.DAYS;
            --15    ODAMT       N
            l_txmsg.txfields ('15').defname   := 'ODAMT';
            l_txmsg.txfields ('15').TYPE      := 'N';
            l_txmsg.txfields ('15').VALUE     := 0;
            --16    MINBAL      N
            l_txmsg.txfields ('16').defname   := 'MINBAL';
            l_txmsg.txfields ('16').TYPE      := 'N';
            l_txmsg.txfields ('16').VALUE     := round(rec.MINBAL,0);
            --17  ALLPAID     N
            l_txmsg.txfields ('17').defname   := 'ALLPAID';
            l_txmsg.txfields ('17').TYPE      := 'N';
            l_txmsg.txfields ('17').VALUE     := 0;
            --18  PRINTPAID   N
            l_txmsg.txfields ('18').defname   := 'PRINTPAID';
            l_txmsg.txfields ('18').TYPE      := 'N';
            l_txmsg.txfields ('18').VALUE     := 0;
            --19  INTPAID     N
            l_txmsg.txfields ('19').defname   := 'INTPAID';
            l_txmsg.txfields ('19').TYPE      := 'N';
            l_txmsg.txfields ('19').VALUE     := 0;
            --21  RLSDATE     C
            l_txmsg.txfields ('21').defname   := 'RLSDATE';
            l_txmsg.txfields ('21').TYPE      := 'C';
            l_txmsg.txfields ('21').VALUE     := v_strCURRDATE;
            --22  DEBTAMT     N
            l_txmsg.txfields ('22').defname   := 'DEBTAMT';
            l_txmsg.txfields ('22').TYPE      := 'N';
            l_txmsg.txfields ('22').VALUE     := 0;
            --23  CASHAMT     N
            l_txmsg.txfields ('23').defname   := 'CASHAMT';
            l_txmsg.txfields ('23').TYPE      := 'N';
            l_txmsg.txfields ('23').VALUE     := 0;
            --25  PAIDDEBTAMT N
            l_txmsg.txfields ('25').defname   := 'PAIDDEBTAMT';
            l_txmsg.txfields ('25').TYPE      := 'N';
            l_txmsg.txfields ('25').VALUE     := 0;
            --26  MAXADVAMT   N
            l_txmsg.txfields ('26').defname   := 'MAXADVAMT';
            l_txmsg.txfields ('26').TYPE      := 'N';
            l_txmsg.txfields ('26').VALUE     := round(rec.ADVAMT,0);
            --20    MAXAMT      N
            l_txmsg.txfields ('20').defname   := 'MAXAMT';
            l_txmsg.txfields ('20').TYPE      := 'N';
            l_txmsg.txfields ('20').VALUE     := round(rec.MAXDEPOAMT,0);
            --30    DESC        C
            l_txmsg.txfields ('30').defname   := 'DESC';
            l_txmsg.txfields ('30').TYPE      := 'C';
            l_txmsg.txfields ('30').VALUE     := rec.DES;
            --40    3600        C
            l_txmsg.txfields ('40').defname   := '3600';
            l_txmsg.txfields ('40').TYPE      := 'C';
            l_txmsg.txfields ('40').VALUE     := 36000;
            --41    ZERO        C
            l_txmsg.txfields ('41').defname   := 'ZERO';
            l_txmsg.txfields ('41').TYPE      := 'C';
            l_txmsg.txfields ('41').VALUE     := 0;
            --90    CUSTNAME    C
            l_txmsg.txfields ('90').defname   := 'CUSTNAME';
            l_txmsg.txfields ('90').TYPE      := 'C';
            l_txmsg.txfields ('90').VALUE     := rec.FULLNAME;
            --91    ADDRESS     C
            l_txmsg.txfields ('91').defname   := 'ADDRESS';
            l_txmsg.txfields ('91').TYPE      := 'C';
            l_txmsg.txfields ('91').VALUE     := rec.ADDRESS;
            --92    LICENSE     C
            l_txmsg.txfields ('92').defname   := 'LICENSE';
            l_txmsg.txfields ('92').TYPE      := 'C';
            l_txmsg.txfields ('92').VALUE     := rec.LICENSE;

            BEGIN
                IF txpks_#1143.fn_batchtxprocess (l_txmsg,
                                                 p_err_code,
                                                 l_err_param
                   ) <> systemnums.c_success
                THEN
                   plog.debug (pkgctx,
                               'got error 1143: ' || p_err_code
                   );
                   ROLLBACK;
                   RETURN;
                END IF;
            END;

        END IF;

    end loop;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_CIAutoAdvance');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on release pr_CIAutoAdvance');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_CIAutoAdvance');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_CIAutoAdvance;




PROCEDURE pr_DFAutoAdvance (p_groupid varchar,p_vndselldf number,p_err_code  OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_blnVietnamese BOOLEAN;
      l_err_param varchar2(300);
      l_MaxRow NUMBER(20,0);
      l_dblamount number(20,0);
      l_dblbalance number(20,0);
      l_dblfee number(20,0);
      l_dbladvamt number(20,0);
      l_vnselldf number(20,0);
      --l_dblDEBTAMT number(20,0);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_DFAutoAdvance');

    l_vnselldf  := p_vndselldf;

    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='1143';
     SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;

    plog.debug(pkgctx, 'l_txmsg.tlid: 1143');
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.txtime      := to_char(sysdate,'HH24:MM:SS');

    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='1143';
    plog.debug(pkgctx, 'Begin loop');
    l_dblamount:=0;


    --Xac dinh xem lenh co lich ung truoc ma CI khong du thanh toan
    for rec in
    (
       SELECT C.GROUPID, B.refid DFACCTNO, A.ISMORTAGE,A.AFACCTNO,A.AMT,A.QTTY,B.EXECQTTY,A.FULLNAME,A.ADDRESS,A.LICENSE,A.FAMT,A.CUSTODYCD,A.SYMBOL,A.AAMT,A.ORGORDERID,A.PAIDAMT,
            A.PAIDFEEAMT,A.FEERATE,A.MINBAL,A.TXDATE,A.DES,A.CLEARDATE,A.DAYS,
            GREATEST(LEAST(ROUND(A.ADVAMT*(1-A.FEERATE*A.DAYS/100/360)), A.ADVAMT-A.MINBAL),0) DEPOAMT,
            GREATEST(LEAST(ROUND(A.ADVAMT*(1-A.FEERATE*A.DAYS/100/360)), A.ADVAMT-A.MINBAL),0) MAXDEPOAMT,
            GREATEST(A.ADVAMT,0) ADVAMT
        FROM (
            SELECT  1 ISMORTAGE,STSCHD.AFACCTNO,AMT,QTTY,CFMAST.FULLNAME,CFMAST.ADDRESS,CFMAST.idcode LICENSE,FAMT,
                    CUSTODYCD,STSCHD.SYMBOL,AAMT,ORGORDERID,PAIDAMT,PAIDFEEAMT,
                    SYSVAR1.VARVALUE FEERATE,SYSVAR2.VARVALUE MINBAL,STSCHD.TXDATE,
                    'UTTB cua lenh ' || STSCHD.SYMBOL || ' so ' || substr(ORGORDERID,11,6) || ' khop ngay ' || STSCHD.TXDATE  DES, STSCHD.CLEARDATE,
                (CASE WHEN CLEARDATE -(CASE WHEN LENGTH(SYSVAR.VARVALUE)=10 THEN TO_DATE(SYSVAR.VARVALUE,'DD/MM/YYYY') ELSE CLEARDATE END)=0 THEN 1 ELSE   CLEARDATE -(CASE WHEN LENGTH(SYSVAR.VARVALUE)=10 THEN TO_DATE(SYSVAR.VARVALUE,'DD/MM/YYYY') ELSE CLEARDATE END)END) DAYS,
                ROUND(LEAST(AMT*(100-ODTYPE.DEFFEERATE-STSCHD.SECDUTY)/100,
                      AMT*(100-STSCHD.SECDUTY)/100-ODTYPE.MINFEEAMT)-AAMT-FAMT+PAIDAMT+PAIDFEEAMT) ADVAMT
            FROM
            (SELECT STS.ORGORDERID,STS.TXDATE,MAX(STS.AFACCTNO) AFACCTNO, MAX(STS.CODEID) CODEID,
                    MAX(STS.CLEARDAY) CLEARDAY,MAX(STS.CLEARCD) CLEARCD,SUM(STS.AMT) AMT,
                    SUM(STS.QTTY) QTTY,SUM(STS.FAMT) FAMT,SUM(STS.AAMT) AAMT,SUM(STS.PAIDAMT) PAIDAMT,
                    SUM(STS.PAIDFEEAMT) PAIDFEEAMT,MAX(MST.actype) ACTYPE,MAX(MST.EXECTYPE) EXECTYPE,
                    MAX(AF.custid) CUSTID,max(sts.CLEARDATE) CLEARDATE,MAX(SEC.SYMBOL) SYMBOL,
                   (CASE WHEN MAX(TYP.VAT)='Y' THEN TO_NUMBER(MAX(SYS.VARVALUE)) ELSE 0 END) SECDUTY
                FROM STSCHD STS,ODMAST MST,AFMAST AF,SBSECURITIES SEC, AFTYPE TYP, SYSVAR SYS
                WHERE STS.codeid=SEC.codeid AND STS.orgorderid=MST.orderid and mst.afacctno=af.acctno
                AND STS.DELTD <> 'Y' AND STS.STATUS='N' AND STS.DUETYPE='RM'
                    AND AF.ACTYPE=TYP.ACTYPE AND SYS.VARNAME='ADVSELLDUTY' AND SYS.GRNAME='SYSTEM'
                    GROUP BY STS.ORGORDERID,STS.TXDATE
             ) STSCHD,SYSVAR,SYSVAR SYSVAR1,SYSVAR SYSVAR2,ODTYPE,CFMAST
            WHERE AMT+PAIDAMT-AAMT>0
            AND SYSVAR.VARNAME='CURRDATE' AND SYSVAR.GRNAME='SYSTEM'
            AND SYSVAR1.VARNAME='AINTRATE' AND SYSVAR1.GRNAME='SYSTEM'
            AND SYSVAR2.VARNAME='AMINBAL' AND SYSVAR2.GRNAME='SYSTEM'
            AND STSCHD.CUSTID=CFMAST.CUSTID
            AND STSCHD.ACTYPE=ODTYPE.ACTYPE
            AND STSCHD.txdate=to_date((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/YYYY')
        ) A , ODMAPEXT B, DFMAST C

        WHERE A.DAYS>0 AND A.ADVAMT>0 AND B.ORDERID=A.ORGORDERID AND B.REFID=C.ACCTNO
        AND C.GROUPID= p_groupid
    )
    loop

        exit when l_vnselldf = 0;

        if rec.DEPOAMT + 2 < p_vndselldf then
            p_err_code := '-700061'; --Ung qua so tien duoc phep
            RETURN;
        end if;
        l_dblamount :=round(least(rec.DEPOAMT,l_vnselldf),0);
        l_dblfee:=round(greatest(l_dblamount*(rec.days*rec.feerate/36000)/(1-rec.days*rec.feerate/36000),rec.MINBAL),0);
        l_dbladvamt:=round(l_dblamount+l_dblfee,0);

        l_vnselldf:=  l_vnselldf - round(least(rec.DEPOAMT,l_vnselldf),0);

        IF l_dblamount>0 THEN
            --Set txnum
            plog.debug(pkgctx, 'Loop for account:' || rec.AFACCTNO || ' ngay' || to_char(rec.cleardate));
            SELECT systemnums.C_BATCH_PREFIXED
                             || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                      INTO l_txmsg.txnum
                      FROM DUAL;
            l_txmsg.brid        := substr(rec.AFACCTNO,1,4);

            --Set cac field giao dich
            --03   ACCTNO       C
            l_txmsg.txfields ('03').defname   := 'ACCTNO';
            l_txmsg.txfields ('03').TYPE      := 'C';
            l_txmsg.txfields ('03').VALUE     := rec.AFACCTNO;
            --05    ORGORDERID  C
            l_txmsg.txfields ('05').defname   := 'ORGORDERID';
            l_txmsg.txfields ('05').TYPE      := 'C';
            l_txmsg.txfields ('05').VALUE     := rec.ORGORDERID;
             --07   ADVAMT          N
            l_txmsg.txfields ('07').defname   := 'ADVAMT';
            l_txmsg.txfields ('07').TYPE      := 'N';
            l_txmsg.txfields ('07').VALUE     := round(l_dbladvamt,0);
            --08    ORDATE      C
            l_txmsg.txfields ('08').defname   := 'ORDATE';
            l_txmsg.txfields ('08').TYPE      := 'C';
            l_txmsg.txfields ('08').VALUE     := to_char(rec.CLEARDATE,'DD/MM/RRRR');
            --09    DUEDATE      C
            l_txmsg.txfields ('09').defname   := 'DUEDATE';
            l_txmsg.txfields ('09').TYPE      := 'C';
            l_txmsg.txfields ('09').VALUE     := to_char(rec.TXDATE,'DD/MM/RRRR');
            --10    AMT         N
            l_txmsg.txfields ('10').defname   := 'AMT';
            l_txmsg.txfields ('10').TYPE      := 'N';
            l_txmsg.txfields ('10').VALUE     := round(l_dblamount,0);
            --11    FEEAMT      N
            l_txmsg.txfields ('11').defname   := 'FEEAMT';
            l_txmsg.txfields ('11').TYPE      := 'N';
            l_txmsg.txfields ('11').VALUE     := round(l_dblfee,0);

            --12    INTRATE     N
            l_txmsg.txfields ('12').defname   := 'INTRATE';
            l_txmsg.txfields ('12').TYPE      := 'N';
            l_txmsg.txfields ('12').VALUE     := rec.FEERATE;
            --13    DAYS        N
            l_txmsg.txfields ('13').defname   := 'DAYS';
            l_txmsg.txfields ('13').TYPE      := 'N';
            l_txmsg.txfields ('13').VALUE     := rec.DAYS;
            --15    ODAMT       N
            l_txmsg.txfields ('15').defname   := 'ODAMT';
            l_txmsg.txfields ('15').TYPE      := 'N';
            l_txmsg.txfields ('15').VALUE     := 0;
            --16    MINBAL      N
            l_txmsg.txfields ('16').defname   := 'MINBAL';
            l_txmsg.txfields ('16').TYPE      := 'N';
            l_txmsg.txfields ('16').VALUE     := round(rec.MINBAL,0);
            --17  ALLPAID     N
            l_txmsg.txfields ('17').defname   := 'ALLPAID';
            l_txmsg.txfields ('17').TYPE      := 'N';
            l_txmsg.txfields ('17').VALUE     := 0;
            --18  PRINTPAID   N
            l_txmsg.txfields ('18').defname   := 'PRINTPAID';
            l_txmsg.txfields ('18').TYPE      := 'N';
            l_txmsg.txfields ('18').VALUE     := 0;
            --19  INTPAID     N
            l_txmsg.txfields ('19').defname   := 'INTPAID';
            l_txmsg.txfields ('19').TYPE      := 'N';
            l_txmsg.txfields ('19').VALUE     := 0;
            --21  RLSDATE     C
            l_txmsg.txfields ('21').defname   := 'RLSDATE';
            l_txmsg.txfields ('21').TYPE      := 'C';
            l_txmsg.txfields ('21').VALUE     := v_strCURRDATE;
            --22  DEBTAMT     N
            l_txmsg.txfields ('22').defname   := 'DEBTAMT';
            l_txmsg.txfields ('22').TYPE      := 'N';
            l_txmsg.txfields ('22').VALUE     := 0;
            --23  CASHAMT     N
            l_txmsg.txfields ('23').defname   := 'CASHAMT';
            l_txmsg.txfields ('23').TYPE      := 'N';
            l_txmsg.txfields ('23').VALUE     := 0;
            --25  PAIDDEBTAMT N
            l_txmsg.txfields ('25').defname   := 'PAIDDEBTAMT';
            l_txmsg.txfields ('25').TYPE      := 'N';
            l_txmsg.txfields ('25').VALUE     := 0;
            --26  MAXADVAMT   N
            l_txmsg.txfields ('26').defname   := 'MAXADVAMT';
            l_txmsg.txfields ('26').TYPE      := 'N';
            l_txmsg.txfields ('26').VALUE     := round(rec.ADVAMT,0);
            --20    MAXAMT      N
            l_txmsg.txfields ('20').defname   := 'MAXAMT';
            l_txmsg.txfields ('20').TYPE      := 'N';
            l_txmsg.txfields ('20').VALUE     := round(rec.MAXDEPOAMT,0);
            --30    DESC        C
            l_txmsg.txfields ('30').defname   := 'DESC';
            l_txmsg.txfields ('30').TYPE      := 'C';
            l_txmsg.txfields ('30').VALUE     := rec.DES;
            --40    3600        C
            l_txmsg.txfields ('40').defname   := '3600';
            l_txmsg.txfields ('40').TYPE      := 'C';
            l_txmsg.txfields ('40').VALUE     := 36000;
            --41    ZERO        C
            l_txmsg.txfields ('41').defname   := 'ZERO';
            l_txmsg.txfields ('41').TYPE      := 'C';
            l_txmsg.txfields ('41').VALUE     := 0;
            --90    CUSTNAME    C
            l_txmsg.txfields ('90').defname   := 'CUSTNAME';
            l_txmsg.txfields ('90').TYPE      := 'C';
            l_txmsg.txfields ('90').VALUE     := rec.FULLNAME;
            --91    ADDRESS     C
            l_txmsg.txfields ('91').defname   := 'ADDRESS';
            l_txmsg.txfields ('91').TYPE      := 'C';
            l_txmsg.txfields ('91').VALUE     := rec.ADDRESS;
            --92    LICENSE     C
            l_txmsg.txfields ('92').defname   := 'LICENSE';
            l_txmsg.txfields ('92').TYPE      := 'C';
            l_txmsg.txfields ('92').VALUE     := rec.LICENSE;

            BEGIN
                IF txpks_#1143.fn_batchtxprocess (l_txmsg,
                                                 p_err_code,
                                                 l_err_param
                   ) <> systemnums.c_success
                THEN
                   plog.debug (pkgctx,
                               'got error 1143: ' || p_err_code
                   );
                   ROLLBACK;
                   RETURN;
                END IF;
            END;

        END IF;

    end loop;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_DFAutoAdvance');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on release pr_DFAutoAdvance');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.debug(pkgctx,'pr_DFAutoAdvance: ' || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_DFAutoAdvance');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_DFAutoAdvance;



FUNCTION fn_cimastcidfpofeeacr(strACCTNO IN varchar2, strTXDATE IN DATE, dblAMT IN NUMBER)
  RETURN  number
  IS
  v_strCURRDATE DATE;
  v_strCOMPANYCD varchar2(10);
  v_Result  number(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_cimastcidfpofeeacr');
    plog.debug (pkgctx, '<<BEGIN OF fn_cimastcidfpofeeacr');

    --GET TDMAST ATRIBUTES
    SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') into v_strCURRDATE FROM SYSVAR  WHERE VARNAME='CURRDATE';
    SELECT VARVALUE || '%' into v_strCOMPANYCD FROM SYSVAR  WHERE VARNAME='COMPANYCD';

    select round(mst.cidepofee,4) into v_Result
    from
      (
          select af.acctno,ic.ICFLAT,
          (dblAMT*ic.ICFLAT*(v_strCURRDATE-TO_DATE(strTXDATE,'DD/MM/YYYY'))/30) cidepofee
          from cfmast cf, afmast af,
               (
                       SELECT actype, ICFLAT FROM ICCFTYPEDEF WHERE EVENTCODE='FEEDEPOSITSE'
                ) ic, cimast ci
          where cf.custid = af.custid
              and cf.custatcom='Y'
              and af.status not in ('N','C')
              and ci.afacctno = af.acctno
              and ci.actype = ic.actype
             and af.acctno=strACCTNO
      ) mst
      ;

    plog.debug (pkgctx, '<<END OF fn_cimastcidfpofeeacr');
    plog.setendsection (pkgctx, 'fn_cimastcidfpofeeacr');
    RETURN v_result;
EXCEPTION
WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_cimastcidfpofeeacr');
      RETURN 0;
END fn_CIMastcidfPOfeeacr;

FUNCTION fn_CIDateFeeacr(strACCTNO IN varchar2, strNumDATE IN  NUMBER)
  RETURN  number
  IS
  v_strCURRDATE DATE;
  v_strDATEFEE DATE;
  v_strCOMPANYCD varchar2(10);
  v_Result  number(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_CIDateFeeacr');
    plog.debug (pkgctx, '<<BEGIN OF fn_CIDateFeeacr');

    --GET TDMAST ATRIBUTES
    SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') into v_strCURRDATE FROM SYSVAR  WHERE VARNAME='CURRDATE';
    SELECT VARVALUE || '%' into v_strCOMPANYCD FROM SYSVAR  WHERE VARNAME='COMPANYCD';

    SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') into v_strCURRDATE FROM SYSVAR  WHERE VARNAME='CURRDATE';

    SELECT SBDATE into v_strDATEFEE
    FROM (
          SELECT ROWNUM DAY, SBDATE
          FROM
            (
                 SELECT * FROM SBCLDR
                 WHERE CLDRTYPE='000'
                       AND SBDATE>=v_strCURRDATE
                       AND SBDATE < v_strCURRDATE+15
                       AND HOLIDAY='N'
                 ORDER BY SBDATE
            ) CLDR
          ) RL
    WHERE DAY=strNumDATE+1;

      select round(mst.cidepofee,4)  into v_Result
      from
      (
        select af.acctno, sum((se.trade + se.margin + se.mortage + se.blocked + se.secured + se.repo + se.netting + se.dtoclose + se.withdraw)*ic.ICFLAT*(TO_DATE(v_strDATEFEE,'DD/MM/YYYY')-TO_DATE(v_strCURRDATE,'DD/MM/YYYY'))/30) cidepofee
        from cfmast cf, afmast af,  semast se, sbsecurities sb,
             (
                     SELECT actype, ICFLAT FROM ICCFTYPEDEF WHERE EVENTCODE='FEEDEPOSITSE' AND modcode ='CI'
              ) ic, cimast ci
        where cf.custid = af.custid and af.acctno = se.afacctno
            and se.codeid = sb.codeid
            and sb.sectype in ('001','002','011','003','006')
            and sb.tradeplace in ('001','002','005')
            and cf.custatcom='Y'
            and af.status not in ('N','C')
            and ci.afacctno = af.acctno
            and ci.actype = ic.actype
            and af.acctno=strACCTNO
        group by af.acctno
        having sum(se.trade + se.margin + se.mortage + se.blocked + se.secured + se.repo + se.netting + se.dtoclose + se.withdraw) >0
      ) mst
      ;

    plog.debug (pkgctx, '<<END OF fn_CIDateFeeacr');
    plog.setendsection (pkgctx, 'fn_CIDateFeeacr');
    RETURN v_result;
EXCEPTION
WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_CIDateFeeacr');
      RETURN 0;
END fn_CIDateFeeacr;


---------------------------------fn_FeeDepositoryMaturityBackdate------------------------------------------------
FUNCTION fn_FeeDepoMaturityBackdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_count number(20,0);
v_afacctno VARCHAR2(10);
v_dblAMT NUMBER;
v_todate DATE;
v_frdatetemp DATE;
v_todatetemp DATE;
v_dblamttemp NUMBER;
v_dblamtacr NUMBER;
v_dateEOMtemp DATE;
v_TBALDT DATE;
v_count_days NUMBER;
V_txdate DATE;
l_txnum VARCHAR2(30);
V_seacctno VARCHAR2(20);
L_QTTY NUMBER(20,0);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_FeeDepositoryMaturityBackdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_FeeDepositoryMaturityBackdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    -- case cac truong cho cac jao dich
    if( p_txmsg.tltxcd='2246') THEN
     v_afacctno:=p_txmsg.txfields('02').VALUE;
     v_seacctno:=p_txmsg.txfields('03').VALUE;
     L_QTTY:=TO_NUMBER(p_txmsg.txfields('12').VALUE);
     ELSIF(p_txmsg.tltxcd='8879') THEN
        v_afacctno:=p_txmsg.txfields('07').VALUE;
        v_seacctno:=p_txmsg.txfields('08').VALUE;
        L_QTTY:=TO_NUMBER(p_txmsg.txfields('10').VALUE);
    ELSE
    v_afacctno:=p_txmsg.txfields('04').VALUE;
     v_seacctno:=p_txmsg.txfields('05').VALUE;
     L_QTTY:=TO_NUMBER(p_txmsg.txfields('10').VALUE);
    END IF;
    IF (p_txmsg.tltxcd='8879') THEN
       v_dblAMT:=p_txmsg.txfields('17').VALUE;
      ELSE
    v_dblAMT:=p_txmsg.txfields('15').VALUE;
    END IF;

    v_todate:= to_date (p_txmsg.txfields('32').VALUE,'DD/MM/RRRR');
    v_frdatetemp:=to_date( p_txmsg.busdate,'DD/MM/RRRR');
    v_dblamtacr:=0;

    -- khai cac bien de log vao sedepobal
    v_TBALDT:= Greatest(to_date ( p_txmsg.txfields('32').value,'DD/MM/RRRR')+1, p_txmsg.busdate);
    V_txdate:=TO_DATE(p_txmsg.txdate,'DD/MM/RRRR');
    l_txnum:=p_txmsg.txnum;
    if not v_blnREVERSAL THEN
      --CHieu  thuan giao dich
      -- select ra cac moc thu phi lk den han
       plog.debug(pkgctx,'busdate ' || to_date(p_txmsg.busdate,'DD/MM/RRRR') || ' todate '||to_date(v_todate,'DD/MM/RRRR'));
    --Loi luu ky 2 lan do co 2 ngay cuoi thang
      --FOR rec IN
      --(SELECT to_date(sbdate,'DD/MM/RRRR') sbdate FROM sbcldr WHERE sbdate >=to_date(p_txmsg.busdate,'DD/MM/RRRR') AND sbdate<= to_date(v_todate,'DD/MM/RRRR')
      --AND sbeom='Y' AND cldrtype='000' ORDER BY sbdate)
        WHILE
            ADD_MONTHS(TRUNC(v_frdatetemp,'MM'), 1) - 1 <= v_todate

    --End Loi luu ky 2 lan do co 2 ngay cuoi thang
        LOOP
             plog.debug(pkgctx,'first' || v_frdatetemp || ' busdate ' || to_date(p_txmsg.busdate,'DD/MM/RRRR') ||' to_Date' ||  to_date(v_todate,'DD/MM/RRRR'));
            -- lay ra ngay cuoi cung cua thang
            SELECT ADD_MONTHS(TRUNC(v_frdatetemp, 'MM'), 1) -1 INTO v_dateEOMtemp FROM DUAL;
            v_todatetemp:=to_Date(v_dateEOMtemp,'DD/MM/RRRR');

            if(v_todatetemp <> v_todate) THEN
            v_dblamttemp:=round( (v_todatetemp-v_frdatetemp+1)/(v_todate-p_txmsg.busdate+1)* v_dblAMT,0);
            v_dblamtacr:=v_dblamtacr+v_dblamttemp;
            ELSE -- neu la thang backdate gan nhat: lay tong- cac thang truoc: tranh sai so
              v_dblamttemp:=round (v_dblAMT-v_dblamtacr,0);
            END IF;
            INSERT INTO CIFEESCHD (AUTOID, AFACCTNO, FEETYPE, TXNUM, TXDATE, NMLAMT, PAIDAMT, FLOATAMT, FRDATE, TODATE, REFACCTNO, DELTD)
             VALUES (SEQ_CIFEESCHD.nextval,v_afacctno,'VSDDEP',p_txmsg.txnum,to_date(p_txmsg.txdate,'DD/MM/RRRR'),v_dblamttemp,0,0,v_frdatetemp,v_todatetemp,'','N');
            -- log them mot dong SEDEPOBAL

            INSERT INTO SEDEPOBAL (AUTOID, ACCTNO, TXDATE, DAYS, QTTY, DELTD,ID,AMT)
             VALUES (SEQ_SEDEPOBAL.NEXTVAL, v_seacctno,v_frdatetemp,v_todatetemp-v_frdatetemp+1,L_QTTY, 'N',to_char(v_txdate)||l_txnum,v_dblamttemp);

             plog.debug(pkgctx,'insert into CIFEESCHD' || v_frdatetemp );
             v_frdatetemp:=to_Date(v_todatetemp,'DD/MM/RRRR')+1;
        END LOOP;

    else
       -- xoa giao dich
       UPDATE cifeeschd SET deltd='Y'  WHERE TXNUM = p_txmsg.txnum AND TXDATE = to_date(p_txmsg.txdate,'DD/MM/RRRR');
       UPDATE sedepobal SET deltd='Y' WHERE id=to_char(V_txdate)||l_txnum ;
    end if;
    plog.debug (pkgctx, '<<END OF fn_FeeDepositoryMaturityBackdate');
    plog.setendsection (pkgctx, 'fn_FeeDepositoryMaturityBackdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_FeeDepositoryMaturityBackdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_FeeDepoMaturityBackdate;

FUNCTION fn_cidatedepofeeacr(strACCTNO IN varchar2, strNumDATE IN  NUMBER)
  RETURN  number
  IS

  v_Result  number(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_cidatedepofeeacr');
    plog.debug (pkgctx, '<<BEGIN OF fn_cidatedepofeeacr');

   SELECT FEEACR
   INTO v_Result
        FROM (
        SELECT A2.AFACCTNO,
          SUM(DECODE(A2.FORP,'P',A2.FEEAMT/100,A2.FEEAMT)*A2.SEBAL*strNumDATE/(A2.LOTDAY*A2.LOTVAL)) FEEACR
        FROM (SELECT T.ACCTNO, MIN(T.ODRNUM) RFNUM FROM VW_SEMAST_VSDDEP_FEETERM T GROUP BY T.ACCTNO) A1,
        VW_SEMAST_VSDDEP_FEETERM A2 WHERE A1.ACCTNO=A2.ACCTNO AND A1.RFNUM=A2.ODRNUM GROUP BY A2.AFACCTNO) T2
        WHERE  T2.AFACCTNO = strACCTNO;


    plog.debug (pkgctx, '<<END OF fn_cidatedepofeeacr');
    plog.setendsection (pkgctx, 'fn_cidatedepofeeacr');
    RETURN v_result;
EXCEPTION
WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_cidatedepofeeacr');
      RETURN 0;
END fn_cidatedepofeeacr;


---------------------------------pr_IRCreditInterestAccure------------------------------------------------
FUNCTION pr_IRCalcCreditInterest(pv_ACType In VARCHAR2, pv_AMT in Number, pv_RuleType Out VARCHAR2)
RETURN NUMBER
IS
    l_delta         Number(20,6);
    l_intrate       Number(20,6);
    l_ACType        VARCHAR2(4);
    l_RATEID        VARCHAR2(4);
    l_RATETERMCD    VARCHAR2(4);
    l_RateTerm      Number;
    l_RateType      VARCHAR2(4);
    l_RuleType      VARCHAR2(4);
BEGIN
    plog.setbeginsection (pkgctx, 'pr_IRCalcCreditInterest');
    plog.debug (pkgctx, '<<BEGIN OF pr_IRCalcCreditInterest');
    /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    l_ACType := pv_ACType;
    plog.debug (pkgctx, 'l_ACType:' || l_ACType);
    l_intrate   := 0;
    l_delta     := 0;
    BEGIN
        SELECT IR.RATEID, IR.RATE, IR.RATETERMCD, IR.RATETERM, IR.RATETYPE
        into l_RATEID, l_intrate, l_RATETERMCD, l_RateTerm, l_RuleType
        FROM IRRATE IR, CITYPE CI
        WHERE IR.RATEID = CI.RATEID AND CI.ACTYPE = l_ACType;
    EXCEPTION
        WHEN OTHERS THEN RETURN 0;
    END;

    pv_RuleType := l_RuleType;

    If l_RuleType = 'T' THEN
       Begin
           select Delta into l_delta
           from irrateschm
           where rateid = l_RATEID and framt < pv_AMT and toamt > pv_AMT;
       EXCEPTION
           WHEN OTHERS
           THEN l_delta := 0;
       END;
    End If;

    plog.debug (pkgctx, 'l_intrate:' || l_intrate);
    plog.debug (pkgctx, 'l_delta:' || l_delta);
    plog.debug (pkgctx, 'pv_RuleType:' || pv_RuleType);

    l_intrate := l_intrate + l_delta;


    plog.debug (pkgctx, '<<END OF pr_IRCalcCreditInterest');
    plog.setendsection (pkgctx, 'pr_IRCalcCreditInterest');

    RETURN l_intrate;


EXCEPTION
WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_IRCalcCreditInterest');
      RAISE errnums.E_SYSTEM_ERROR;
END pr_IRCalcCreditInterest;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_ciproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
