CREATE OR REPLACE PACKAGE cspks_mrproc
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

    FUNCTION fn_TriggerAccountLog(p_err_code in out varchar2)
    RETURN boolean;

  FUNCTION fn_ReleaseAdvanceLine(p_err_code in out varchar2)
  RETURN number;

  PROCEDURE placeOrderAuto (p_acctno in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2, p_tlid in varchar2);
  FUNCTION fn_getMrRate(p_afacctno in varchar2, p_codeid in varchar2)
  RETURN number;

  FUNCTION fn_getMrPrice(p_afacctno in varchar2, p_codeid in varchar2)
  RETURN number;
  PROCEDURE pr_force_sell_bo(pv_acctno VARCHAR2, p_err_code  OUT varchar2, p_err_message  OUT varchar2, p_tlid in varchar2);
  PROCEDURE pr_force_sell_fo(PV_ACCTNO VARCHAR2, p_err_code  OUT varchar2, p_err_message  OUT varchar2, p_tlid in varchar2);
END;
/
CREATE OR REPLACE PACKAGE BODY cspks_mrproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

---------------------------------pr_OpenLoanAccount------------------------------------------------
FUNCTION fn_TriggerAccountLog(p_err_code in out varchar2)
RETURN boolean
IS
l_currdate date;
BEGIN
    plog.setendsection(pkgctx, 'fn_TriggerAccountLog');
    l_currdate:= to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE'),'DD/MM/RRRR');

    update afmast
    set triggerdate = l_currdate
    where exists (select 1 from v_getsecmarginratio v where v.marginratio <= v.mrlratio and afmast.acctno = v.afacctno)
    and triggerdate is null;

    update afmast
    set triggerdate = null
    where exists (select 1 from v_getsecmarginratio v where v.marginratio > v.mrlratio and afmast.acctno = v.afacctno)
    and triggerdate is not null;

    plog.setendsection(pkgctx, 'fn_TriggerAccountLog');
    return true;
EXCEPTION
WHEN OTHERS
THEN
  plog.error (pkgctx, SQLERRM);
  plog.setendsection (pkgctx, 'fn_TriggerAccountLog');
  RAISE errnums.E_SYSTEM_ERROR;
  return false;
END fn_TriggerAccountLog;




--- Dat lenh ban xu ly tu dong
PROCEDURE placeOrderAuto (p_acctno in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2, p_tlid in varchar2)
IS
v_count NUMBER;
l_strCUSTID varchar2(30);
l_strAFACCTNO varchar2(30);
l_strEXECTYPE varchar2(30);
l_strNORK varchar2(30);
l_strMATCHTYPE varchar2(30);
l_strVIA varchar2(30);
l_rtnremainamt number;
l_strPRICETYPE varchar2(30);

l_strSYMBOL varchar2(30);
l_ORDERQTTY number;
l_ORDPRICE number;
l_strAFTYPE varchar2(30);
l_isFO      VARCHAR2(10);
l_FOMODE    VARCHAR2(10);

BEGIN
  plog.setbeginsection(pkgctx, 'placeOrderAuto');
  plog.debug (pkgctx, '<<BEGIN OF placeOrderAuto');

  -- GET ISFO for account
  BEGIN
    select af.isfo into l_isFO from afmast af where af.acctno = p_acctno;
  EXCEPTION WHEN OTHERS THEN
    l_isFO := 'N';
  END;
  -- End GET ISFO for account

  -- Get FOMODE
  BEGIN
    select sys.varvalue into l_FOMODE from SYSVAR sys where sys.varname = 'FOMODE';
  EXCEPTION WHEN OTHERS THEN
    l_FOMODE := 'OFF';
  END;

  IF l_FOMODE = 'ON' AND l_isFO = 'Y' THEN
    pr_force_sell_fo(p_acctno, p_err_code, p_err_message, p_tlid);
  ELSE
    pr_force_sell_bo(p_acctno, p_err_code, p_err_message, p_tlid);
  END IF;

  if p_err_code <> '0' then
     plog.setendsection (pkgctx, 'placeOrderAuto');
     RETURN;
  end if;

  p_err_code:=0;
  plog.setendsection(pkgctx, 'placeOrderAuto');

exception when others then
    rollback;
    p_err_code := errnums.C_SYSTEM_ERROR;
    p_err_message:= 'System error';
    plog.setendsection(pkgctx, 'placeOrderAuto');
RETURN;
END placeOrderAuto;






FUNCTION fn_ReleaseAdvanceLine(p_err_code in out varchar2)
RETURN number
IS
l_currdate date;
l_prevdate date;
l_release_advanceline number(20,4);
l_release_t0limitschd number(20,4);
l_txnum varchar2(10);
l_T0Limit number(20,4);
l_trft0amt number(20,0);
l_exec_trft0amt number(20,0);

