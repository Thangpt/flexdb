-- Start of DDL Script for Package Body HOSTMSTRADE.CSPKS_ODPROC
-- Generated 12-Feb-2019 10:10:53 from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
PACKAGE cspks_odproc
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

    FUNCTION fn_checkTradingAllow(p_afacctno varchar2, p_codeid varchar2, p_bors varchar2, p_err_code in out varchar2)
    RETURN boolean;
    Procedure pr_MortgageSellAllocate(p_Orderid varchar2,p_afacctno varchar2, p_codeid varchar2, p_dfacctno varchar2, p_orderqtty number);
    Procedure pr_MortgageSellRelease(p_Orderid varchar2,p_afacctno varchar2, p_codeid varchar2, p_dfacctno varchar2, p_orderqtty number,p_qtty number);
    Procedure pr_MortgageSellMatch(p_Orderid varchar2,p_qtty number, p_amount number, p_afacctno varchar2, p_CodeID varchar2);
    Procedure pr_CancelGroupOrder(p_Orderid varchar2);
    Procedure pr_RM_UnholdCancelOD( pv_strORDERID varchar2,pv_dblCancelQtty number,pv_strErrorCode in out varchar2);
    Procedure pr_SEMarginInfoUpdate(p_Afacctno varchar2, p_Codeid varchar2, p_Qtty number);
    FUNCTION fn_OD_ClearOrder(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
    RETURN NUMBER;
        PROCEDURE pr_ConfirmOrder(p_Orderid varchar2,p_userId VARCHAR2,p_custid VARCHAR2,p_Ipadrress VARCHAR2,pv_strErrorCode in out varchar2,p_via varchar2 default 'O');
    FUNCTION fn_OD_GetRootOrderID
    (p_OrderID       IN  VARCHAR2
    ) RETURN VARCHAR2; -- HAM THUC HIEN LAY SO HIEU LENH GOC CUA LENH
    PROCEDURE pr_CancelOrderAfterDay( pv_tradeplace VARCHAR2, pv_pricetype VARCHAR2, pv_exectype VARCHAR2, pv_afacctno VARCHAR2,pv_custodycd VARCHAR2, p_err_code IN OUT VARCHAR2);
    PROCEDURE pr_update_secinfo
   ( pv_Symbol  VARCHAR2, pv_ceilingprice  VARCHAR2,pv_floorprice  varchar2 ,pv_basicprice  VARCHAR2, pv_tradeplace  varchar2,p_security_type IN VARCHAR2, p_err_code in out varchar2);


END;
/


CREATE OR REPLACE 
PACKAGE BODY cspks_odproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

---------------------------------pr_OpenLoanAccount------------------------------------------------
  FUNCTION fn_checkTradingAllow(p_afacctno varchar2, p_codeid varchar2, p_bors varchar2, p_err_code in out varchar2)
  RETURN boolean
  IS
  l_cfmarginallow varchar2(1);
  l_chksysctrl varchar2(1);
  l_policycd varchar2(1);
  l_actype varchar2(4);
  l_foa varchar2(20);
  l_bors varchar2(20);
  l_count number(10);
  l_isMarginAccount varchar2(1);
  l_busdate date;
  v_ALLOWSESSION varchar2(20);
  v_tradeplace varchar2(20);
  v_CONTROLCODE varchar2(20);
  l_advanceline NUMBER;
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_checkTradingAllow');
    --Kiem tra xem chung khoan co bi chan boi phien giao dich hay khong
    begin
        select nvl(ALLOWSESSION,'AL'), tradeplace into v_ALLOWSESSION,v_tradeplace from sbsecurities where codeid =p_codeid;
        if v_tradeplace = '001' and v_ALLOWSESSION <> 'AL' then
            select sysvalue into v_CONTROLCODE from ordersys where sysname ='CONTROLCODE';
            if v_ALLOWSESSION ='OP' and v_CONTROLCODE<>'P' then --Chung khoan chi duoc dat lenh phien mo cua
                p_err_code:= '-700071';
                plog.setendsection(pkgctx, 'fn_checkTradingAllow');
                return false;
            end if;
            if v_ALLOWSESSION ='CO' and v_CONTROLCODE<>'O' then --Chung khoan chi duoc dat lenh phien lien tuc
                p_err_code:= '-700072';
                plog.setendsection(pkgctx, 'fn_checkTradingAllow');
                return false;
            end if;
            if v_ALLOWSESSION ='CL' and v_CONTROLCODE<>'A' then --Chung khoan chi duoc dat lenh phien dong cua
                p_err_code:= '-700073';
                plog.setendsection(pkgctx, 'fn_checkTradingAllow');
                return false;
            end if;
        end if;
    exception when others then
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    end;
    select to_date(varvalue,'DD/MM/RRRR') into l_busdate from sysvar where varname = 'CURRDATE';
    -- Day co phai tieu khoan margin hay khong?
    select cf.marginallow, aft.policycd, aft.actype, nvl(lnt.chksysctrl,'N')
        into l_cfmarginallow, l_policycd, l_actype, l_chksysctrl
    from cfmast cf, afmast af, aftype aft, lntype lnt
    where cf.custid = af.custid and af.actype = aft.actype and aft.lntype = lnt.actype(+)
    and af.acctno = p_afacctno;

    select count(1) into l_count from afmast af where af.acctno = p_afacctno
    and (exists (select 1 from aftype aft1, lntype lnt1 where aft1.lntype = lnt1.actype and lnt1.chksysctrl = 'Y' and to_char(aft1.actype) = af.actype)
        or
        exists (select 1 from afidtype afi, lntype lnt2 where afi.objname = 'LN.LNTYPE' and afi.aftype = af.actype and afi.actype = lnt2.actype and lnt2.chksysctrl = 'Y')
        );
    if l_count > 0 then
        l_isMarginAccount:= 'Y';
    else
        l_isMarginAccount:= 'N';
    end if;

    -- He thong co chan khong.
    if cspks_system.fn_get_sysvar('MARGIN', 'MARGINALLOW') = 'N' AND l_isMarginAccount = 'Y'  then
        p_err_code:= '-700062';
        plog.setendsection(pkgctx, 'fn_checkTradingAllow');
        return false;
    end if;

    if l_isMarginAccount = 'Y' and trim(l_cfmarginallow) = 'N' and l_chksysctrl = 'Y' then
        p_err_code:= '-700063';
        plog.setendsection(pkgctx, 'fn_checkTradingAllow');
        return false;
    end if;

    -- Kiem tra tren tang loai hinh. Khai bao chan giao dich.
    if l_policycd = 'L' then
        --Tuan theo AFSERULE. Neu cho phep moi thuc hien. Ko thi thoi.
        select count(1) into l_count
        from afserule
        where ((typormst = 'M' and refid = p_afacctno) or (typormst = 'T' and refid = l_actype)) and codeid = p_codeid
        and l_busdate between effdate and expdate
        and (bors = p_bors or bors = 'A') AND status = 'A' AND afseruletype = 'N';

        if not l_count > 0 then
            p_err_code:= '-700069';
            plog.setendsection(pkgctx, 'fn_checkTradingAllow');
            return false;
        end if;
    elsif l_policycd = 'E' then
        --Neu ko nam trong AFSERULE--> Binh thuong. Nguoc lai--> theo AFSERULE.
        select count(1) into l_count
        from afserule where ((typormst = 'M' and refid = p_afacctno) or (typormst = 'T' and refid = l_actype)) and codeid = p_codeid
        and l_busdate between effdate and expdate
        and (bors = p_bors or bors = 'A') AND status = 'A' AND afseruletype  = 'N';

        if l_count > 0 then
            p_err_code:= '-700069';
            plog.setendsection(pkgctx, 'fn_checkTradingAllow');
            return false;
        end if;
    end if;

    --check CK dc phep mua cho loai hinh BL
    SELECT advanceline INTO l_advanceline FROM afmast WHERE acctno = p_afacctno;
    select count(1) into l_count
    from afserule where (typormst = 'M' and refid = p_afacctno) AND afseruletype  = 'BL' AND status = 'A';
    IF l_count > 0 AND l_advanceline > 0 THEN
        IF p_bors = 'B' THEN
            select count(1) into l_count
            from afserule where (typormst = 'M' and refid = p_afacctno) and codeid = p_codeid
            and l_busdate between effdate and expdate
            AND status = 'A' AND afseruletype  = 'BL';

            if l_count = 0 then
                p_err_code:= '-700069';
                plog.setendsection(pkgctx, 'fn_checkTradingAllow');
                return false;
            end if;
        END IF;
    END IF;
    --end check CK dc phep mua cho loai hinh BL

    plog.setendsection(pkgctx, 'fn_checkTradingAllow');
    return true;
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_checkTradingAllow');
      RAISE errnums.E_SYSTEM_ERROR;
      return false;
  END fn_checkTradingAllow;

Procedure pr_MortgageSellAllocate(p_Orderid varchar2,p_afacctno varchar2, p_codeid varchar2, p_dfacctno varchar2, p_orderqtty number)
  IS
    l_alqtty number;
    l_i number;
    l_dealwaningovd number;
    v_isvsd varchar2(1);
  BEGIN
    plog.setendsection(pkgctx, 'pr_MortgageSellAllocate');
    plog.info(pkgctx, 'p_dfacctno' || p_dfacctno);
    plog.info(pkgctx, 'p_Orderid' || p_Orderid);
    plog.info(pkgctx, 'p_afacctno + p_codeid' || p_afacctno || p_codeid);
    plog.info(pkgctx, 'p_orderqtty' || p_orderqtty);
    l_dealwaningovd:=10;
    begin
    l_dealwaningovd:=to_number(cspks_system.fn_get_sysvar('SYSTEM','DEALWARNINGOVD'));
    exception when others then
        l_dealwaningovd:=10;
    end;
    if p_dfacctno is null or length(nvl(p_dfacctno,'X'))<=1 then
         --Lenh cam co tong
         l_alqtty:=p_orderqtty;
         l_i:=1;
         for rec in
         (
             select ACCTNO,DFTRADING,nvl(dfg.rtt,1000) rtt,nvl(dfg.overduedate,to_date('01/01/3000','DD/MM/YYYY')) overduedate, ISVSD
                 from (
                        select DFT.ISVSD,df.afacctno, df.codeid,df.groupid,acctno,dfqtty + DF.dfstanding - nvl(v.secureamt,0) dftrading
                                from DFTYPE DFT,dfmast df,
                                (
                                    SELECT dfacctno,SUM(SECUREAMT) SECUREAMT
                                 FROM (SELECT map.refid dfacctno,
                                           to_number(nvl(sy.varvalue,0)) * map.qtty  SECUREAMT,
                                           map.execqtty SECUREMAT
                                        FROM ODMAPEXT MAP, SYSVAR SY
                                       WHERE MAP.deltd <> 'Y' and map.TYPE='D'
                                           and sy.grname='SYSTEM' and sy.varname='HOSTATUS'

                                           ) GROUP BY dfacctno
                                ) v
                            where DFT.ACTYPE = DF.ACTYPE AND df.acctno = v.dfacctno (+)
                      ) df,
                    sysvar sys,
                     (SELECT DFG.GROUPID,DFG.IRATE, DFG.MRATE, DFG.LRATE,
                          dff.tadf/(ln.PRINNML + ln.PRINOVD + round(ln.INTNMLACR,0) + round(ln.INTOVDACR,0) +round(ln.INTNMLOVD,0)+round(ln.INTDUE,0)+
                            ln.OPRINNML+ln.OPRINOVD+round(ln.OINTNMLACR,0)+round(ln.OINTOVDACR,0)+round(ln.OINTNMLOVD,0)+
                            round(ln.OINTDUE,0)+round(ln.FEE,0)+round(ln.FEEDUE,0)+round(ln.FEEOVD,0)
                            +  round(ln.FEEINTNMLACR,0) + round(ln.FEEINTOVDACR,0) +round(ln.FEEINTNMLOVD,0)+round(ln.FEEINTDUE,0)) * 100
                            RTT,
                          ln.prinovd+ln.intnmlovd+ln.feeintnmlovd OVDAMT,
                          nvl(chd.overduedate,to_date('01/01/3000','DD/MM/YYYY')) overduedate
                     FROM DFGROUP DFG, LNMAST LN,
                          (select groupid,sum((dfqtty+bqtty+ carcvqtty+ rcvqtty) * inf.dfrefprice + cacashqtty) tadf
                                from dfmast df, securities_info inf
                                where df.codeid = inf.codeid
                                group by df.groupid
                          ) dff,
                          (select acctno, max(overduedate) overduedate from lnschd where reftype ='P' group by acctno) chd,
                          (SELECT LNACCTNO,SUM(DFRATE* (DFQTTY+BLOCKQTTY+CARCVQTTY)* SB.BASICPRICE/100) COLAMT
                             FROM DFMAST DF,SECURITIES_INFO SB
                             WHERE DF.CODEID=SB.CODEID GROUP BY LNACCTNO
                          ) DF
                     WHERE DFG.LNACCTNO=LN.ACCTNO AND DF.LNACCTNO=LN.ACCTNO and dfg.groupid= dff.groupid and ln.acctno = chd.acctno(+)
                            and ln.PRINNML + ln.PRINOVD + round(ln.INTNMLACR,0) + round(ln.INTOVDACR,0) +round(ln.INTNMLOVD,0)+round(ln.INTDUE,0)+
                              ln.OPRINNML+ln.OPRINOVD+round(ln.OINTNMLACR,0)+round(ln.OINTOVDACR,0)+round(ln.OINTNMLOVD,0)+
                              round(ln.OINTDUE,0)+round(ln.FEE,0)+round(ln.FEEDUE,0)+round(ln.FEEOVD,0)
                              +  round(ln.FEEINTNMLACR,0) + round(ln.FEEINTOVDACR,0) +round(ln.FEEINTNMLOVD,0)+round(ln.FEEINTDUE,0) >0) dfg
                 where df.DFTRADING>0  and df.afacctno = p_AFACCTNO and df.codeid =p_CODEID
                 and df.groupid= dfg.groupid (+)
                 and sys.grname ='SYSTEM' and sys.varname='CURRDATE'
                 order by (case when nvl(dfg.rtt,1000)<DFG.LRATE then nvl(dfg.rtt,1000) else 10000000000 end), --Order by theo cac deal vi pham ty le xu ly, Rtt nho truoc
                          (case when nvl(dfg.overduedate,to_date('01/01/3000','DD/MM/YYYY')) <=to_date(sys.varvalue,'DD/MM/RRRR') then nvl(dfg.overduedate,to_date('01/01/3000','DD/MM/YYYY')) else to_date(sys.varvalue,'DD/MM/RRRR') end), --Cac deal bi qua han
                          (case when nvl(dfg.rtt,1000)<=DFG.MRATE then nvl(dfg.rtt,1000) else 10000000000 end), --Order by theo cac bi call
                          (case when nvl(dfg.overduedate,to_date('01/01/3000','DD/MM/YYYY')) < to_date(sys.varvalue,'DD/MM/RRRR') + l_dealwaningovd then nvl(dfg.overduedate,to_date('01/01/3000','DD/MM/YYYY')) else to_date(sys.varvalue,'DD/MM/RRRR') + l_dealwaningovd end),
                          nvl(dfg.rtt,1000)
         )
         loop
             plog.info(pkgctx, 'Lenh ban cam co tong' || p_orderqtty);

             if l_alqtty>rec.DFTRADING then
                 INSERT INTO ODMAPEXT (ORDERID,REFID,QTTY,ORDERNUM,TYPE,ISVSD)
                 VALUES (p_Orderid,rec.ACCTNO,rec.DFTRADING,l_i,'D',rec.ISVSD);
                 l_alqtty:=l_alqtty-rec.DFTRADING;
                 plog.info(pkgctx, 'dfactno+qtty:' || rec.ACCTNO || '+' || rec.DFTRADING);
             else
                 INSERT INTO ODMAPEXT (ORDERID,REFID,QTTY,ORDERNUM,TYPE,ISVSD)
                 VALUES (p_Orderid,rec.ACCTNO,l_alqtty,l_i,'D',rec.ISVSD);
                 l_alqtty:=0;
                 plog.info(pkgctx, 'dfactno+qtty:' || rec.ACCTNO || '+' || l_alqtty);
             end if;
             l_i:=l_i+1;
             exit when l_alqtty<=0;
         end loop;

     else
        -- HaiLT them de phan biet phan bo lenh cam co VSD hay thuong
        select isvsd into v_isvsd from dfmast df, dftype dft where df.actype = dft.actype and df.acctno = p_dfacctno;
         --Lenh cam co theo deal chi ro
         INSERT INTO ODMAPEXT (ORDERID,REFID,QTTY,ORDERNUM,TYPE,ISVSD)
         VALUES (p_Orderid,p_dfacctno,p_orderqtty,1,'D',nvl(v_isvsd,'N'));
     end if;
    plog.setendsection(pkgctx, 'pr_MortgageSellAllocate');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_MortgageSellAllocate');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_MortgageSellAllocate;


Procedure pr_MortgageSellRelease(p_Orderid varchar2,p_afacctno varchar2, p_codeid varchar2, p_dfacctno varchar2, p_orderqtty number,p_qtty number)
  IS
  l_allqtty number;
  BEGIN
    plog.setendsection(pkgctx, 'pr_MortgageSellRelease');
    if p_qtty>0 then
        l_allqtty:=p_qtty;
        for rec in (select * from odmapext where orderid = p_Orderid and deltd <> 'Y' and qtty-execqtty>0 order by ORDERNUM desc)
        loop
            if rec.qtty-rec.execqtty>l_allqtty THEN
                update odmapext set qtty= qtty - l_allqtty where orderid = rec.orderid and refid = rec.refid and deltd <> 'Y';
                l_allqtty:=0;
            else
                update odmapext set qtty=execqtty where orderid = rec.orderid and refid = rec.refid and deltd <> 'Y';
                l_allqtty:=l_allqtty-(rec.qtty-rec.execqtty);
                if rec.execqtty=0 then
                    --Neu trong odmapext qtty=execqtty= 0 thi remove
                    delete from odmapext where orderid = rec.orderid and refid = rec.refid;
                end if;
            end if;
            exit when l_allqtty<=0;
        end loop;
    else
        delete from odmapext where orderid =p_Orderid;
        cspks_odproc.pr_MortgageSellAllocate(p_Orderid,p_afacctno,p_codeid,p_dfacctno,p_orderqtty);
    end if;
    plog.setendsection(pkgctx, 'pr_MortgageSellRelease');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_MortgageSellRelease');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_MortgageSellRelease;

  Procedure pr_CancelGroupOrder(p_Orderid varchar2)
  IS
  BEGIN
    plog.setendsection(pkgctx, 'pr_CancelGroupOrder');
    for rec in (SELECT * FROM ODMAPEXT WHERE ORDERID=p_orderid AND DELTD<>'Y')
    LOOP
        if rec.type='S'  then
            UPDATE SEMAST SET TRADE=TRADE+rec.QTTY, GRPORDAMT=GRPORDAMT-rec.qtty where  acctno= rec.refid;
        END IF;
        if rec.type='D' THEN
            UPDATE DFMAST SET DFQTTY=DFQTTY+rec.QTTY, GRPORDAMT=GRPORDAMT-rec.qtty where  acctno= rec.refid;
            UPDATE SEMAST SET MORTAGE = MORTAGE + rec.QTTY WHERE ACCTNO IN (SELECT AFACCTNO||CODEID FROM DFMAST WHERE ACCTNO=rec.refid);
        end if;

        UPDATE ODMAPEXT SET DELTD='Y' WHERE ORDERID=p_orderid AND ORDERNUM=rec.ordernum;

    END LOOP;
    plog.setendsection(pkgctx, 'pr_CancelGroupOrder');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_CancelGroupOrder');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_CancelGroupOrder;

  Procedure pr_MortgageSellMatch(p_Orderid varchar2, p_qtty number, p_amount number, p_afacctno varchar2, p_CodeID varchar2)
  IS
  p_ALLqtty number;
  l_rlsamt number;
  l_actype varchar2(20);
  l_BrID varchar2(20);
  l_totalrlsamt number;
  BEGIN
    plog.setendsection(pkgctx, 'pr_MortgageSellMatch');
    l_totalrlsamt:=0;
    if p_qtty>0 then
        p_ALLqtty:=p_qtty;
        for rec in (select * from odmapext where orderid = p_Orderid and deltd <> 'Y' and qtty-execqtty>0 order by ORDERNUM)
        loop
            if rec.qtty-rec.execqtty>p_ALLqtty THEN
                update odmapext set execqtty= execqtty + p_ALLqtty where orderid = rec.orderid and refid = rec.refid and deltd <> 'Y';

                -- << Update Room
                update securities_info
                set syroomused = nvl(syroomused,0) - p_ALLqtty
                where codeid = p_CodeID;
                -- >> Update Room
                -- << Update Pool
                /*select p_ALLqtty*dfprice into l_rlsamt from dfmast where acctno = rec.refid;*/
                begin
                    select greatest(round(((p_ALLqtty*sec.dfrlsprice*df.dfrate/100)/ dfg.dfamt) * dfg.lnamt,0),nvl(lnovdamt,0))
                        into l_rlsamt
                    from dfmast df,
                    (select df.groupid, sum((df.dfqtty+df.blockqtty+df.rcvqtty+df.carcvqtty)*se.dfrlsprice*df.dfrate/100) dfamt,
                    max(ln.prinnml+prinovd) lnamt, max(ln.prinovd+nvl(ls.nml,0)) lnovdamt
                    from dfmast df, securities_info se, lnmast ln,
                    (select ls.acctno, sum(nml) nml
                        from lnschd ls
                        where ls.reftype = 'P' and ls.overduedate = (select to_date(varvalue,'DD//MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
                        group by ls.acctno)
                        ls
                    where df.codeid = se.codeid and df.lnacctno = ln.acctno
                    and ln.acctno = ls.acctno(+)
                    group by df.groupid) dfg,
                    securities_info sec
                    where df.groupid = dfg.groupid
                    and df.codeid = sec.codeid
                    and df.acctno = rec.refid;
                exception when others then
                    l_rlsamt:=0;
                end;

                select actype, substr(acctno,1,4) into l_actype, l_BrID from afmast where acctno = p_afacctno;

                FOR rec_pr IN (
                    SELECT DISTINCT pm.prcode
                    FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
                    WHERE pm.prcode = brm.prcode
                        AND pm.prcode = prtm.prcode
                        AND prt.actype = prtm.prtype
                        AND prt.actype = tpm.prtype
                        AND pm.prtyp = 'P'
                        AND prt.TYPE = 'AFTYPE'
                        AND pm.prstatus = 'A'
                        AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                        AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_BrID)
                           )
                LOOP
                    insert into prinusedlog (prcode,prinused,deltd,last_change,autoid,txnum,txdate)
                    values(rec_pr.prcode, -l_rlsamt, 'N', SYSTIMESTAMP, seq_prinusedlog.nextval, null,null );
                end loop;
                l_totalrlsamt:= l_totalrlsamt + l_rlsamt;
                -- >> Update Pool
                p_ALLqtty:=0;
            else
                update odmapext set execqtty =qtty where orderid = rec.orderid and refid = rec.refid and deltd <> 'Y';

                -- << Update Room
                update securities_info
                set syroomused = nvl(syroomused,0) - (rec.qtty-rec.execqtty)
                where codeid = p_CodeID;
                -- >> Update Room
                -- << Update Pool
                /*select (rec.qtty-rec.execqtty)*dfprice into l_rlsamt from dfmast where acctno = rec.refid;*/
                begin
                    select greatest(round((((rec.qtty-rec.execqtty)*sec.dfrlsprice*df.dfrate/100)/ dfg.dfamt) * dfg.lnamt,0),nvl(lnovdamt,0))
                        into l_rlsamt
                    from dfmast df,
                    (select df.groupid, sum((df.dfqtty+df.blockqtty+df.rcvqtty+df.carcvqtty)*se.dfrlsprice*df.dfrate/100) dfamt,
                    max(ln.prinnml+prinovd) lnamt, max(ln.prinovd+nvl(ls.nml,0)) lnovdamt
                    from dfmast df, securities_info se, lnmast ln,
                    (select ls.acctno, sum(nml) nml
                        from lnschd ls
                        where ls.reftype = 'P' and ls.overduedate = (select to_date(varvalue,'DD//MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
                        group by ls.acctno)
                        ls
                    where df.codeid = se.codeid and df.lnacctno = ln.acctno
                    and ln.acctno = ls.acctno(+)
                    group by df.groupid) dfg,
                    securities_info sec
                    where df.groupid = dfg.groupid
                    and df.codeid = sec.codeid
                    and df.acctno = rec.refid;
                exception when others then
                    l_rlsamt:=0;
                end;
                select actype, substr(acctno,1,4) into l_actype, l_BrID from afmast where acctno = p_afacctno;

                FOR rec_pr IN (
                    SELECT DISTINCT pm.prcode
                    FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
                    WHERE pm.prcode = brm.prcode
                        AND pm.prcode = prtm.prcode
                        AND prt.actype = prtm.prtype
                        AND prt.actype = tpm.prtype
                        AND pm.prtyp = 'P'
                        AND prt.TYPE = 'AFTYPE'
                        AND pm.prstatus = 'A'
                        AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                        AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_BrID)
                           )
                LOOP
                    insert into prinusedlog (prcode,prinused,deltd,last_change,autoid,txnum,txdate)
                    values(rec_pr.prcode, -l_rlsamt, 'N', SYSTIMESTAMP, seq_prinusedlog.nextval, null,null );
                end loop;
                l_totalrlsamt:= l_totalrlsamt + l_rlsamt;
                -- >> Update Pool
                p_ALLqtty:=p_ALLqtty-(rec.qtty-rec.execqtty);
            end if;
            exit when p_ALLqtty<=0;
        end loop;

        -- Log df release amount.
        insert into afprinusedlog (afacctno, preexecamt)
        values (p_afacctno, least(p_amount,l_totalrlsamt));
    else
        p_ALLqtty:=-p_qtty;
        for rec in (select * from odmapext where orderid = p_Orderid and deltd <> 'Y' and execqtty>0 order by ORDERNUM desc)
        loop
            if rec.execqtty>p_ALLqtty THEN
                update odmapext set execqtty= execqtty - p_ALLqtty where orderid = rec.orderid and refid = rec.refid and deltd <> 'Y';

                -- << Update Room
                update securities_info
                set syroomused = nvl(syroomused,0) + p_ALLqtty
                where codeid = p_CodeID;
                -- >> Update Room
                -- << Update Pool
                /*select p_ALLqtty*dfprice into l_rlsamt from dfmast where acctno = rec.refid;*/
                begin
                    select greatest(round(((p_ALLqtty*sec.dfrlsprice*df.dfrate/100)/ dfg.dfamt) * dfg.lnamt,0),nvl(lnovdamt,0))
                        into l_rlsamt
                    from dfmast df,
                    (select df.groupid, sum((df.dfqtty+df.blockqtty+df.rcvqtty+df.carcvqtty)*se.dfrlsprice*df.dfrate/100) dfamt,
                    max(ln.prinnml+prinovd) lnamt, max(ln.prinovd+nvl(ls.nml,0)) lnovdamt
                    from dfmast df, securities_info se, lnmast ln,
                    (select ls.acctno, sum(nml) nml
                        from lnschd ls
                        where ls.reftype = 'P' and ls.overduedate = (select to_date(varvalue,'DD//MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
                        group by ls.acctno)
                        ls
                    where df.codeid = se.codeid and df.lnacctno = ln.acctno
                    and ln.acctno = ls.acctno(+)
                    group by df.groupid) dfg,
                    securities_info sec
                    where df.groupid = dfg.groupid
                    and df.codeid = sec.codeid
                    and df.acctno = rec.refid;
                exception when others then
                    l_rlsamt:=0;
                end;
                select actype, substr(acctno,1,4) into l_actype, l_BrID from afmast where acctno = p_afacctno;

                FOR rec_pr IN (
                    SELECT DISTINCT pm.prcode
                    FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
                    WHERE pm.prcode = brm.prcode
                        AND pm.prcode = prtm.prcode
                        AND prt.actype = prtm.prtype
                        AND prt.actype = tpm.prtype
                        AND pm.prtyp = 'P'
                        AND prt.TYPE = 'AFTYPE'
                        AND pm.prstatus = 'A'
                        AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                        AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_BrID)
                           )
                LOOP
                    insert into prinusedlog (prcode,prinused,deltd,last_change,autoid,txnum,txdate)
                    values(rec_pr.prcode, l_rlsamt, 'N', SYSTIMESTAMP, seq_prinusedlog.nextval, null,null );
                end loop;
                -- >> Update Pool
                p_ALLqtty:=0;
            else
                update odmapext set  execqtty =0 where orderid = rec.orderid and refid = rec.refid and deltd <> 'Y';

                -- << Update Room
                update securities_info
                set syroomused = nvl(syroomused,0) + rec.execqtty
                where codeid = p_CodeID;
                -- >> Update Room
                -- << Update Pool
                /*select rec.execqtty*dfprice into l_rlsamt from dfmast where acctno = rec.refid;*/
                begin
                    select greatest(round(((rec.execqtty*sec.dfrlsprice*df.dfrate/100)/ dfg.dfamt) * dfg.lnamt,0),nvl(lnovdamt,0))
                        into l_rlsamt
                    from dfmast df,
                    (select df.groupid, sum((df.dfqtty+df.blockqtty+df.rcvqtty+df.carcvqtty)*se.dfrlsprice*df.dfrate/100) dfamt,
                    max(ln.prinnml+prinovd) lnamt, max(ln.prinovd+nvl(ls.nml,0)) lnovdamt
                    from dfmast df, securities_info se, lnmast ln,
                    (select ls.acctno, sum(nml) nml
                        from lnschd ls
                        where ls.reftype = 'P' and ls.overduedate = (select to_date(varvalue,'DD//MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
                        group by ls.acctno)
                        ls
                    where df.codeid = se.codeid and df.lnacctno = ln.acctno
                    and ln.acctno = ls.acctno(+)
                    group by df.groupid) dfg,
                    securities_info sec
                    where df.groupid = dfg.groupid
                    and df.codeid = sec.codeid
                    and df.acctno = rec.refid;
                exception when others then
                    l_rlsamt:=0;
                end;
                select actype, substr(acctno,1,4) into l_actype, l_BrID from afmast where acctno = p_afacctno;

                FOR rec_pr IN (
                    SELECT DISTINCT pm.prcode
                    FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
                    WHERE pm.prcode = brm.prcode
                        AND pm.prcode = prtm.prcode
                        AND prt.actype = prtm.prtype
                        AND prt.actype = tpm.prtype
                        AND pm.prtyp = 'P'
                        AND prt.TYPE = 'AFTYPE'
                        AND pm.prstatus = 'A'
                        AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                        AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_BrID)
                           )
                LOOP
                    insert into prinusedlog (prcode,prinused,deltd,last_change,autoid,txnum,txdate)
                    values(rec_pr.prcode, l_rlsamt, 'N', SYSTIMESTAMP, seq_prinusedlog.nextval, null,null );
                end loop;
                -- >> Update Pool
                p_ALLqtty:=p_ALLqtty-rec.execqtty;
            end if;
            exit when p_ALLqtty<=0;
        end loop;

        -- << Delete Order
        for rec in (select * from odmapext where orderid = p_Orderid and deltd = 'Y' and execqtty>0 order by ORDERNUM desc)
        loop

            -- << Update Room
            update securities_info
            set syroomused = nvl(syroomused,0) + rec.execqtty
            where codeid = p_CodeID;
            -- >> Update Room
            -- << Update Pool
            /*select rec.execqtty*dfprice into l_rlsamt from dfmast where acctno = rec.refid;*/
            begin
                select greatest(round(((rec.execqtty*sec.dfrlsprice*df.dfrate/100)/ dfg.dfamt) * dfg.lnamt,0),nvl(lnovdamt,0))
                    into l_rlsamt
                from dfmast df,
                    (select df.groupid, sum((df.dfqtty+df.blockqtty+df.rcvqtty+df.carcvqtty)*se.dfrlsprice*df.dfrate/100) dfamt,
                    max(ln.prinnml+prinovd) lnamt, max(ln.prinovd+nvl(ls.nml,0)) lnovdamt
                    from dfmast df, securities_info se, lnmast ln,
                    (select ls.acctno, sum(nml) nml
                        from lnschd ls
                        where ls.reftype = 'P' and ls.overduedate = (select to_date(varvalue,'DD//MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
                        group by ls.acctno)
                        ls
                    where df.codeid = se.codeid and df.lnacctno = ln.acctno
                    and ln.acctno = ls.acctno(+)
                    group by df.groupid) dfg,
                    securities_info sec
                where df.groupid = dfg.groupid
                and df.codeid = sec.codeid
                and df.acctno = rec.refid;
            exception when others then
                l_rlsamt:=0;
            end;

            select actype, substr(acctno,1,4) into l_actype, l_BrID from afmast where acctno = p_afacctno;

            FOR rec_pr IN (
                SELECT DISTINCT pm.prcode
                FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
                WHERE pm.prcode = brm.prcode
                    AND pm.prcode = prtm.prcode
                    AND prt.actype = prtm.prtype
                    AND prt.actype = tpm.prtype
                    AND pm.prtyp = 'P'
                    AND prt.TYPE = 'AFTYPE'
                    AND pm.prstatus = 'A'
                    AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                    AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_BrID)
                       )
            LOOP
                insert into prinusedlog (prcode,prinused,deltd,last_change,autoid,txnum,txdate)
                values(rec_pr.prcode, l_rlsamt, 'N', SYSTIMESTAMP, seq_prinusedlog.nextval, null,null );
            end loop;
            -- >> Update Pool
        end loop;
        -- >> Delete Order
    end if;
    plog.setendsection(pkgctx, 'pr_MortgageSellMatch');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_MortgageSellMatch');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_MortgageSellMatch;

PROCEDURE pr_RM_UnholdCancelOD( pv_strORDERID varchar2,pv_dblCancelQtty number,pv_strErrorCode in out varchar2)
IS
   l_txmsg tx.msg_rectype;
   v_dblCount NUMBER(20,0);
   v_strAFAcctNo VARCHAR2(10);
   v_strCOREBANK VARCHAR2(10);
   v_strBANKCODE  VARCHAR2(10);
   v_dblBratio  NUMBER(20,4);
   v_dblQuotePrice NUMBER(20,4);
   v_dblRemainHold NUMBER(20,0);
   v_dblUnholdBalance NUMBER(20,0);
   v_tltxcd VARCHAR2(4);
   v_strDesc VARCHAR2(250);
   v_strEN_Desc VARCHAR2(250);
   v_strNotes VARCHAR2(250);
   v_strCURRDATE VARCHAR2(10);
   l_err_param VARCHAR2(10);
BEGIN
    plog.setbeginsection (pkgctx, 'pr_RM_UnholdCancelOD');
    v_dblUnholdBalance:=0;
    --Check thong tin lenh co phai lenh mua hay ko
    BEGIN
        SELECT NVL(COUNT(OD.ORDERID),0) INTO v_dblCount FROM ODMAST OD
        WHERE OD.ORDERID=pv_strORDERID AND OD.EXECTYPE='NB';

        IF v_dblCount=0 THEN
            BEGIN
                pv_strErrorCode:='0';
                RETURN;
            END;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            v_dblUnholdBalance:=0;
    END;
    --Lay thong tin lenh, gia, ti le ky quy va check luon tk do co phai corebank hay ko
    SELECT OD.AFACCTNO,CI.COREBANK,AF.BANKNAME BANKCODE,OD.BRATIO,OD.QUOTEPRICE,GREATEST(CI.HOLDBALANCE - CI.depofeeamt,0),
    DECODE(OD.EXECTYPE,'NB','CB','NS','CS','MS','CS') || '.' || SI.SYMBOL || ': '
    || TO_CHAR(pv_dblCancelQtty) || '@' || DECODE(OD.PRICETYPE,'LO',
    TO_CHAR(OD.QUOTEPRICE), OD.PRICETYPE) NOTES
    INTO v_strAFAcctNo,v_strCOREBANK,v_strBANKCODE,v_dblBratio,v_dblQuotePrice,v_dblRemainHold,v_strNotes
    FROM ODMAST OD,CIMAST CI,AFMAST AF,CFMAST CF,SECURITIES_INFO SI
    WHERE OD.AFACCTNO=CI.AFACCTNO AND OD.CODEID=SI.CODEID
    AND OD.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID
    AND OD.ORDERID=pv_strORDERID AND OD.EXECTYPE IN ('NB');
    --Neu tk la corebank thi tinh gia tri can huy
    plog.debug(pkgctx, 'Afacctno: ' || v_strAFAcctNo || ' - Corebank: ' || v_strCOREBANK || ' - Cancel Order ID: ' || pv_strORDERID || ' - Cancel Qtty: ' || pv_dblCancelQtty);
    IF v_strCOREBANK='Y' THEN
        v_dblUnholdBalance := LEAST(pv_dblCancelQtty*v_dblQuotePrice*v_dblBratio/100,v_dblRemainHold);
        --Generate lenh unhold doi voi tk corebank
        IF v_dblUnholdBalance>0 THEN
            v_tltxcd:='6600';
            SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc
            FROM  TLTX WHERE TLTXCD=v_tltxcd;

            SELECT varvalue
            INTO v_strCURRDATE
            FROM sysvar
            WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

            SELECT systemnums.C_BATCH_PREFIXED
            || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO l_txmsg.txnum
            FROM DUAL;

            l_txmsg.brid := substr(v_strAFAcctNo,1,4);

            l_txmsg.msgtype:='T';
            l_txmsg.local:='N';
            l_txmsg.tlid        := systemnums.c_system_userid;
            SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                     SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
              INTO l_txmsg.wsname, l_txmsg.ipaddress
            FROM DUAL;
            l_txmsg.off_line    := 'N';
            l_txmsg.deltd       := txnums.c_deltd_txnormal;
            l_txmsg.txstatus    := txstatusnums.c_txcompleted;
            l_txmsg.msgsts      := '0';
            l_txmsg.ovrsts      := '0';
            l_txmsg.batchname   := 'BANK';
            l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
            l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
            l_txmsg.tltxcd:=v_tltxcd;
            SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc
            FROM  TLTX WHERE TLTXCD=v_tltxcd;

            FOR rec IN
            (
                SELECT CF.CUSTODYCD,CF.FULLNAME,CF.ADDRESS,CF.IDCODE LICENSE,AF.CAREBY,
                AF.BANKACCTNO,AF.BANKNAME||':'||CRB.BANKNAME BANKNAME,0 BANKAVAIL,
                CI.HOLDBALANCE BANKHOLDED,getavlpp(AF.ACCTNO) AVLRELEASE,CI.HOLDBALANCE HOLDAMT
                FROM AFMAST AF,CFMAST CF,CIMAST CI,CRBDEFBANK CRB
                WHERE AF.CUSTID=CF.CUSTID AND CI.AFACCTNO=AF.ACCTNO
                AND AF.BANKNAME=CRB.BANKCODE AND AF.ACCTNO=v_strAFAcctNo
            )
            LOOP
                l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                l_txmsg.txfields ('88').TYPE      := 'C';
                l_txmsg.txfields ('88').VALUE     := rec.CUSTODYCD;

                l_txmsg.txfields ('03').defname   := 'SECACCOUNT';
                l_txmsg.txfields ('03').TYPE      := 'C';
                l_txmsg.txfields ('03').VALUE     := v_strAFAcctNo;

                l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                l_txmsg.txfields ('90').TYPE      := 'C';
                l_txmsg.txfields ('90').VALUE     := rec.FULLNAME;

                l_txmsg.txfields ('91').defname   := 'ADDRESS';
                l_txmsg.txfields ('91').TYPE      := 'C';
                l_txmsg.txfields ('91').VALUE     := rec.ADDRESS;

                l_txmsg.txfields ('92').defname   := 'LICENSE';
                l_txmsg.txfields ('92').TYPE      := 'C';
                l_txmsg.txfields ('92').VALUE     := rec.LICENSE;

                l_txmsg.txfields ('97').defname   := 'CAREBY';
                l_txmsg.txfields ('97').TYPE      := 'C';
                l_txmsg.txfields ('97').VALUE     := rec.CAREBY;

                l_txmsg.txfields ('93').defname   := 'BANKACCT';
                l_txmsg.txfields ('93').TYPE      := 'C';
                l_txmsg.txfields ('93').VALUE     := rec.BANKACCTNO;

                l_txmsg.txfields ('95').defname   := 'BANKNAME';
                l_txmsg.txfields ('95').TYPE      := 'C';
                l_txmsg.txfields ('95').VALUE     := rec.BANKNAME;

                l_txmsg.txfields ('11').defname   := 'BANKAVAIL';
                l_txmsg.txfields ('11').TYPE      := 'N';
                l_txmsg.txfields ('11').VALUE     := rec.BANKAVAIL;

                l_txmsg.txfields ('12').defname   := 'BANKHOLDED';
                l_txmsg.txfields ('12').TYPE      := 'N';
                l_txmsg.txfields ('12').VALUE     := rec.BANKHOLDED;

                l_txmsg.txfields ('13').defname   := 'AVLRELEASE';
                l_txmsg.txfields ('13').TYPE      := 'N';
                l_txmsg.txfields ('13').VALUE     := rec.AVLRELEASE;

                l_txmsg.txfields ('96').defname   := 'HOLDAMT';
                l_txmsg.txfields ('96').TYPE      := 'N';
                l_txmsg.txfields ('96').VALUE     := rec.HOLDAMT;

                l_txmsg.txfields ('10').defname   := 'AMOUNT';
                l_txmsg.txfields ('10').TYPE      := 'N';
                l_txmsg.txfields ('10').VALUE     := v_dblUnholdBalance;

                l_txmsg.txfields ('30').defname   := 'DESC';
                l_txmsg.txfields ('30').TYPE      := 'C';
                l_txmsg.txfields ('30').VALUE     := v_strDesc;
            END LOOP;

            plog.debug(pkgctx,'Begin call 6600');
            BEGIN
                IF txpks_#6600.fn_AutoGenWhenCancelOD (l_txmsg,
                                                 pv_strErrorCode,
                                                 l_err_param
                   ) <> systemnums.c_success
                THEN
                   BEGIN
                       plog.debug(pkgctx,'Error when call 6600 , Error code : ' || pv_strErrorCode);
                       ROLLBACK;
                       RETURN;
                   END;
                END IF;
            END;

            plog.debug(pkgctx,'End call 6600 , Error code : ' || pv_strErrorCode);

            --Tao yeu cau UNHOLD gui sang Bank. REFCODE=ORDERID
            INSERT INTO CRBTXREQ (REQID, OBJTYPE, OBJNAME, TRFCODE, REFCODE, OBJKEY, TXDATE,
                BANKCODE, BANKACCT, AFACCTNO, TXAMT, STATUS, REFTXNUM, REFTXDATE, REFVAL, NOTES)
            SELECT SEQ_CRBTXREQ.NEXTVAL, 'V', 'ODMAST', 'UNHOLD', pv_strORDERID, pv_strORDERID,
                TO_DATE(v_strCURRDATE,systemnums.c_date_format),v_strBANKCODE, l_txmsg.txfields ('93').VALUE,
                v_strAFAcctNo, v_dblUnholdBalance, 'P', null, null, null, v_strNotes
            FROM DUAL;
        END IF;
    END IF;
    pv_strErrorCode:=0;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_RM_UnholdCancelOD');
      RAISE errnums.E_SYSTEM_ERROR;
END pr_RM_UnholdCancelOD;

  Procedure pr_SEMarginInfoUpdate(p_Afacctno varchar2, p_Codeid varchar2, p_Qtty number)
  IS
    l_count number;
  BEGIN
    plog.setendsection(pkgctx, 'pr_SEMarginInfoUpdate');
    -- tk margin
    select count(1) into l_count
    from afmast af, aftype aft, mrtype mrt, lntype lnt
    where af.acctno = p_Afacctno
          and af.actype = aft.actype
          and aft.mrtype = mrt.actype
          and mrt.mrtype = 'T'
          and aft.lntype = lnt.actype(+);
    if l_count>0 then
          update semargininfo
          set syodqtty = syodqtty + p_Qtty
          where codeid = p_Codeid;
    end if;
    -- tk tuan thu
    select count(1) into l_count
    from afmast af, aftype aft, mrtype mrt, lntype lnt
    where af.acctno = p_Afacctno
        and af.actype = aft.actype
        and aft.mrtype = mrt.actype
        and mrt.mrtype = 'T'
        and aft.lntype = lnt.actype(+)
        and (   nvl(lnt.chksysctrl,'N') = 'Y'
            or exists (select 1 from afidtype afi, lntype lnt1 where afi.objname = 'LN.LNTYPE' and afi.aftype = af.actype and afi.actype = lnt1.actype and lnt1.chksysctrl='Y'));
    if l_count > 0 then
        update semargininfo
        set odqtty = odqtty + p_Qtty
        where codeid = p_Codeid;
    end if;

    plog.setendsection(pkgctx, 'pr_SEMarginInfoUpdate');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_SEMarginInfoUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_SEMarginInfoUpdate;

PROCEDURE pr_update_secinfo
                            (  pv_Symbol IN VARCHAR2,
                               pv_ceilingprice IN VARCHAR2,
                               pv_floorprice in varchar2 ,
                               pv_basicprice IN VARCHAR2,
                               pv_tradeplace IN varchar2,
                               p_security_type IN VARCHAR2,
                               p_err_code in out VARCHAR2
                             )
IS

-- Purpose: update securities info
-- MODIFICATION HISTORY
-- Person      Date        Comments
-- NAMNT     22/07/2014
-- ---------   ------  -------------------------------------------
l_tradeplace_old varchar2(10);
l_codeid_old varchar2(10);
l_symbol varchar2(50);
l_codeid_new varchar2(10);
l_issuer_new varchar2(10);
l_ticksize_count_1 NUMBER;
l_ticksize_count_2 NUMBER;
l_ticksize_count_3 NUMBER;
l_ticksizeSum_count NUMBER;
l_trdelot  NUMBER;
l_status varchar2(10);
v_strWFTcodeid varchar2(10);
v_AUTOIDSR NUMBER;
v_sb_info NUMBER;
l_sectype varchar2(10); --1.5.6.0
v_tradelot_hsx        NUMBER;
v_tradelot_hnx        NUMBER;
   -- Declare program variables as shown above
BEGIN
  l_symbol:=pv_Symbol;
BEGIN
SELECT tradeplace,codeid  INTO l_tradeplace_old, l_codeid_old FROM sbsecurities WHERE symbol =pv_Symbol;
EXCEPTION
   WHEN OTHERS THEN
   l_tradeplace_old:='';
   l_codeid_old:='';
END ;
   --Lay thong tin lo default
    BEGIN
      SELECT to_number(varvalue) INTO v_tradelot_hsx FROM sysvar WHERE varname = 'HSX_DEFAULT_TRADELOT';
      SELECT to_number(varvalue) INTO v_tradelot_hnx FROM sysvar WHERE varname = 'HNX_DEFAULT_TRADELOT';
    EXCEPTION WHEN OTHERS THEN
      v_tradelot_hsx := 100;
      v_tradelot_hnx := 100;
    END;
    
    IF pv_tradeplace ='001' THEN
      l_trdelot:=v_tradelot_hsx;
    ELSE
      l_trdelot:=v_tradelot_hnx;
    END IF;
l_status:='N';


--1 THIEU MA CK

    IF nvl(l_codeid_old,'ZZZ') ='ZZZ' THEN
        l_status:='Y';

          plog.error(pkgctx,'Them ma ck : ' || pv_Symbol);
        --tao codeid new
         SELECT lpad( (MAX(TO_NUMBER(INVACCT)) + 1),6,'0') INTO  l_codeid_new  FROM
                          (SELECT ROWNUM ODR, INVACCT
                          FROM (SELECT CODEID INVACCT FROM SBSECURITIES WHERE SUBSTR(CODEID, 1, 1) <> 9 ORDER BY CODEID) DAT
                          ) INVTAB;
        --tao ck codeid wft
        SELECT TO_CHAR(lpad(MAX(TO_NUMBER(INVACCT)) + 2,6,0)) AUTOINV into v_strWFTcodeid  FROM
                          (SELECT ROWNUM ODR, INVACCT
                          FROM (SELECT CODEID INVACCT FROM SBSECURITIES WHERE SUBSTR(CODEID, 1, 1) <> 9 ORDER BY CODEID) DAT
                          ) INVTAB;
        --tao issuer new

         SELECT lpad ((MAX(TO_NUMBER(ISSUERID)) + 1),10,'0') INTO  l_issuer_new FROM ISSUERS;

        INSERT INTO ISSUERS (ISSUERID,SHORTNAME,FULLNAME,OFFICENAME,CUSTID,ADDRESS,PHONE,FAX,ECONIMIC,BUSINESSTYPE,BANKACCOUNT,BANKNAME,LICENSENO,LICENSEDATE,LINCENSEPLACE,OPERATENO,OPERATEDATE,OPERATEPLACE,LEGALCAPTIAL,SHARECAPITAL,MARKETSIZE,PRPERSON,INFOADDRESS,DESCRIPTION,STATUS,PSTATUS)
        VALUES(l_issuer_new,l_symbol,l_symbol||'-AUTO','',NULL,'','','','002','001','0','0','',TO_DATE('01/01/2000','DD/MM/RRRR'),'7','8',TO_DATE('01/01/2000','DD/MM/RRRR'),'So KHDT',0,0,'001',NULL,NULL,NULL,'A',NULL);

            IF pv_tradeplace ='001' THEN
                BEGIN   --1.5.6.0 them loc sectype
                    SELECT MAX(CASE WHEN TRIM(STOCK_TYPE) = '3' THEN '007'
                        WHEN TRIM(STOCK_TYPE) = '2' THEN '006'
                        WHEN TRIM(STOCK_TYPE) = '4' THEN '011'
                        ELSE '001' END) INTO L_SECTYPE
                    FROM Ho_sec_info WHERE CODE = l_symbol;
                EXCEPTION WHEN OTHERS THEN
                    L_SECTYPE := '001';
                END ;
             IF p_security_type = 'W' THEN
                INSERT INTO sbsecurities (CODEID,ISSUERID,SYMBOL,SECTYPE,INVESTMENTTYPE,RISKTYPE,PARVALUE,FOREIGNRATE,STATUS,TRADEPLACE,DEPOSITORY,SECUREDRATIO,MORTAGERATIO,REPORATIO,ISSUEDATE,EXPDATE,INTPERIOD,INTRATE,HALT,SBTYPE,CAREBY,CHKRATE,REFCODEID,ISSQTTY,BONDTYPE,MARKETTYPE,ALLOWSESSION,CWTERM,settlementtype,underlyingtype,nvalue)
                VALUES(l_codeid_new,l_issuer_new,l_symbol ,L_SECTYPE,'002','001',10000,49,'Y',pv_tradeplace,'001',0,0,0,getcurrdate(),getcurrdate(),0,0,'N','001','0017',0,NULL,0,'000','000','AL',6,'CWMS','S',1);

                INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET)
                VALUES(seq_securities_info.nextval,l_codeid_new,l_symbol,getcurrdate(),0,1000,'N',1,getcurrdate(),'001',1,1,getcurrdate(),'001',pv_basicprice,0,0,0,0,0,pv_ceilingprice,pv_floorprice,1,'002',0,0,1,1,1,1,1,l_trdelot,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
              ELSE
                INSERT INTO sbsecurities (CODEID,ISSUERID,SYMBOL,SECTYPE,INVESTMENTTYPE,RISKTYPE,PARVALUE,FOREIGNRATE,STATUS,TRADEPLACE,DEPOSITORY,SECUREDRATIO,MORTAGERATIO,REPORATIO,ISSUEDATE,EXPDATE,INTPERIOD,INTRATE,HALT,SBTYPE,CAREBY,CHKRATE,REFCODEID,ISSQTTY,BONDTYPE,MARKETTYPE,ALLOWSESSION)
                VALUES(l_codeid_new,l_issuer_new,l_symbol ,L_SECTYPE,'002','001',10000,49,'Y',pv_tradeplace,'001',0,0,0,getcurrdate(),getcurrdate(),0,0,'N','001','0017',0,NULL,0,'000','000','AL');

                INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET)
                VALUES(seq_securities_info.nextval,l_codeid_new,l_symbol,getcurrdate(),0,1000,'N',1,getcurrdate(),'001',1,1,getcurrdate(),'001',pv_basicprice,0,0,0,0,0,pv_ceilingprice,pv_floorprice,1,'002',0,0,1,1,1,1,1,l_trdelot,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
              END IF ;
           ELSE
             --1.5.6.0:ADD TPDN sectype = '012'
             if (p_security_type = 'CORP') then l_sectype:= '012';
             else l_sectype:= '001';
             end if;
               INSERT INTO sbsecurities (CODEID,ISSUERID,SYMBOL,SECTYPE,INVESTMENTTYPE,RISKTYPE,PARVALUE,FOREIGNRATE,STATUS,TRADEPLACE,DEPOSITORY,SECUREDRATIO,MORTAGERATIO,REPORATIO,ISSUEDATE,EXPDATE,INTPERIOD,INTRATE,HALT,SBTYPE,CAREBY,CHKRATE,REFCODEID,ISSQTTY,BONDTYPE,MARKETTYPE,ALLOWSESSION)
               VALUES(l_codeid_new,l_issuer_new,l_symbol,l_sectype,'002','001',10000,49,'Y',pv_tradeplace,'001',0,0,0,NULL,NULL,0,0,'N','001','0023',0,NULL,0,'000','000','AL');

               INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET)
               VALUES(seq_securities_info.NEXTVAL,l_codeid_new,l_symbol,getcurrdate(),0,1000,'N',1,getcurrdate(),'001',1,1,getcurrdate(),'001',pv_basicprice,0,0,0,0,0,pv_ceilingprice,pv_floorprice,1,'002',0,0,1,1,1,1,1,l_trdelot,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

            END IF;

        INSERT INTO securities_risk (CODEID,MRMAXQTTY,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,ISMARGINALLOW)
        VALUES(l_codeid_new,10000000,0,0,10000000,10000000,'N');

           --Tao thong tin bang securities_rate
            SELECT MAX(AUTOID) + 1
                  INTO v_AUTOIDSR
                  FROM SECURITIES_RATE;
           DELETE securities_rate WHERE SYMBOL=l_symbol;
           insert into securities_rate (AUTOID, CODEID, SYMBOL, FROMPRICE, TOPRICE, MRRATIORATE, MRRATIOLOAN, STATUS)
           values (v_AUTOIDSR, l_codeid_new, l_symbol, 1, 1000000, 99, 99, 'Y');
       IF p_security_type <> 'W' THEN --KHONG TAO WFT VOI SECTYPE ='011'
           -- ck cho giao dich
                INSERT INTO SBSECURITIES(CODEID,ISSUERID,SYMBOL,SECTYPE,INVESTMENTTYPE,RISKTYPE,PARVALUE,FOREIGNRATE,STATUS,TRADEPLACE,DEPOSITORY,SECUREDRATIO,MORTAGERATIO,REPORATIO,ISSUEDATE,EXPDATE,INTPERIOD,INTRATE,HALT,SBTYPE,CAREBY,CHKRATE,REFCODEID)
                vALUES( TO_CHAR( v_strWFTcodeid) ,  l_issuer_new, l_symbol||'_WFT' , '001', '', '', 10000, 49, 'Y','006' ,'002' , 0, 0, 0, getcurrdate(), getcurrdate(), 0, 0, 'N', '001','0017', 0,  l_codeid_new);

                 INSERT INTO SECURITIES_INFO (
                            AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                            ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                            AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                            DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                            REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                            SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                            CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                     VALUES (
                            SEQ_SECURITIES_INFO.NEXTVAL, v_strWFTcodeid, l_symbol||'_WFT',getcurrdate(),
                            1, 1000, 'N', 1, getcurrdate(), '001', 1, 1,
                            getcurrdate(), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '001',
                            0, 0, 1, 1, 1, 1, 1, l_trdelot, 'Y', 0, 1000000000, 0,
                            1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0);
          END IF;
        --MSBS-1847     1.5.2.6
        IF p_security_type IN ('E','EF') THEN
            UPDATE SBSECURITIES SET is_etf = 'Y' WHERE symbol = l_symbol;
        END IF;
        --End MSBS-1847     1.5.2.6
        --dong bo len FO
        BEGIN
            pr_t_fo_instruments;
        END;

        --Insert vao t_fo_event de GEN Msg sang FO
        INSERT INTO t_fo_event (AUTOID, TXNUM, TXDATE, ACCTNO, TLTXCD,LOGTIME,PROCESSTIME,PROCESS,ERRCODE,ERRMSG,NVALUE,CVALUE)
        SELECT seq_fo_event.NEXTVAL, 'AUTO-00000', getcurrdate, l_symbol,'2285',systimestamp,systimestamp,'N','0',NULL, NULL, NULL
        FROM DUAL WHERE EXISTS (SELECT TLTXCD FROM FOTXMAP WHERE TLTXCD = '2285');

   END IF; --End tao moi ma

    IF l_status='N' THEN
        --2 KHAC SAN THI DOI SAN
        IF nvl(l_tradeplace_old,pv_tradeplace) <> pv_tradeplace THEN
            l_status:='Y';
            UPDATE SBSECURITIES SET TRADEPLACE =pv_tradeplace WHERE SYMBOL=pv_Symbol;
            DELETE SECURITIES_TICKSIZE WHERE CODEID = l_codeid_old;
            IF pv_tradeplace ='001' THEN
                --Ma goc
                SELECT COUNT(*) INTO v_sb_info FROM SECURITIES_INFO  WHERE SYMBOL=pv_Symbol;
                IF v_sb_info>0 THEN
                  UPDATE SECURITIES_INFO set TRADELOT =l_trdelot  WHERE SYMBOL=pv_Symbol;
                ELSE
                  INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET)
                    VALUES(seq_securities_info.nextval,l_codeid_old,pv_Symbol,getcurrdate(),0,1000,'N',1,getcurrdate(),'001',1,1,getcurrdate(),'001',pv_basicprice,0,0,0,0,0,pv_ceilingprice,pv_floorprice,1,'002',0,0,1,1,1,1,1,l_trdelot,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
                END IF;

                INSERT INTO setradeplace (AUTOID,TXDATE,CODEID,CTYPE,FRTRADEPLACE,TOTRADEPLACE)
                VALUES(seq_setradeplace.NEXTVAL ,getcurrdate(),l_codeid_old,'CA',l_tradeplace_old,pv_tradeplace);

            ELSE
                 --Ma goc
                SELECT COUNT(*) INTO v_sb_info FROM SECURITIES_INFO  WHERE SYMBOL=pv_Symbol;
                IF v_sb_info>0 THEN
                  UPDATE SECURITIES_INFO set TRADELOT =l_trdelot WHERE SYMBOL=pv_Symbol;
                ELSE
                  INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET)
                         VALUES(seq_securities_info.NEXTVAL,l_codeid_old,pv_Symbol,getcurrdate(),0,1000,'N',1,getcurrdate(),'001',1,1,getcurrdate(),'001',pv_basicprice,0,0,0,0,0,pv_ceilingprice,pv_floorprice,1,'002',0,0,1,1,1,1,1,l_trdelot,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
                  END IF;

                  INSERT INTO setradeplace (AUTOID,TXDATE,CODEID,CTYPE,FRTRADEPLACE,TOTRADEPLACE)
                  VALUES(seq_setradeplace.NEXTVAL ,getcurrdate(),l_codeid_old,'CA',l_tradeplace_old,pv_tradeplace);

            END IF;
            --Ma WFT
            SELECT COUNT(*) INTO v_sb_info FROM SECURITIES_INFO  WHERE codeid=(SELECT codeid FROM sbsecurities WHERE refcodeid =l_codeid_old);
            IF v_sb_info>0 THEN
                UPDATE SECURITIES_INFO set TRADELOT =l_trdelot  WHERE codeid=(SELECT codeid FROM sbsecurities WHERE refcodeid =l_codeid_old);
            ELSE
            --tao ck codeid wft
            SELECT TO_CHAR(lpad(MAX(TO_NUMBER(INVACCT)) + 2,6,0)) AUTOINV into v_strWFTcodeid  FROM
                        (SELECT ROWNUM ODR, INVACCT
                        FROM (SELECT CODEID INVACCT FROM SBSECURITIES WHERE SUBSTR(CODEID, 1, 1) <> 9 ORDER BY CODEID) DAT
                        ) INVTAB;
            IF p_security_type <> 'W' THEN --KHONG TAO WFT VOI SECTYPE ='011'     -1.5.6.0
                INSERT INTO SECURITIES_INFO (
                              AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                              ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                              AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                              DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                              REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                              SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                              CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                       VALUES (
                              SEQ_SECURITIES_INFO.NEXTVAL, v_strWFTcodeid, pv_Symbol||'_WFT',getcurrdate(),
                              1, 1000, 'N', 1, getcurrdate(), '001', 1, 1,
                              getcurrdate(), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '001',
                              0, 0, 1, 1, 1, 1, 1, l_trdelot, 'Y', 0, 1000000000, 0,
                              1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0);
                END IF;
            END IF;
        END IF ;
        --dong bo len FO tren GWHA HO
    END IF;
p_err_code:='0';
EXCEPTION
   WHEN OTHERS THEN
         plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_CancelOrderAfterDay');
      p_err_code :='0';
      RAISE errnums.E_SYSTEM_ERROR;
        return;
END;
---------------------------------fn_OD_ClearOrder------------------------------------------------
FUNCTION fn_OD_ClearOrder(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_strTIMETYPE   VARCHAR2(10);
v_dblRemainQtty NUMBER(20,4);
v_dblEXECQTTY NUMBER(20,4);
v_dblEXECAMT  NUMBER(20,4);
v_dblCANCELQTTY NUMBER(20,4);
v_dblADJUSTQTTY NUMBER(20,4);
v_dblQuotePrice NUMBER(20,4);
v_dblUnholdAmt NUMBER(20,4);
l_count NUMBER(20);
v_strORGORDERID VARCHAR2(20);
v_strCIACCTNO VARCHAR2(20);
v_strCoreBank VARCHAR(1);
v_dblHOLDBALANCE NUMBER(20,4);
v_dblAVLCANCELQTTY NUMBER(20,4);
V_FOACCTNO VARCHAR2(50);
V_DBLDIFFQTTY NUMBER(20,4);
V_STRAFACCTNO VARCHAR2(20);
v_strSEACCTNO VARCHAR2(20);
v_strDeltd    VARCHAR2(1);
v_dblIsMortage NUMBER(20);
v_dblAVLCANCELAMT NUMBER(20,4);

BEGIN
    plog.setbeginsection (pkgctx, 'fn_OD_ClearOrder');
    plog.debug (pkgctx, '<<BEGIN OF fn_OD_ClearOrder');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_blnREVERSAL:= case when p_txmsg.deltd ='Y' then true else false end;
    p_err_code:=0;
    v_strORGORDERID:=p_txmsg.txfields ('03').VALUE;
    v_strCIACCTNO:=p_txmsg.txfields ('05').VALUE;
    v_dblAVLCANCELQTTY:=TO_NUMBER(p_txmsg.txfields ('10').VALUE);
    V_STRAFACCTNO:=p_txmsg.txfields ('07').VALUE;

    if(p_txmsg.tltxcd='8807' OR p_txmsg.tltxcd='8810') THEN
       v_dblIsMortage:=to_number(p_txmsg.txfields ('60').VALUE);
    END IF;

    v_strSEACCTNO:=to_number(p_txmsg.txfields ('06').VALUE);
    v_dblAVLCANCELAMT:=to_number(p_txmsg.txfields ('11').VALUE);
    SELECT COUNT(*) INTO l_count FROM ODMAST WHERE ORDERID =v_strORGORDERID;
    v_dblQuotePrice:=0;
    if(l_count <=0 ) THEN
      p_err_code:='-700037';
      plog.setendsection (pkgctx, 'fn_OD_ClearOrder');
      RETURN errnums.C_BIZ_RULE_INVALID;
    ELSE
      SELECT   TIMETYPE,REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
      INTO    v_strTIMETYPE,v_dblRemainQtty,v_dblEXECQTTY,v_dblEXECAMT,v_dblCANCELQTTY,v_dblADJUSTQTTY
      FROM ODMAST
      WHERE ORDERID =v_strORGORDERID;
    END IF;

    if not v_blnREVERSAL THEN
    --CHieu  thuan giao dich
      if(p_txmsg.tltxcd='8808' OR p_txmsg.tltxcd='8811') THEN
         SELECT upper(COREBANK),HOLDBALANCE
         INTO v_strCoreBank,v_dblHOLDBALANCE
         FROM CIMAST WHERE ACCTNO=v_strCIACCTNO ;
         if(v_strCoreBank='Y') THEN
          --Chi giai toa phan gia tri chua khop, phan phi thi phai cho tinh va giai toa sau
              v_dblUnholdAmt:= v_dblAVLCANCELQTTY * v_dblQuotePrice;
              IF(v_dblHOLDBALANCE<v_dblUnholdAmt) THEN
                   p_err_code:='-670064';
                   plog.setendsection (pkgctx, 'fn_OD_ClearOrder');
                   RETURN errnums.C_BIZ_RULE_INVALID;
              ELSE-- thuc hien jai  toa

                 cspks_odproc.pr_RM_UnholdCancelOD( v_strORGORDERID ,v_dblAVLCANCELQTTY ,p_err_code) ;

              END IF;
           END IF;
       END IF;



      --Kiem tra so luong yeu cau huy co phu hop khong
      SELECT COUNT(*) INTO l_count
      FROM ODMAST
      WHERE ORDERID=v_strORGORDERID AND ORDERQTTY-ADJUSTQTTY-CANCELQTTY-EXECQTTY>=v_dblAVLCANCELQTTY;
      if(l_count <=0 ) THEN
          p_err_code:='-700018';
          plog.setendsection (pkgctx, 'fn_OD_ClearOrder');
          RETURN errnums.C_BIZ_RULE_INVALID;
      END IF;

      --Ghi nhan vao so lenh day di, trang thai OOD la E, Error khong cho phep day di
      SELECT COUNT(*) INTO L_COUNT
      FROM OOD WHERE ORGORDERID=v_strORGORDERID AND OODSTATUS <>'E';
      IF(L_COUNT>0) THEN
          --Cap nhat trang thai cua OOD
            UPDATE OOD SET OODSTATUS='E' WHERE ORGORDERID=v_strORGORDERID AND OODSTATUS <>'E';
          --CAP NHAT TRANG THAI CUA ODQUEUE
            UPDATE ODQUEUE SET DELTD='Y' WHERE ORGORDERID=v_strORGORDERID;
      END IF;
      If v_strTIMETYPE = 'G' Then
                    --Cap nhat tro lai voi lenh GTC
            SELECT COUNT(*) INTO L_COUNT FROM FOMAST
            WHERE ORGACCTNO= v_strORGORDERID  AND DELTD<>'Y' AND TIMETYPE='G';

            If L_COUNT > 0 THEN
                SELECT ACCTNO INTO V_FOACCTNO
                FROM FOMAST WHERE ORGACCTNO= v_strORGORDERID
                AND DELTD<>'Y' AND TIMETYPE='G';

                UPDATE FOMAST
                SET STATUS='P',REMAINQTTY=v_dblRemainQtty ,
                EXECQTTY= v_dblEXECQTTY,EXECAMT= v_dblEXECAMT,
                CANCELQTTY=v_dblCANCELQTTY,AMENDQTTY= v_dblADJUSTQTTY
                WHERE ACCTNO=V_FOACCTNO;

            End IF;
     End If ;
    else
       -- xoa giao dich
       IF(p_txmsg.tltxcd='8808') THEN
            --TungNT added, neu la lenh mua corebank thi ko cho phep xoa
            If p_txmsg.tltxcd='8808' Or p_txmsg.tltxcd='8811' Then
               SELECT upper(COREBANK),HOLDBALANCE
               INTO v_strCoreBank,v_dblHOLDBALANCE
               FROM CIMAST WHERE ACCTNO=v_strCIACCTNO ;

                If v_strCoreBank = 'Y' Then
                    p_err_code:='-100017';
                    plog.setendsection (pkgctx, 'fn_OD_ClearOrder');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                End IF;

            End IF;
           --TungNT End
           --xoa phai kiem tra balance
             SELECT  COUNT(*)
             INTO L_COUNT
             FROM CIMAST WHERE ACCTNO =  V_STRAFACCTNO
             AND BALANCE >= v_dblAVLCANCELAMT;
            If L_COUNT <= 0 Then
                --So luong huy khong hop le
                p_err_code:='-700044';
                plog.setendsection (pkgctx, 'fn_OD_ClearOrder');
                RETURN errnums.C_BIZ_RULE_INVALID;
            End IF;
       ELSIF(p_txmsg.tltxcd='8807') THEN
        --xoa phai kiem tra TRADE , MORTAGE
          SELECT COUNT(*)
          INTO L_COUNT
          FROM SEMAST
          WHERE ACCTNO =  v_strSEACCTNO
          AND (
              (v_dblIsMortage = 0 AND TRADE >= v_dblAVLCANCELQTTY)
              OR (v_dblIsMortage <> 0 AND MORTAGE >= v_dblAVLCANCELQTTY )
              ) ;
          If L_COUNT <= 0 Then
                --So luong huy khong hop le
                p_err_code:='-700045';
                plog.setendsection (pkgctx, 'fn_OD_ClearOrder');
                RETURN errnums.C_BIZ_RULE_INVALID;
           End IF;

         --Tra lai trang thai cho lenh outgoing
           SELECT COUNT(*) INTO L_COUNT FROM OOD WHERE ORGORDERID= v_strORGORDERID  AND OODSTATUS='E';

                If L_COUNT > 0 Then
                   --Lenh da duoc giai toa hoac chua duoc day di thi khong can cap nhat lai trang thai OOD

                    --Cap nhat trang thai cua OOD
                    SELECT COUNT(*) INTO L_COUNT
                    FROM ODQUEUE WHERE ORGORDERID= v_strORGORDERID ;

                    If L_COUNT<= 0 Then
                        --NEU LENH GIAI TOA LA CHUA SEND THI VAO ODSEND
                        UPDATE OOD SET OODSTATUS='N'
                        WHERE ORGORDERID= v_strORGORDERID  AND OODSTATUS='E';

                    Else
                        --LENH SAU KHI GIAI TOA MA DA SEND THI KHONG DUOC XOA
                        SELECT deltd INTO v_strDeltd
                        FROM ODQUEUE WHERE ORGORDERID= v_strORGORDERID ;
                        If v_strDeltd <> 'Y' Then
                           --'LENH DA SEND, KHONG DUOC XOA
                            p_err_code:='-700027';
                            plog.setendsection (pkgctx, 'fn_OD_ClearOrder');
                            RETURN errnums.C_BIZ_RULE_INVALID;

                        Else
                            --NEU LENH DA DAY ROI THI DUA VAO ODMATCH
                            UPDATE OOD SET OODSTATUS='S'
                            WHERE ORGORDERID= v_strORGORDERID  AND OODSTATUS='E';

                            UPDATE ODQUEUE SET DELTD='N' WHERE ORGORDERID= v_strORGORDERID ;

                        End IF;

                    End IF;

                End If ;
                If v_strTIMETYPE = 'G' Then
                   --Cap nhat tro lai voi lenh GTC
                    SELECT COUNT(*) INTO l_count
                    FROM FOMAST WHERE ORGACCTNO= v_strORGORDERID
                    AND DELTD<>'Y' AND TIMETYPE='G' AND STATUS='P';

                    If l_count > 0 THEN
                        SELECT acctno INTO V_FOACCTNO
                        FROM FOMAST WHERE ORGACCTNO= v_strORGORDERID
                        AND DELTD<>'Y' AND TIMETYPE='G' AND STATUS='P';

                        UPDATE FOMAST SET STATUS='A',
                        REMAINQTTY=v_dblRemainQtty ,EXECQTTY= v_dblEXECQTTY ,
                        EXECAMT=v_dblEXECAMT ,CANCELQTTY= v_dblCANCELQTTY ,
                        AMENDQTTY= v_dblADJUSTQTTY
                        WHERE ACCTNO= V_FOACCTNO;

                    Else
                        --Lenh yeu cau GTC da bi send di roi
                         p_err_code:='-700004';
                         plog.setendsection (pkgctx, 'fn_OD_ClearOrder');
                         RETURN errnums.C_BIZ_RULE_INVALID;
                    End IF;
                End IF;
            END IF;

       END IF;

    plog.debug (pkgctx, '<<END OF fn_OD_ClearOrder');
    plog.setendsection (pkgctx, 'fn_OD_ClearOrder');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_OD_ClearOrder');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_OD_ClearOrder;

    PROCEDURE pr_ConfirmOrder(p_Orderid varchar2,p_userId VARCHAR2,p_custid VARCHAR2,p_Ipadrress VARCHAR2,pv_strErrorCode in out varchar2,p_via varchar2 default 'O')
  IS
  l_reforderid VARCHAR2(20);
  l_count      NUMBER;
  l_confirmed  char(1);
  l_suborderid VARCHAR2(20);
  BEGIN
    plog.setendsection(pkgctx, 'fn_ConfirmOrder');
    pv_strErrorCode:='0';
    -- check xem lenh da dc xac nhan chua
    SELECT COUNT(*) INTO l_count FROM confirmodrsts
    WHERE orderid=p_Orderid;
    IF l_count=1 THEN
        SELECT nvl(confirmed,'N' ) INTO l_confirmed
        FROM confirmodrsts
        WHERE orderid=p_Orderid;

        IF l_confirmed = 'Y' THEN
            pv_strErrorCode:= '-700085';
            plog.setendsection(pkgctx, 'fn_checkTradingAllow');
            RETURN;
        END IF;
    END IF;

    -- insert dong xac nhan cho lenh
    insert into confirmodrsts (ORDERID, CONFIRMED, USERID, custid, CFMTIME, IPADRRESS,via)
    values (p_Orderid, 'Y', p_userId, p_custid,systimestamp, p_Ipadrress,p_via );

    SELECT nvl(reforderid,'a') INTO l_reforderid FROM
    (SELECT * FROM odmast UNION ALL SELECT * FROM odmasthist)
    where orderid=p_Orderid;
    -- xac nhan cho lenh con
    SELECT COUNT(*) INTO l_count
    FROM
       (SELECT * FROM odmast UNION ALL SELECT * FROM odmasthist) OD
    WHERE reforderid=l_reforderid AND orderid <> p_Orderid;
    IF (l_count = 1) THEN
        SELECT orderid INTO l_suborderid
          FROM
         (SELECT * FROM odmast UNION ALL SELECT * FROM odmasthist) OD
        WHERE reforderid=l_reforderid AND orderid <> p_Orderid;
        -- check xem lenh con da duoc confirm chua
        SELECT COUNT(*)
        INTO l_count
        FROM confirmodrsts
        WHERE confirmed='Y' AND orderid= l_suborderid;
        -- insert dong xac nhan cho lenh con
        IF ( l_count = 0)  THEN
            insert into confirmodrsts (ORDERID, CONFIRMED, USERID, custid, CFMTIME, IPADRRESS,via)
            values (l_suborderid, 'Y', p_userId, p_custid,systimestamp, p_Ipadrress,p_via );
        END IF;
    END IF;
    plog.setendsection(pkgctx, 'fn_ConfirmOrder');

  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_ConfirmOrder');
      pv_strErrorCode:='1';
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ConfirmOrder;

 FUNCTION fn_OD_GetRootOrderID
    (p_OrderID       IN  VARCHAR2
    ) RETURN VARCHAR2
AS
    v_Found     BOOLEAN;
    v_TempOrderid   varchar2(20);
    v_TempRootOrderID varchar2(20);

BEGIN
    v_Found := FALSE;
    v_TempOrderid := p_OrderID;

    WHILE v_Found = FALSE
    LOOP
        SELECT NVL(OD.REFORDERID, '0000')
        INTO v_TempRootOrderID
        FROM (SELECT * FROM ODMAST UNION ALL SELECT * FROM odmasthist) OD
         WHERE OD.ORDERID = v_TempOrderid;
        IF v_TempRootOrderID <> '0000' THEN
            v_TempOrderid := v_TempRootOrderID;
            v_Found := FALSE;
        ELSE
            v_Found := TRUE;
        END IF;
    END LOOP;

    RETURN v_TempOrderid;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'fn_GetRootOrderID');
    RETURN '0000';
END;
-- initial LOG

PROCEDURE pr_CancelOrderAfterDay( pv_tradeplace VARCHAR2, pv_pricetype VARCHAR2, pv_exectype VARCHAR2, pv_afacctno VARCHAR2,pv_custodycd VARCHAR2, p_err_code IN OUT VARCHAR2)
IS
    v_strcorebank char(1);
    v_stralternateacct char(1);
    l_remainqtty    number;
    l_refremainqtty NUMBER;
    l_status varchar2(10);
    l_CONTROLCODE varchar2(10);
    l_exectype varchar2(10);
    l_custodycd VARCHAR2(10);
    l_tradeplace VARCHAR2(10);
    l_pricetype VARCHAR2(10);
    l_afacctno VARCHAR2(10);
    l_not_tradeplace VARCHAR2(100);
    l_dk VARCHAR2(500);
    l_reforderid VARCHAR2(100);
    l_execqtty NUMBER;
    l_refexecqtty NUMBER;

BEGIN
    plog.setendsection(pkgctx, 'pr_CancelOrderAfterDay');
    l_not_tradeplace := '( ''9999''';
    if pv_exectype ='ALL' then
        l_exectype := '%';
    else
        l_exectype := pv_exectype;
    end if;
     if pv_tradeplace = 'ALL' then
        l_tradeplace := '%';
    else
        l_tradeplace := pv_tradeplace;
    end if;
    if pv_pricetype = 'ALL' then
        l_pricetype := '%';
    ELSE
        IF instr(pv_pricetype,'M') > 0 THEN
          l_pricetype := 'M%';
        ELSE
        l_pricetype := pv_pricetype;
        END IF;
    end if;
    if pv_afacctno = 'ALL' then
        l_afacctno := '%';
    else
        l_afacctno := pv_afacctno;
    end if;
    if pv_custodycd = 'ALL' then
        l_custodycd := '%';
    else
        l_custodycd := pv_custodycd;
    end if;

    --01 Kiem tra xem da het phien Giao dich chua
    --Chi cho phep thuc hien khi da het phien giao dich
    if to_char(sysdate, 'hh24:mi') <= '15:05' then
        --Bao loi chua het gio giao dich, chua den gio giai toa lenh
        p_err_code :='-2';
        return;
    end if;
   --Check phien HO <> 'O,A,P'
    IF instr(pv_tradeplace,'001') > 0 OR instr(pv_tradeplace,'ALL') > 0  THEN
        select trim(sysvalue) into l_CONTROLCODE from ordersys where sysname ='CONTROLCODE';
        if l_CONTROLCODE in ('P','O','A','I') AND instr(pv_tradeplace,'001')>0 then
            --Bao loi dang trong gio giao dich khong duoc phep giai toa
            p_err_code :='-3';
            return;
        ELSE
            IF l_CONTROLCODE in ('P','O','A','I') AND instr(pv_tradeplace,'ALL') > 0 THEN
                l_not_tradeplace:=l_not_tradeplace ||',''001''';
            END IF;
        END if;

    END IF;

    --Check phien HA <> '1'
    IF instr(pv_tradeplace,'002')>0 OR instr(pv_tradeplace,'005')>0 OR instr(pv_tradeplace,'ALL')>0 THEN
        select trim(sysvalue) into l_CONTROLCODE from ordersys_ha where sysname ='CONTROLCODE';
        IF l_CONTROLCODE in ('1') AND (instr(pv_tradeplace,'002')>0 OR instr(pv_tradeplace,'005')>0 ) then
            --Bao loi dang trong gio giao dich khong duoc phep giai toa
            p_err_code :='-4';
            return;
        ELSE
            IF  l_CONTROLCODE in ('1') AND instr(pv_tradeplace,'ALL')>0  THEN
                l_not_tradeplace:=l_not_tradeplace ||', ''002'' '||', ''005'' ';
            END IF;
        end if;
    END IF;
    --02 Thuc hien giai toa lenh

    for rec in (
        /*select od.orderid , od.afacctno, od.exectype
        from odmast od , ood, sbsecurities sb
        where od.orderid = ood.orgorderid and od.codeid = sb.codeid
            AND od.txdate =   getcurrdate
            and od.exectype like l_exectype
            and od.pricetype like l_pricetype
            and sb.tradeplace like l_tradeplace
            and od.afacctno like l_afacctno
            AND ood.custodycd LIKE l_custodycd
            AND instr(l_not_tradeplace,sb.tradeplace) <=0
            and od.exectype in ('NB','NS')
            and od.matchtype <>'P' and timetype <> 'G'
            and od.deltd <> 'Y' and od.remainqtty>0
            and ood.oodstatus in ('N','S')*/
        SELECT MST.ORDERID, MST.AFACCTNO, MST.EXECTYPE
        FROM ODMAST MST,SBSECURITIES SB, CFMAST CF, AFMAST AF
        WHERE cf.custid = af.custid AND mst.afacctno = af.acctno
            AND MST.REMAINQTTY > 0 AND MST.ORSTATUS IN ('1','2','4','8','9')
            AND MST.CODEID = SB.CODEID AND SB.TRADEPLACE IN ('001','002','005')
            AND MST.EXECTYPE NOT IN ('AS', 'AB', 'CS', 'CB')
            AND instr(l_not_tradeplace,sb.tradeplace) <=0
            AND mst.afacctno LIKE l_afacctno
            AND cf.custodycd LIKE l_custodycd
            AND mst.exectype LIKE l_exectype
            AND mst.pricetype LIKE l_pricetype
            AND sb.tradeplace LIKE l_tradeplace

    )
    LOOP

        select remainqtty, execqtty, (case when od.remainqtty < od.orderqtty then '4' when od.remainqtty = od.orderqtty then '5' else od.orstatus end) status,
               af.corebank
               into l_remainqtty, l_execqtty, l_status, v_strcorebank
        from odmast od, afmast af where od.afacctno = af.acctno and od.orderid = rec.orderid;

        BEGIN
            select orderid, remainqtty, execqtty
                   INTO l_reforderid, l_refremainqtty, l_refexecqtty
            from odmast od, afmast af where od.afacctno = af.acctno AND exectype = 'AB' and od.reforderid = rec.orderid;
        EXCEPTION WHEN OTHERS THEN
            l_refremainqtty:=0;
            l_refexecqtty:=0;
            l_reforderid := '';
        END;

        UPDATE ODMAST SET
            PORSTATUS=PORSTATUS||ORSTATUS,
            ORSTATUS=(CASE WHEN REMAINQTTY < ORDERQTTY THEN '4' WHEN REMAINQTTY = ORDERQTTY THEN '5' ELSE ORSTATUS END),
            CANCELQTTY = REMAINQTTY,
            REMAINQTTY=0, ADJUSTQTTY=0,
            MATCHAMT=0, EXPRICE=0,
            EXQTTY=0, REJECTQTTY=0
        WHERE orderid = rec.orderid;

        UPDATE ODMAST SET
            PORSTATUS=PORSTATUS||ORSTATUS,
            ORSTATUS=(CASE WHEN REMAINQTTY < ORDERQTTY THEN '4' WHEN REMAINQTTY = ORDERQTTY THEN '5' ELSE ORSTATUS END),
            CANCELQTTY = REMAINQTTY,
            REMAINQTTY=0, ADJUSTQTTY=0,
            MATCHAMT=0, EXPRICE=0,
            EXQTTY=0, REJECTQTTY=0
        WHERE reforderid = rec.orderid AND exectype IN ('AS','AB');

        --Voi lenh mua tai khaon ngan hang se thuc hien Unhold luon
        IF l_refremainqtty + l_refexecqtty > 0 THEN
            l_remainqtty := l_refremainqtty + l_refexecqtty - l_execqtty;
        ELSE
            l_reforderid := rec.orderid;
        END IF;

        if rec.exectype ='NB' then
            if v_strcorebank ='Y' then
                  BEGIN
                    cspks_odproc.pr_RM_UnholdCancelOD(l_reforderid, l_remainqtty, p_err_code);
                  EXCEPTION WHEN OTHERS THEN
                    plog.error(pkgctx,'Error when gen unhold for cancel order : ' || rec.orderid || ' qtty : ' || l_remainqtty);
                    plog.error(pkgctx, SQLERRM || ' - Dong:' || dbms_utility.format_error_backtrace );
                  END;
             end if;
        end if;
    END LOOP;


    plog.setendsection(pkgctx, 'pr_CancelOrderAfterDay');
    p_err_code :='0';
    RETURN;

EXCEPTION
WHEN OTHERS
THEN
    plog.error (pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'pr_CancelOrderAfterDay');
    p_err_code :='-1';
    RAISE errnums.E_SYSTEM_ERROR;
END pr_CancelOrderAfterDay;


BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_odproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/


-- End of DDL Script for Package Body HOSTMSTRADE.CSPKS_ODPROC