BEGIN
    plog.setendsection(pkgctx, 'fn_ReleaseAdvanceLine');
    l_currdate:= to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE'),'DD/MM/RRRR');
    l_prevdate:= to_date(cspks_system.fn_get_sysvar('SYSTEM','PREVDATE'),'DD/MM/RRRR');

    for rec in
    (
        select af.acctno afacctno, af.advanceline, nvl(sts.trft0amt,0) trft0amt, nvl(oprin.oprinamount,0) oprinamount
        from afmast af,
            (select afacctno, sum(trft0amt) trft0amt
                from stschd
                where duetype = 'SM' and deltd <> 'Y' and trfbuydt >= l_currdate and status = 'C' and trfbuysts <> 'Y' and amt - trfexeamt > 0
                group by afacctno) sts,
            (select trfacctno, sum(oprinnml+oprinovd) oprinamount
                from lnmast
                where ftype = 'AF' and oprinnml+oprinovd > 0
                group by trfacctno) oprin
        where af.acctno = sts.afacctno(+)
            and af.acctno = oprin.trfacctno(+)
        order by af.acctno
    )
    loop
        -- Xac dinh so Bao Lanh Co the thu hoi.
        -- So Bao Lanh phai giu lai: So Tien Tra Cham. Luu trong bang STSCHD.
        -- So Bao Lanh khong duoc phep Release: Goc Bao lanh dang vay.
        select nvl(sum(acclimit),0) into l_T0Limit from useraflimit where acctno = rec.afacctno and typereceive = 'T0';
        l_release_advanceline:= greatest(l_T0Limit - rec.trft0amt - rec.oprinamount,0);

        if l_release_advanceline > 0 then

            --Lay TXNUM
            SELECT    '8000'
                      || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL,
                                 LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5,
                                 6
                                )
                 INTO l_txnum
                 FROM DUAL;

            -- Phan bo truoc cho T2 den han phai tra.
            for rec_trf in
            (
                select sts.txdate, least(max(af.advanceline) - sum(case when nvl(trfbuydt,l_prevdate) < l_prevdate then nvl(trft0amt,0) else 0 end),
                                sum(case when nvl(trfbuydt,l_currdate) = l_prevdate then nvl(trft0amt,0) else 0 end)) trft0amt
                from afmast af,
                    (select * from stschd sts where duetype = 'SM' and deltd <> 'Y' and trfbuyrate > 0 and trfbuyext > 0 and trfbuydt < l_currdate) sts
                where af.acctno = sts.afacctno
                and af.acctno = rec.afacctno
                group by sts.txdate
            )
            loop
                l_trft0amt:=greatest(least(rec_trf.trft0amt,l_release_advanceline),0);
                l_exec_trft0amt:=0;
                FOR REC_2 IN
                (
                    SELECT AUTOID, TLID, TYPEALLOCATE, ALLOCATEDLIMIT - RETRIEVEDLIMIT AMT
                    FROM (  select * from T0LIMITSCHD
                                union all
                            select * from T0LIMITSCHDHIST)
                    WHERE ACCTNO = rec.afacctno AND ALLOCATEDLIMIT - RETRIEVEDLIMIT > 0
                    and ALLOCATEDDATE = rec_trf.txdate
                    ORDER BY AUTOID
                )
                LOOP
                    IF l_trft0amt > 0 THEN
                        IF l_trft0amt > REC_2.AMT THEN
                           l_release_t0limitschd := REC_2.AMT;
                        ELSE
                           l_release_t0limitschd := l_trft0amt;
                        END IF;
                        l_trft0amt := l_trft0amt - l_release_t0limitschd;
                        l_exec_trft0amt:=l_exec_trft0amt + l_release_t0limitschd;
                        -- Cap nhat giam so luong da phan bo bao lanh
                        UPDATE T0LIMITSCHD SET RETRIEVEDLIMIT = RETRIEVEDLIMIT + l_release_t0limitschd WHERE AUTOID = REC_2.AUTOID;
                        UPDATE T0LIMITSCHDHIST SET RETRIEVEDLIMIT = RETRIEVEDLIMIT + l_release_t0limitschd WHERE AUTOID = REC_2.AUTOID;

                        UPDATE USERAFLIMIT SET ACCLIMIT = ACCLIMIT - l_release_t0limitschd
                        WHERE ACCTNO = rec.afacctno AND TLIDUSER = REC_2.TLID AND TYPERECEIVE = 'T0';

                        INSERT INTO USERAFLIMITLOG (TXNUM,TXDATE,ACCTNO,ACCLIMIT,TLIDUSER,TYPEALLOCATE,TYPERECEIVE)
                        VALUES (l_txnum, l_prevdate,rec.afacctno,-l_release_t0limitschd,REC_2.TLID,REC_2.TYPEALLOCATE,'T0');

                        INSERT INTO RETRIEVEDT0LOG(TXDATE, TXNUM, AUTOID, TLID, RETRIEVEDAMT)
                        VALUES(l_prevdate,l_txnum, REC_2.AUTOID, REC_2.TLID, l_release_t0limitschd);


                    END IF;
                END LOOP;
                l_release_advanceline:=l_release_advanceline- l_exec_trft0amt;

            end loop;


            FOR REC_2 IN
            (
                SELECT AUTOID, TLID, TYPEALLOCATE, ALLOCATEDLIMIT - RETRIEVEDLIMIT AMT
                FROM (  select * from T0LIMITSCHD
                            union all
                        select * from T0LIMITSCHDHIST)
                WHERE ACCTNO = rec.afacctno AND ALLOCATEDLIMIT - RETRIEVEDLIMIT > 0
                ORDER BY AUTOID DESC
            )
            LOOP
                IF l_release_advanceline > 0 THEN
                    IF l_release_advanceline > REC_2.AMT THEN
                       l_release_t0limitschd := REC_2.AMT;
                    ELSE
                       l_release_t0limitschd := l_release_advanceline;
                    END IF;
                    l_release_advanceline := l_release_advanceline - l_release_t0limitschd;
                    -- Cap nhat giam so luong da phan bo bao lanh
                    UPDATE T0LIMITSCHD SET RETRIEVEDLIMIT = RETRIEVEDLIMIT + l_release_t0limitschd WHERE AUTOID = REC_2.AUTOID;
                    UPDATE T0LIMITSCHDHIST SET RETRIEVEDLIMIT = RETRIEVEDLIMIT + l_release_t0limitschd WHERE AUTOID = REC_2.AUTOID;

                    UPDATE USERAFLIMIT SET ACCLIMIT = ACCLIMIT - l_release_t0limitschd
                    WHERE ACCTNO = rec.afacctno AND TLIDUSER = REC_2.TLID AND TYPERECEIVE = 'T0';

                    INSERT INTO USERAFLIMITLOG (TXNUM,TXDATE,ACCTNO,ACCLIMIT,TLIDUSER,TYPEALLOCATE,TYPERECEIVE)
                    VALUES (l_txnum, l_prevdate,rec.afacctno,-l_release_t0limitschd,REC_2.TLID,REC_2.TYPEALLOCATE,'T0');

                    INSERT INTO RETRIEVEDT0LOG(TXDATE, TXNUM, AUTOID, TLID, RETRIEVEDAMT)
                    VALUES(l_prevdate,l_txnum, REC_2.AUTOID, REC_2.TLID, l_release_t0limitschd);


                END IF;
            END LOOP;

            update afmast set t0amt = 0
            where acctno = rec.afacctno;
        end if;

        -- Thu hoi AFMAST.ADVANCELINE
        if greatest(rec.advanceline - rec.trft0amt,0) > 0 then
            INSERT INTO aftran (acctno, txnum,txdate, txcd, namt, camt, REF,deltd, autoid)
            VALUES (rec.afacctno, l_txnum,l_currdate, '0022', greatest(rec.advanceline - rec.trft0amt,0), '', '','N', seq_aftran.NEXTVAL);

            update afmast
            set advanceline = advanceline - greatest(rec.advanceline - rec.trft0amt,0)
            where acctno = rec.afacctno;
        end if;

    end loop;

    plog.setendsection(pkgctx, 'fn_ReleaseAdvanceLine');
    return systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
THEN
  plog.error (pkgctx, SQLERRM);
  plog.setendsection (pkgctx, 'fn_ReleaseAdvanceLine');
  RAISE errnums.E_SYSTEM_ERROR;
  return errnums.C_SYSTEM_ERROR;
END fn_ReleaseAdvanceLine;


FUNCTION fn_getMrRate(p_afacctno in varchar2, p_codeid in varchar2)
RETURN number
IS
l_result number;
BEGIN
    plog.setendsection(pkgctx, 'fn_getMrRate');
    select mrratioloan into l_result
    from afmast af, afserisk rsk
    where af.actype = rsk.actype and af.acctno = p_afacctno and rsk.codeid = p_codeid;
    plog.setendsection(pkgctx, 'fn_getMrRate');
    return l_result;
EXCEPTION
WHEN OTHERS
THEN
  plog.error (pkgctx, SQLERRM);
  plog.setendsection (pkgctx, 'fn_getMrRate');
  return 0;
END fn_getMrRate;

FUNCTION fn_getMrPrice(p_afacctno in varchar2, p_codeid in varchar2)
RETURN number
IS
l_result number;
BEGIN
    plog.setendsection(pkgctx, 'fn_getMrPrice');

    select greatest(least(se.marginprice, mrpriceloan),0) into l_result
    from afmast af, afserisk rsk, securities_info se
    where af.actype = rsk.actype and af.acctno = p_afacctno and rsk.codeid = p_codeid
    and rsk.codeid = se.codeid;

    plog.setendsection(pkgctx, 'fn_getMrPrice');
    return l_result;
EXCEPTION
WHEN OTHERS
THEN
  plog.error (pkgctx, SQLERRM);
  plog.setendsection (pkgctx, 'fn_getMrPrice');
  return 0;
END fn_getMrPrice;

PROCEDURE pr_force_sell_bo(pv_acctno VARCHAR2, p_err_code  OUT varchar2, p_err_message  OUT varchar2, p_tlid in varchar2)
IS
    v_count NUMBER;
    l_strCUSTID varchar2(30);
    l_strAFACCTNO varchar2(30);
    l_strEXECTYPE varchar2(30);
    l_strNORK varchar2(30);
    l_strMATCHTYPE varchar2(30);
    l_strVIA varchar2(30);
    l_rtnremainamt number;
    l_strPRICETYPE varchar2(30);
    p_acctno VARCHAR2(100);
    l_strSYMBOL varchar2(30);
    l_ORDERQTTY number;
    l_ORDPRICE number;
    l_strAFTYPE varchar2(30);
    l_isFO      VARCHAR2(10);
    l_FOMODE    VARCHAR2(10);
    v_tlid      VARCHAR2(100);
    v_advclearday NUMBER;
    v_advcleardaysys NUMBER;
BEGIN
  plog.setbeginsection(pkgctx, 'pr_force_sell_bo');
  p_acctno := pv_acctno;
  v_tlid := nvl(p_tlid,'');
  l_ORDERQTTY:=1;

  BEGIN
    select to_number(varvalue) INTO v_advcleardaysys from sysvar where varname = 'CLEARDAY' AND grname = 'OD';
    select (getduedate (getcurrdate,'B','000',v_advcleardaysys)-getcurrdate) INTO v_advclearday from dual;
  EXCEPTION WHEN OTHERS THEN
    v_advclearday := 2;
  END;

  while   l_ORDERQTTY >0
  loop
      BEGIN
      select count(*) into l_rtnremainamt from vw_mr0003 where acctno = pv_acctno and rtnremainamt5>0 ;

      if nvl(l_rtnremainamt,0) = 0 then
          plog.setendsection (pkgctx, 'placeOrderAuto');
          --p_err_code:=-900120;
          RETURN;
      end if;

      select  nvl(CUSTID,''), nvl(afacctno,''), nvl(EXECTYPE,''), nvl(SYMBOL,''), nvl(ORDERQTTY,0), nvl(QUOTEPRICE,0), nvl(PRICETYPE,''), nvl(VIA,'')
          INTO l_strCUSTID, l_strAFACCTNO, l_strEXECTYPE,l_strSYMBOL, l_ORDERQTTY, l_ORDPRICE,l_strPRICETYPE, l_strVIA
      from (

           SELECT  nvl(sbi.sellorder,999999) sellorder,sbi.codeid, se.afacctno,sb.symbol, sbi.floorprice/sbi.TRADEUNIT QUOTEPRICE,
         -- ORDERQTTY

          least ( floor((se.trade - nvl(v_se.secureamt,0))/sbi.tradelot) * sbi.tradelot,
                  ceil(GREATEST(
  --thay vrm.rtnamt2 thanh vrm.rtnamt3
                  (/*vmr.rtnamt2*/vmr.rtnamt5 -  vmr.realsellamt + vmr.SELLLOSTASSREF ) * ( decode(sys.ofs,'I',af.mrirate,af.mrmrate)/100 )
                  / ( decode(sys.ofs,'I',af.mrirate,af.mrmrate)/100 * sbi.floorprice * ( 1 - TO_NUMBER(fn_getodtypeinfor(se.afacctno,'NS','N','F','LO',SE.CODEID,3) )/100 - case when aft.vat='Y' then to_number(sy.varvalue) else 0 end/100 )
                  * (1 - adt.advrate*v_advclearday/360/100) - ( least( sbi.margincallprice, afs.mrpricerate) * afs.mrratiorate/100) )
                   ,
                   (vmr.novdamt - vmr.REALSELLAMT) / (sbi.floorprice * ( 1 - TO_NUMBER(fn_getodtypeinfor(se.afacctno,'NS','N','F','LO',SE.CODEID,3) )/100 -case when aft.vat='Y' then to_number(sy.varvalue) else 0 end/100 ) * (1 - adt.advrate *v_advclearday/360/100) )
                   )/sbi.tradelot ) * sbi.tradelot
               ) ORDERQTTY,  --, case when sb.tradeplace = '001' then 19990 else 999900 end

               CF.CUSTID,'T' VIA,'LO' PRICETYPE,'NS' EXECTYPE, SBI.TRADELOT

      FROM vw_mr0003 vmr, afmast af, cfmast cf, semast se, v_getsellorderinfo v_se, sbsecurities sb, securities_info sbi,
          aftype aft, adtype adt,sysvar sy,
      ( SELECT CODEID, ACTYPE, MRRATIORATE, MRRATIOLOAN, MRPRICERATE, MRPRICELOAN
          FROM AFSERISK
          WHERE ACTYPE IN (SELECT ACTYPE FROM AFMAST WHERE ACCTNO = p_acctno)
        UNION ALL
        SELECT CODEID,(SELECT ACTYPE FROM AFMAST WHERE ACCTNO = p_acctno)  ACTYPE, 0 MRRATIORATE,
            0 MRRATIOLOAN, 0 MRPRICERATE, 0 MRPRICELOAN
        FROM SECURITIES_INFO WHERE
        CODEID NOT IN (SELECT CODEID FROM AFSERISK WHERE ACTYPE IN (SELECT ACTYPE FROM AFMAST WHERE ACCTNO = p_acctno))
      )
          afs,
      (select varvalue ofs from sysvar where varname = 'OPTFORCESELL') sys
      where vmr.acctno = af.acctno and af.acctno = se.afacctno and af.custid = cf.custid
          and af.actype = aft.actype and aft.adtype = adt.actype
          and se.codeid = sb.codeid and sb.codeid=sbi.codeid
          and af.actype = afs.actype and sbi.codeid = afs.codeid
          and se.trade - nvl(v_se.secureamt,0) > 0
          and vmr.RTNREMAINAMT5 > 0
          and sy.varname = 'ADVSELLDUTY'
          and sbi.tradelot>0 and sb.sectype in ('001','008')
          and af.acctno = p_acctno
          and nvl(sb.halt,'N') = 'N'
          and se.acctno = v_se.seacctno (+)
          and fn_getodtypeinfor(se.afacctno,'NS','N','F','LO',SE.CODEID,3) is not null
      union all
      select 999999999 sellorder ,'999999999' codeid, '' afacctno, '' symbol ,0 QUOTEPRICE ,0 ORDERQTTY ,'' cusTID ,'' via,'' pricetype, '' exectype, 0 TRADELOT from dual
      order by sellorder
      )     a
      where rownum <=1 AND ORDERQTTY >= TRADELOT ;

      if nvl(l_ORDERQTTY,0) = 0 then
          plog.setEndSection(pkgctx, 'pr_force_sell_bo');
          EXIT;
      end if;

      plog.debug (pkgctx, '<<BEGIN OF fopks_api.pr_placeorder');
      fopks_api.pr_placeorder ('PLACEORDER',
                                l_strCUSTID ,
                                '' ,
                                l_strAFACCTNO,
                                l_strEXECTYPE,
                                l_strSYMBOL,
                                l_ORDERQTTY,
                                l_ORDPRICE ,
                                l_strPRICETYPE,
                                'T' ,
                                'A' ,
                                l_strVIA ,
                                '' ,
                                'Y' ,
                                '' ,
                                '' ,
                                v_tlid,0,0,
                                p_err_code,
                                p_err_message,
                                'Y'
                                );
        if p_err_code <> '0' then
           plog.setEndSection(pkgctx, 'pr_force_sell_bo');
           RETURN;
        end if;
      END;
   end loop;
EXCEPTION WHEN OTHERS THEN
    rollback;
    p_err_code := errnums.C_SYSTEM_ERROR;
    p_err_message:= 'System error';
    plog.setendsection(pkgctx, 'pr_force_sell_bo');
RETURN;
END;

PROCEDURE pr_force_sell_fo(PV_ACCTNO VARCHAR2, p_err_code  OUT varchar2, p_err_message  OUT varchar2, p_tlid in varchar2)
IS
  V_LOG_AUTOFS       VARCHAR2(100);
  v_CurrDate         DATE;
  v_RemainRTNAMT     NUMBER;
  v_AvlSellQtty      NUMBER;
  l_strCUSTID varchar2(30);
  l_strAFACCTNO varchar2(30);
  l_strEXECTYPE varchar2(30);
  l_strVIA varchar2(30);
  l_strPRICETYPE varchar2(30);
  l_strSYMBOL    VARCHAR2(100);
  v_Order_Autofs NUMBER;
  l_ORDPRICE     NUMBER;
  l_ORDERQTTY    NUMBER;
  v_ERR_CODE      varchar2(20);
  v_ERR_MESSAGE   varchar2(1000);
  v_SellAss       NUMBER;
  v_FeeRate       NUMBER;
  v_actype        varchar2(50);
  v_realsellamt   NUMBER;
  v_mrirate       NUMBER;
  v_avlse         NUMBER;
  v_sellamt       NUMBER;
  v_ADVSELLDUTY   NUMBER;
  v_tlid      VARCHAR2(100);
  v_advclearday   NUMBER;
  v_advcleardaysys NUMBER;

begin
  -- Test statements here
    plog.setbeginsection(pkgctx, 'pr_force_sell_fo');
    BEGIN
      select to_number(varvalue) INTO v_advcleardaysys from sysvar where varname = 'CLEARDAY' AND grname = 'OD';
      select (getduedate (getcurrdate,'B','000',v_advcleardaysys)-getcurrdate) INTO v_advclearday from dual;
    EXCEPTION WHEN OTHERS THEN
      v_advclearday := 2;
    END;

    v_tlid := nvl(p_tlid,'');
    BEGIN
       SELECT TO_NUMBER(SYS.Varvalue) INTO v_ADVSELLDUTY FROM SYSVAR SYS WHERE VARNAME = 'ADVSELLDUTY';
    EXCEPTION WHEN OTHERS THEN
      v_ADVSELLDUTY := 0;
    END;

    FOR rec IN
    (
        SELECT *
        FROM vw_mr0003
        WHERE acctno = PV_ACCTNO
            AND rtnremainamt5>0
    )
    LOOP
      BEGIN
      plog.error(pkgctx,'PV_ACCTNO:' || rec.acctno || '/' || rec.rtnremainamt5);
      SELECT seq_log_autofs.NEXTVAL INTO V_LOG_AUTOFS FROM DUAL;
      v_CurrDate := getcurrdate;

      BEGIN
          SELECT (decode(sys.varvalue,'I',AF.mrirate,AF.mrmrate)/100) INTO v_mrirate FROM AFMAST AF, SYSVAR SYS
          WHERE AF.ACCTNO = rec.acctno AND SYS.varname = 'OPTFORCESELL';
      EXCEPTION WHEN OTHERS THEN
         v_mrirate := 0;
      END;

      --dbms_output.put_line('rec.rtnremainamt5:' || rec.rtnremainamt5);
      -- Ghi log truoc khi bat dau xu ly
      INSERT INTO log_autofs (AUTOID,custodycd,actype,acctno,fullname,marginrate,rlsmarginrate,rtnremainamt,rtnremainamt5,
                             rtnamt,rtnamt2,rtnamtt2, t0ovdamount,ovdamount, cidepofeeacr, totalvnd, addvnd, realsellamt, asssellamt,
                             mrirate, mrmrate, mrlrate, calldate,calltime, phone1, email, mr0003type, rtnamountref, ovdamountref,
                             selllostassref, sellamountref, novdamt, trfbuyext, addvndt2, ofs, totalodamt, outstandingt2, mrcrlimitmax, setotalcallass,
                             semaxcallass,rtnamt3, rtnamt5, nyovdamt,mpovdamt,navaccount,secoutstanding, brid,fullnamere,mobilesms,
                             careby,txdate,logtime,process)
      VALUES(V_LOG_AUTOFS, rec.custodycd, rec.actype, rec.acctno, rec.fullname, rec.marginrate, rec.rlsmarginrate, rec.rtnremainamt, rec.rtnremainamt5,
             rec.rtnamt, rec.rtnamt2, rec.rtnamt2, rec.t0ovdamount, rec.ovdamount, rec.cidepofeeacr, rec.totalvnd, rec.addvnd, rec.realsellamt, rec.asssellamt,
             rec.mrirate, rec.mrmrate, rec.mrlrate, rec.calldate,rec.calltime, rec.phone1, rec.email, rec.mr0003type, rec.rtnamountref, rec.ovdamountref,
             rec.selllostassref, rec.sellamountref, rec.novdamt, rec.trfbuyext, rec.addvndt2, rec.ofs, rec.totalodamt, rec.outstandingt2, rec.mrcrlimitmax, rec.setotalcallass,
             rec.semaxcallass,rec.rtnamt3, rec.rtnamt5, rec.nyovdamt,rec.mpovdamt,rec.navaccount,rec.secoutstanding, rec.brid,rec.fullnamere,rec.mobilesms,
             rec.careby,v_CurrDate,SYSTIMESTAMP,'N');

      -- Xu ly chinh
      v_RemainRTNAMT  := rec.rtnremainamt5;
      plog.error(pkgctx,'v_RemainRTNAMT: ' || v_RemainRTNAMT);

      <<se_loop>>
        FOR rec_se IN(
            select * from
            (SELECT nvl(sbi.sellorder,999999) sellorder,sbi.codeid, se.afacctno,sb.symbol, sbi.floorprice/sbi.TRADEUNIT QUOTEPRICE,
                  least ( floor((se.trade - nvl(v_se.secureamt,0))/sbi.tradelot) * sbi.tradelot,
                  ceil(GREATEST((vmr.rtnamt5 -  vmr.realsellamt + vmr.SELLLOSTASSREF ) * ( decode(sys.ofs,'I',af.mrirate,af.mrmrate)/100 )
                    / ( decode(sys.ofs,'I',af.mrirate,af.mrmrate)/100 * sbi.floorprice * ( 1 - TO_NUMBER(fn_getodtypeinfor(se.afacctno,'NS','N','F','LO',SE.CODEID,3) )/100 - case when aft.vat='Y' then to_number(sy.varvalue) else 0 end/100 )
                    * (1 - adt.advrate*v_advclearday/360/100) - ( least( sbi.margincallprice, afs.mrpricerate) * afs.mrratiorate/100) )
                     ,
                     (vmr.novdamt - vmr.REALSELLAMT) / (sbi.floorprice * ( 1 - TO_NUMBER(fn_getodtypeinfor(se.afacctno,'NS','N','F','LO',SE.CODEID,3) )/100 -case when aft.vat='Y' then to_number(sy.varvalue) else 0 end/100 ) * (1 - adt.advrate *v_advclearday/360/100) )
                     )/sbi.tradelot ) * sbi.tradelot
                 ) ORDERQTTY,
                 CF.CUSTID,'T' VIA,'LO' PRICETYPE,'NS' EXECTYPE, SBI.TRADELOT,  nvl(adt.advrate,0) advrate, nvl(adt.advminfee,0) advminfee, aft.actype afactype, sb.sectype, sb.tradeplace, sbi.floorprice,  sbi.margincallprice,
                 afs.MRPRICERATE, afs.mrratiorate, se.trade trade, v_se.secureamt, vmr.rtnamt5, aft.vat, vmr.novdamt
          FROM vw_mr0003 vmr, afmast af, cfmast cf, semast se, v_getsellorderinfo v_se, sbsecurities sb, securities_info sbi,
            aftype aft, adtype adt,sysvar sy,
          ( SELECT CODEID, ACTYPE, MRRATIORATE, MRRATIOLOAN, MRPRICERATE, MRPRICELOAN
            FROM AFSERISK
            WHERE ACTYPE IN (SELECT ACTYPE FROM AFMAST WHERE ACCTNO = rec.acctno)
          UNION ALL
          SELECT CODEID,(SELECT ACTYPE FROM AFMAST WHERE ACCTNO = rec.acctno)  ACTYPE, 0 MRRATIORATE,
              0 MRRATIOLOAN, 0 MRPRICERATE, 0 MRPRICELOAN
          FROM SECURITIES_INFO WHERE
          CODEID NOT IN (SELECT CODEID FROM AFSERISK WHERE ACTYPE IN (SELECT ACTYPE FROM AFMAST WHERE ACCTNO = rec.acctno))
          ) afs, (select varvalue ofs from sysvar where varname = 'OPTFORCESELL') sys
          where vmr.acctno = af.acctno and af.acctno = se.afacctno and af.custid = cf.custid
            and af.actype = aft.actype and aft.adtype = adt.actype
            and se.codeid = sb.codeid and sb.codeid=sbi.codeid
            and af.actype = afs.actype and sbi.codeid = afs.codeid
            and se.trade - nvl(v_se.secureamt,0) > 0
            and vmr.RTNREMAINAMT5 > 0
            and sy.varname = 'ADVSELLDUTY'
            and sbi.tradelot > 0 and sb.sectype in ('001','008')
            and af.acctno = rec.acctno
            and se.acctno = v_se.seacctno (+)
            and nvl(sb.halt,'N') = 'N'
            and fn_getodtypeinfor(se.afacctno,'NS','N','F','LO',SE.CODEID,3) is not null
            order by sellorder) where ORDERQTTY >= TRADELOT )
        LOOP
            plog.error(pkgctx,'SYMBOL:' || rec_se.symbol || '/' || rec_se.sellorder);
            SELECT seq_Order_Autofs.Nextval INTO v_Order_Autofs FROM dual ;

            INSERT INTO ORDER_AUTOFS(AUTOID,SELLORDER,Codeid,AFACCTNO,SYMBOL,Quoteprice,ORDERQTTY,Custid,
                   VIA, Pricetype,EXECTYPE,Tradelot,PROCESS,Logtime)
            VALUES(v_Order_Autofs,rec_se.sellorder,rec_se.codeid,rec_se.afacctno, rec_se.symbol, rec_se.quoteprice * 1000, rec_se.ORDERQTTY, rec_se.custid,
                   rec_se.via, rec_se.pricetype,rec_se.EXECTYPE, rec_se.tradelot, 'N', SYSTIMESTAMP);

            v_AvlSellQtty := rec_se.ORDERQTTY;
            plog.error(pkgctx,'v_AvlSellQtty:' || v_AvlSellQtty);

            -- Tinh so tien co the ung truoc toi da tu nhung lenh ban xu ly da dat
            select round(sum(od.remainqtty*od.quoteprice*1000*(1-odt.deffeerate/100-to_number(sy.varvalue)/100)*(1-nvl(rsk.advrate,ADVFEE.advrate)*v_advclearday/360)),0) realsellamt,
                   round(greatest(sum(od.remainqtty*least(nvl(rsk.mrpricerate,0),margincallprice)*nvl(rsk.mrratiorate,0)/(case when decode(sys1.ofs,'I',nvl(rsk.mrirate,100),nvl(rsk.mrmrate,100)) = 0 then 100 else decode(sys1.ofs,'I',nvl(rsk.mrirate,100),nvl(rsk.mrmrate,100)) end) ),0)) lostass
            INTO v_realsellamt, v_SellAss
            from (select fs.txdate, fs.codeid, fs.afacctno, fs.quoteqtty remainqtty, fs.quoteprice, 'NS' exectype, 'Y' isdisposal, odtype actype from  FSORDER fs WHERE STATUS = 'C') od,
              odtype odt,
              (select af.acctno, af.mrirate, af.mrmrate, nvl(adt.advrate,0)/100 advrate,nvl(adt.advminfee,0) advminfee, rsk.*
                  from afmast af, afserisk rsk, aftype aft, adtype adt
                  where af.actype = rsk.actype(+)
                  and af.actype = aft.actype and aft.adtype = adt.actype
                  ) rsk,
               (select af.acctno, af.mrirate, af.mrmrate, nvl(adt.advrate,0)/100 advrate,nvl(adt.advminfee,0) advminfee
               from afmast af,   aftype aft, adtype adt
               where
               af.actype = aft.actype and aft.adtype = adt.actype
                    --AND AF.ACTYPE ='0003' --AND RSK.CODEID  IS NULL
                ) ADVFEE,
              securities_info sec,
              sysvar sy,
              (select varvalue ofs from sysvar where varname = 'OPTFORCESELL') sys1
            where od.exectype in ('NS','MS') and isdisposal = 'Y'
              and od.afacctno = rsk.acctno(+) and od.codeid = rsk.codeid(+)
              AND OD.AFACCTNO =ADVFEE.ACCTNO
              and od.codeid = sec.codeid
              and od.actype = odt.actype
              and sy.varname = 'ADVSELLDUTY'
              and od.txdate = v_CurrDate
              --and od.remainqtty > 0
              AND od.afacctno = rec.acctno;
            -- End Tinh so tien co the ung truoc toi da tu nhung lenh ban xu ly da dat


            v_realsellamt := nvl(v_realsellamt,0);
            v_SellAss := nvl(v_SellAss,0);

            IF (rec_se.rtnamt5 - v_realsellamt + v_SellAss - rec.realsellamt + rec.Selllostassref) <= 0 AND (rec_se.novdamt - v_realsellamt - rec.realsellamt) <= 0 THEN
               EXIT;
            END IF;

            -- Tinh so luong thuc te can ban
            v_sellamt := ceil(GREATEST((rec_se.rtnamt5 -  v_realsellamt + v_SellAss - rec.realsellamt + rec.Selllostassref) * v_mrirate
                          / (v_mrirate * rec_se.floorprice * ( 1 - TO_NUMBER(fn_getodtypeinfor(rec_se.afacctno,'NS','N','F','LO',rec_se.CODEID,3) )/100 - case when rec_se.vat='Y' then v_ADVSELLDUTY else 0 end/100 )
                          * (1 - rec_se.advrate*v_advclearday/360/100) - ( least( rec_se.margincallprice, rec_se.mrpricerate) * rec_se.mrratiorate/100) )
                           ,
                           (rec_se.novdamt - v_realsellamt - rec.realsellamt) / (rec_se.floorprice * ( 1 - TO_NUMBER(fn_getodtypeinfor(rec_se.afacctno,'NS','N','F','LO',rec_se.CODEID,3) )/100 -case when rec_se.vat='Y' then v_ADVSELLDUTY else 0 end/100 ) * (1 - rec_se.advrate *v_advclearday/360/100) )
                           )/rec_se.tradelot ) * rec_se.tradelot;
            -- End tinh so luong thuc te can ban

            l_ORDERQTTY := least(v_AvlSellQtty,v_sellamt);

            if nvl(l_ORDERQTTY,0) = 0 then
                EXIT;
            end if;

            BEGIN
                SELECT deffeerate, actype
                INTO v_FeeRate, v_actype
                FROM (SELECT a.actype, a.clearday, a.bratio, a.minfeeamt, a.deffeerate, b.ODRNUM
                        FROM odtype a, afidtype b
                        WHERE     a.status = 'Y'
                            AND (a.via = 'F' OR a.via = 'A') --VIA
                            AND a.clearcd = 'B'       --CLEARCD
                            AND (a.exectype = 'NS'           --l_build_msg.fld22
                                OR a.exectype = 'AA')                    --EXECTYPE
                            AND (a.timetype = 'T'
                                OR a.timetype = 'A')                     --TIMETYPE
                            AND (a.pricetype = 'LO'
                                OR a.pricetype = 'AA')                  --PRICETYPE
                            AND (a.matchtype = 'N'
                                OR a.matchtype = 'A')                   --MATCHTYPE
                            AND (a.tradeplace = rec_se.tradeplace
                                OR a.tradeplace = '000')
                            AND (instr(case when rec_se.sectype in ('001','002','011') then rec_se.sectype || ',' || '111,333'
                                            when rec_se.sectype in ('003','006') then rec_se.sectype || ',' || '222,333,444'
                                            when rec_se.sectype in ('008') then rec_se.sectype || ',' || '111,444'
                                            else rec_se.sectype end, a.sectype)>0 OR a.sectype = '000')
                            AND (a.nork = 'A' OR a.nork = 'A') --NORK
                            AND (CASE WHEN A.CODEID IS NULL THEN rec_se.codeid ELSE A.CODEID END)=rec_se.codeid
                            AND a.actype = b.actype and b.aftype=rec_se.afactype and b.objname='OD.ODTYPE'
                            ORDER BY CASE WHEN (SELECT VARVALUE FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'ORDER_ORD') = 'ODRNUM' THEN ODRNUM ELSE DEFFEERATE END ASC
                        ) where rownum<=1;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                RAISE errnums.e_od_odtype_notfound;
            END;

            pck_syn2fo.prc_placeorders(pv_accountno => rec_se.afacctno,
               pv_exectype => rec_se.EXECTYPE,
               pv_symbol => rec_se.symbol,
               pv_pricetype => rec_se.pricetype,
               pv_price => rec_se.quoteprice * 1000,
               pv_quantity => l_ORDERQTTY,
               pv_userid => v_tlid,
               pv_via => rec_se.via,
               pv_isdisposal => 'Y',
               pv_timetype => 'T',
               pv_errorcode => v_err_code,
               pv_returnvalue => v_err_message);

            IF trim(v_ERR_CODE) <> '0' THEN
               UPDATE order_autoFS SET PROCESS ='E', ERRCODE  = v_ERR_CODE WHERE autoid =v_Order_Autofs;
               plog.error(pkgctx,'Error occurred while trying force sell automatically for account: ' || rec.acctno || ', symbol: ' || rec_se.symbol||'v_ERR_CODE'||v_ERR_CODE);
            ELSE
              insert into FSORDER (AFACCTNO, odtype, TXDATE, CODEID, QUOTEQTTY, QUOTEPRICE, SYMBOL, STATUS)
              values (rec.acctno, v_actype,  getcurrdate, rec_se.codeid, l_ORDERQTTY, rec_se.QUOTEPRICE, rec_se.symbol, 'C');

              UPDATE order_autoFS SET PROCESS ='C' WHERE autoid =v_Order_Autofs;
            END IF;
      --END LOOP;
      END LOOP se_loop;
      --Update FSORDER SET STATUS = 'F' WHERE AFACCTNO = PV_ACCTNO;
      UPDATE log_autofs SET PROCESS ='C' WHERE AUTOID =V_LOG_AUTOFS AND process='N';
      plog.setbeginsection(pkgctx, 'pr_force_sell_fo');
      EXCEPTION WHEN OTHERS THEN
        plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
        plog.error (pkgctx, 'pr_force_sell_fo: Loi xu ly tren tieu khoan');
        UPDATE log_autofs SET PROCESS ='E' WHERE AUTOID =V_LOG_AUTOFS;
        plog.setbeginsection(pkgctx, 'pr_force_sell_fo');
      END;
    END LOOP;

EXCEPTION WHEN OTHERS THEN
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      p_err_code :='-1';
      plog.setbeginsection(pkgctx, 'pr_force_sell_fo');
      RAISE errnums.E_SYSTEM_ERROR;
end pr_force_sell_fo;



-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_mrproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
