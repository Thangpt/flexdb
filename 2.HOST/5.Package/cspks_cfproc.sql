CREATE OR REPLACE PACKAGE cspks_cfproc
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

    FUNCTION fn_ApplyTypeToMast(p_err_code in out varchar2)
    RETURN boolean;
    FUNCTION fn_func_getcflimit (v_bankid in varchar2, v_custid in varchar2, v_subtype in varchar2, v_amt in number)
    RETURN NUMBER;
    FUNCTION fn_get_bank_outstanding (v_bankid in varchar2, v_defsubtyp in varchar2)
    return number;
    FUNCTION fn_get_bank_outstandingcf (v_bankid in varchar2,v_custid IN VARCHAR2, v_defsubtyp in varchar2)
    return number;
    FUNCTION fn_getavlcflimit (v_bankid in varchar2, v_custid in varchar2, v_subtype in varchar2) RETURN NUMBER;
    FUNCTION fn_getavlbanklimit (v_bankid in varchar2, v_subtype in varchar2) RETURN NUMBER;
    FUNCTION fn_getavlbanklimitcf (v_bankid in varchar2,v_custid IN VARCHAR2, v_subtype in varchar2) RETURN NUMBER;
    FUNCTION fn_checkNonCustody (v_strCustodycd in varchar2) RETURN NUMBER;
  FUNCTION fn_getavlcflimitDFMR (p_lntype in varchar2, p_afacctno in varchar2) RETURN NUMBER;

END;
/
CREATE OR REPLACE PACKAGE BODY cspks_cfproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

---------------------------------pr_OpenLoanAccount------------------------------------------------
  FUNCTION fn_ApplyTypeToMast(p_err_code in out varchar2)
  RETURN boolean
  IS
  BEGIN
    plog.setendsection(pkgctx, 'fn_ApplyTypeToMast');
    --MSBS-2589
    /*update afmast
    set (trfbuyext,trfbuyrate) = (select trfbuyext,trfbuyrate from aftype where aftype.actype = afmast.actype)
    where exists (select 1 from aftype where aftype.actype = afmast.actype);*/
    
    MERGE INTO afmast 
    USING (select * from aftype ) aftype
    ON (aftype.actype = afmast.actype)
    WHEN MATCHED THEN
      UPDATE SET trfbuyext = aftype.trfbuyext,
      trfbuyrate = aftype.trfbuyrate;


    --Cap nhat he so Margin tuan thu tu loai hinh xuong
    /*begin
        for rec in (
            select mrt.mriratio ,mrt.mrmratio ,mrt.mrlratio,af.acctno
            from afmast af, aftype aft , mrtype mrt
            where af.actype = aft.actype  and aft.mrtype = mrt.actype
            and (af.mriratio <> mrt.mriratio or af.mrmratio <> mrt.mrmratio or af.mrlratio <> mrt.mrlratio)
        )
        loop
            update afmast
            set mriratio = rec.mriratio ,
                mrmratio = rec.mrmratio ,
                mrlratio = rec.mrlratio
            where acctno = rec.acctno;
        end loop;
    end;*/
    
    MERGE INTO afmast
    USING (select mrt.mriratio ,mrt.mrmratio ,mrt.mrlratio,af.acctno
            from afmast af, aftype aft , mrtype mrt
            where af.actype = aft.actype  and aft.mrtype = mrt.actype
            and (af.mriratio <> mrt.mriratio or af.mrmratio <> mrt.mrmratio or af.mrlratio <> mrt.mrlratio)) a
    ON (afmast.acctno = a.acctno)
    WHEN MATCHED THEN
      UPDATE SET mriratio = a.mriratio ,
                mrmratio = a.mrmratio ,
                mrlratio = a.mrlratio;
    

    --Cap nhat he so Margin he thong tu loai hinh xuong
    /*begin
        for rec in (
            select mrt.mrirate ,mrt.mrmrate ,mrt.mrlrate,af.acctno
            from afmast af, aftype aft , mrtype mrt
            where af.actype = aft.actype  and aft.mrtype = mrt.actype
            and (af.mrirate <> mrt.mrirate or af.mrmrate <> mrt.mrmrate or af.mrlrate <> mrt.mrlrate)
        )
        loop
            update afmast
            set mrirate = rec.mrirate ,
                mrmrate = rec.mrmrate ,
                mrlrate = rec.mrlrate
            where acctno = rec.acctno;
        end loop;
    end;*/
    
    MERGE INTO afmast
    USING (select mrt.mrirate ,mrt.mrmrate ,mrt.mrlrate,af.acctno
            from afmast af, aftype aft , mrtype mrt
            where af.actype = aft.actype  and aft.mrtype = mrt.actype
            and (af.mrirate <> mrt.mrirate or af.mrmrate <> mrt.mrmrate or af.mrlrate <> mrt.mrlrate)) a
    ON (afmast.acctno = a.acctno)
    WHEN MATCHED THEN
      UPDATE SET mrirate = a.mrirate ,
                mrmrate = a.mrmrate ,
                mrlrate = a.mrlrate;
    
    plog.setendsection(pkgctx, 'fn_ApplyTypeToMast');
    return true;
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_ApplyTypeToMast');
      RAISE errnums.E_SYSTEM_ERROR;
      return false;
  END fn_ApplyTypeToMast;

FUNCTION fn_get_bank_outstanding (v_bankid in varchar2, v_defsubtyp in varchar2)
return number
is
v_alloutstanding number;
begin
    plog.setbeginsection(pkgctx, 'fn_get_bank_outstanding');
    v_alloutstanding:=0;
    IF v_defsubtyp='ADV' THEN
        --Kiem tra du no UTTB cua toan bo khach hang theo du no bank
        select nvl(sum(amt),0) into v_alloutstanding
        from adsource mst, adtype typ
        where mst.adtype=typ.actype  and typ.rrtype = 'B' and typ.custbank=v_bankid
        and mst.deltd <> 'Y' AND mst.STATUS ='N';

        plog.setendsection(pkgctx, 'fn_get_bank_outstanding');
        return v_alloutstanding;
    end if;

    IF v_defsubtyp='DFMR' THEN
        --Kiem tra du no DF cua toan bo khach hang theo du no bank
        select nvl(sum(prinnml + prinovd),0) amt  into v_alloutstanding
                from lnmast ln
                where rrtype = 'B'
                and custbank=v_bankid
                and prinnml + prinovd>0;
        plog.setendsection(pkgctx, 'fn_get_bank_outstanding');
        return v_alloutstanding;
    end if;

    plog.setendsection(pkgctx, 'fn_get_bank_outstanding');
RETURN 0;
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_get_bank_outstanding');
   return 0;
end fn_get_bank_outstanding;

FUNCTION fn_get_bank_outstandingcf (v_bankid in varchar2,v_custid IN VARCHAR2 ,v_defsubtyp in varchar2)
return number
is
v_alloutstanding number;
begin
    plog.setbeginsection(pkgctx, 'fn_get_bank_outstandingcf');
    v_alloutstanding:=0;
    IF v_defsubtyp='ADV' THEN
        --Kiem tra du no UTTB cua toan bo khach hang theo du no bank
        select nvl(sum(amt),0) into v_alloutstanding
        from adsource mst,afmast af, cfmast cf
        where  mst.rrtype = 'B' and mst.custbank=v_bankid
        and mst.deltd <> 'Y' AND mst.STATUS ='N'
        AND mst.acctno = af.acctno AND af.custid = cf.custid
        AND cf.custid = v_custid;
        plog.setendsection(pkgctx, 'fn_get_bank_outstandingcf');
        return v_alloutstanding;
    end if;

    plog.setendsection(pkgctx, 'fn_get_bank_outstandingcf');
RETURN 0;
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_get_bank_outstandingcf');
   return 0;
end fn_get_bank_outstandingcf;


FUNCTION fn_func_getcflimit (v_bankid in varchar2, v_custid in varchar2, v_subtype in varchar2, v_amt in number) RETURN NUMBER IS
    v_count         NUMBER;
    v_allmaxlimit   NUMBER;
    v_avllimit      NUMBER;
    v_outstanding   NUMBER;
    v_alloutstanding    NUMBER;
    v_checktyp      CHAR(1);
    v_defsubtyp     VARCHAR2(4);
    v_return        NUMBER;
BEGIN
    plog.setbeginsection(pkgctx, 'fn_func_getcflimit');
    v_outstanding:=0;
    v_alloutstanding:=0;
    v_allmaxlimit:=0;
    if v_bankid is null or length(v_bankid)<=0 OR  v_bankid ='AUTO' then
        plog.setendsection(pkgctx, 'fn_func_getcflimit');
        return 0;
    end if;
    plog.info(pkgctx, 'Input Param: fn_func_getcflimit(' || v_bankid || ',' || v_custid || ',' || v_subtype || ',' || v_amt || ')');
    --Lay han muc khach hang: Uu tien quy dinh nghiep vu truoc roi moi set den All
    SELECT COUNT(LMAMT) INTO v_count
    FROM CFLIMITEXT WHERE BANKID=v_bankid AND CUSTID=v_custid AND STATUS='A';
    IF v_count>0 THEN
        --Kiem tra neu khach hang co quy dinh rieng
        SELECT LMAMT, LMCHKTYP, LMSUBTYPE INTO v_avllimit, v_checktyp, v_defsubtyp
        FROM (SELECT LMAMT, LMCHKTYP, LMSUBTYPE, DECODE(LMSUBTYPE,v_subtype,0,1) PRIORITYORD
        FROM CFLIMITEXT WHERE BANKID=v_bankid AND CUSTID=v_custid AND STATUS='A' AND (LMSUBTYPE='ALL' OR LMSUBTYPE=v_subtype)
        ORDER BY DECODE(LMSUBTYPE,v_subtype,0,1)) WHERE ROWNUM=1;
    ELSE
        --Neu bank khong quy dinh thi khong can kiem tr
        SELECT COUNT(LMAMT) INTO v_count
        FROM CFLIMIT WHERE BANKID=v_bankid AND STATUS='A' AND (LMSUBTYPE=v_subtype OR LMSUBTYPE='ALL');
        IF v_count>0 THEN
            --Theo quydinh chung cua bank
            SELECT LMAMT, LMCHKTYP, LMSUBTYPE INTO v_avllimit, v_checktyp, v_defsubtyp
            FROM (SELECT LMAMT, LMCHKTYP, LMSUBTYPE, DECODE(LMSUBTYPE,v_subtype,0,1) PRIORITYORD
            FROM CFLIMIT WHERE BANKID=v_bankid AND STATUS='A' AND (LMSUBTYPE='ALL' OR LMSUBTYPE=v_subtype)
            ORDER BY DECODE(LMSUBTYPE,v_subtype,0,1)) WHERE ROWNUM=1;
        ELSE
            --Khong kiem tra
            plog.setendsection(pkgctx, 'fn_func_getcflimit');
            RETURN -100424;
        END IF;
    END IF;


    plog.debug(pkgctx, 'v_defsubtyp:' || v_defsubtyp);
    --Lay du no cua khach hang theo ngan hang
    IF v_defsubtyp='ADV' THEN -- UTTB
       /* BEGIN
            --Kiem tra du no UTTB cua khach hang
            SELECT NVL(SUM(AMT),0) INTO v_outstanding
            FROM ADSCHD MST, ADTYPE TYP, AFMAST AF
            WHERE MST.ADTYPE=TYP.ACTYPE AND MST.ACCTNO=AF.ACCTNO
            AND AF.CUSTID=v_custid AND PAIDAMT=0 AND TYP.RRTYPE = 'B' AND TYP.CUSTBANK=v_bankid
            AND MST.DELTD <> 'Y';

            v_alloutstanding:=fn_get_bank_outstanding (v_bankid, v_defsubtyp);

            --Xac dinh han muc tong toi da do ngan hang quy dinh
            SELECT NVL(LMAMTMAX,0) INTO v_allmaxlimit
            FROM (SELECT LMAMTMAX, DECODE(LMSUBTYPE,v_subtype,0,1) PRIORITYORD
                    FROM CFLIMIT WHERE BANKID=v_bankid AND STATUS='A' AND (LMSUBTYPE='ALL' OR LMSUBTYPE=v_subtype)
                    ORDER BY DECODE(LMSUBTYPE,v_subtype,0,1))
            WHERE ROWNUM=1;
        END;

        --Kiem tra han muc hop le
        plog.debug(pkgctx, 'v_avllimit:' || v_avllimit);
        plog.debug(pkgctx, 'v_outstanding:' || v_outstanding);
        plog.debug(pkgctx, 'v_allmaxlimit:' || v_allmaxlimit);
        plog.debug(pkgctx, 'v_alloutstanding:' || v_alloutstanding);
        IF v_avllimit-v_outstanding>=v_amt AND v_allmaxlimit-v_alloutstanding>=v_amt THEN
          v_return := 0;
        ELSIF v_avllimit-v_outstanding<=v_amt then
          v_return := -100423;   -- Ma loi vuot han muc vay cua khach hang
        ELSE
          v_return := -100424;   -- Ma loi vuot han muc cho vay cua ngan hang
        END IF;*/
        v_return:=0;
    END IF;


    --Lay du no cua khach hang theo ngan hang
    IF v_defsubtyp='DFMR' THEN
        BEGIN
            --Kiem tra du no DF cua khach hang
            if v_checktyp='C' then --Check theo han muc hien tai
                begin
                    select nvl(sum(prinnml + prinovd),0) amt into v_outstanding
                    from lnmast ln , afmast af
                    where ln.trfacctno = af.acctno and af.custid=v_custid
                    and rrtype ='B'
                    and custbank=v_bankid;
                exception when others then
                    v_outstanding:=0;
                end;
            else --Check theo han muc dau ngay
                begin
                    select nvl(sum(ln.prinnml + ln.prinovd + nvl(tr.dayrlsamt,0)),0) amt into v_outstanding
                    from lnmast ln , afmast af ,
                    (
                        select tr.acctno, sum(namt) Dayrlsamt
                        from lntran tr, apptx tx
                        where tr.txcd= tx.txcd and tx.apptype ='LN'
                        and tx.field in('PRINNML','PRINOVD')
                        and tx.txtype='D'
                        and tr.deltd <> 'Y'
                        group by tr.acctno
                    ) tr
                    where ln.trfacctno = af.acctno
                    and ln.acctno = tr.acctno(+)
                    and af.custid=v_custid
                    and rrtype ='B'
                    and custbank=v_bankid;
                exception when others then
                    v_outstanding:=0;
                end;
            end if;

            v_alloutstanding:=fn_get_bank_outstanding (v_bankid, v_defsubtyp);

            --Xac dinh han muc tong toi da do ngan hang quy dinh
            select nvl(lmamtmax,0) into v_allmaxlimit
                    from (select lmamtmax, decode(lmsubtype,v_subtype,0,1) priorityord
                            from cflimit where bankid=v_bankid and status='A' and (lmsubtype='ALL' or lmsubtype=v_subtype)
                            order by decode(lmsubtype,v_subtype,0,1)
                         ) where rownum=1;
        END;

        --Kiem tra han muc hop le
        plog.debug(pkgctx, 'v_avllimit:' || v_avllimit);
        plog.debug(pkgctx, 'v_outstanding:' || v_outstanding);
        plog.debug(pkgctx, 'v_allmaxlimit:' || v_allmaxlimit);
        plog.debug(pkgctx, 'v_alloutstanding:' || v_alloutstanding);
        IF v_avllimit-v_outstanding>=v_amt AND v_allmaxlimit-v_alloutstanding>=v_amt THEN
          v_return := 0;
        ELSIF v_avllimit-v_outstanding<=v_amt then
          v_return := -100423;   -- Ma loi vuot han muc vay cua khach hang
        ELSE
          v_return := -100424;   -- Ma loi vuot han muc cho vay cua ngan hang
        END IF;
    END IF;



    plog.setendsection(pkgctx, 'fn_func_getcflimit');

    RETURN v_return;
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_func_getcflimit');
   return errnums.C_SYSTEM_ERROR;
END;



FUNCTION fn_getavlcflimit (v_bankid in varchar2, v_custid in varchar2, v_subtype in varchar2) RETURN NUMBER IS
    v_count         NUMBER;
    v_allmaxlimit   NUMBER;
    v_avllimit      NUMBER;
    v_outstanding   NUMBER;
    v_alloutstanding    NUMBER;
    v_checktyp      CHAR(1);
    v_defsubtyp     VARCHAR2(4);
    v_return        NUMBER;
BEGIN
    plog.setbeginsection(pkgctx, 'fn_getavlcflimit');
    v_outstanding:=0;
    v_alloutstanding:=0;
    v_allmaxlimit:=0;
    plog.info(pkgctx, 'Input Param: fn_getavlcflimit(' || v_bankid || ',' || v_custid || ',' || v_subtype || ')');
    --Lay han muc khach hang: Uu tien quy dinh nghiep vu truoc roi moi set den All
    SELECT COUNT(LMAMT) INTO v_count
    FROM CFLIMIT WHERE BANKID=v_bankid AND STATUS='A' AND (LMSUBTYPE=v_subtype OR LMSUBTYPE='ALL');
    if v_count > 0 then
        select min(nvl(b.lmamt, a.lmamt)) lmamt, min(nvl(b.lmchktyp,a.lmchktyp)) lmchktyp, min(nvl(b.LMSUBTYPE,a.LMSUBTYPE)) LMSUBTYPE
                INTO v_avllimit, v_checktyp, v_defsubtyp
          from cflimit a, (select bankid, LMSUBTYPE, LMTYP, lmamt, lmchktyp
                            from cflimitext
                            where custid = v_custid) b
          where a.bankid = b.bankid(+) and a.LMTYP ='LN'
                and a.LMSUBTYPE = b.LMSUBTYPE(+) and a.LMTYP = b.LMTYP(+) and a.bankid = v_bankid
                AND (a.LMSUBTYPE=v_subtype OR a.LMSUBTYPE='ALL')
          group by a.bankid;
    else
        plog.setendsection(pkgctx, 'fn_getavlcflimit');
        return 0;
    end if;

    plog.debug(pkgctx, 'v_defsubtyp:' || v_defsubtyp);
    --Lay du no cua khach hang theo ngan hang
    IF v_defsubtyp='ADV' THEN -- UTTB
        BEGIN
            --Kiem tra du no UTTB cua khach hang
            SELECT NVL(SUM(AMT),0) INTO v_outstanding
            FROM ADSCHD MST, ADTYPE TYP, AFMAST AF
            WHERE MST.ADTYPE=TYP.ACTYPE AND MST.ACCTNO=AF.ACCTNO
            AND AF.CUSTID=v_custid AND PAIDAMT=0 AND TYP.RRTYPE = 'B' AND TYP.CUSTBANK=v_bankid
            AND MST.DELTD <> 'Y';

            v_alloutstanding:=fn_get_bank_outstanding (v_bankid, v_defsubtyp);

            --Xac dinh han muc tong toi da do ngan hang quy dinh
            SELECT NVL(LMAMTMAX,0) INTO v_allmaxlimit
            FROM (SELECT LMAMTMAX, DECODE(LMSUBTYPE,v_subtype,0,1) PRIORITYORD
                    FROM CFLIMIT WHERE BANKID=v_bankid AND STATUS='A' AND (LMSUBTYPE='ALL' OR LMSUBTYPE=v_subtype)
                    ORDER BY DECODE(LMSUBTYPE,v_subtype,0,1))
            WHERE ROWNUM=1;
        END;

        --Kiem tra han muc hop le
        plog.debug(pkgctx, 'v_avllimit:' || v_avllimit);
        plog.debug(pkgctx, 'v_outstanding:' || v_outstanding);
        plog.debug(pkgctx, 'v_allmaxlimit:' || v_allmaxlimit);
        plog.debug(pkgctx, 'v_alloutstanding:' || v_alloutstanding);

        plog.setendsection(pkgctx, 'fn_getavlcflimit');
        return least(v_avllimit-v_outstanding,v_allmaxlimit-v_alloutstanding);
    END IF;


    --Lay du no cua khach hang theo ngan hang
    IF v_defsubtyp='DFMR' THEN -- CL + Margin
        BEGIN
            --Kiem tra du no DF cua khach hang
            if v_checktyp='C' then --Check theo han muc hien tai
                begin
                    select nvl(sum(prinnml + prinovd),0) amt into v_outstanding
                    from lnmast ln , afmast af
                    where ln.trfacctno = af.acctno and af.custid=v_custid
                    and rrtype ='B'
                    and custbank=v_bankid;
                exception when others then
                    v_outstanding:=0;
                end;
            else --Check theo han muc dau ngay
                begin
                    select nvl(sum(ln.prinnml + ln.prinovd + nvl(tr.dayrlsamt,0)),0) amt into v_outstanding
                    from lnmast ln , afmast af ,
                    (
                        select tr.acctno, sum(namt) Dayrlsamt
                        from lntran tr, apptx tx
                        where tr.txcd= tx.txcd and tx.apptype ='LN'
                        and tx.field in('PRINNML','PRINOVD')
                        and tx.txtype='D'
                        and tr.deltd <> 'Y'
                        group by tr.acctno
                    ) tr
                    where ln.trfacctno = af.acctno
                    and ln.acctno = tr.acctno(+)
                    and af.custid=v_custid
                    and rrtype ='B'
                    and custbank=v_bankid;
                exception when others then
                    v_outstanding:=0;
                end;
            end if;

            v_alloutstanding:=fn_get_bank_outstanding (v_bankid, v_defsubtyp);

            --Xac dinh han muc tong toi da do ngan hang quy dinh
            select nvl(lmamtmax,0) into v_allmaxlimit
                    from (select lmamtmax, decode(lmsubtype,v_subtype,0,1) priorityord
                            from cflimit where bankid=v_bankid and status='A' and (lmsubtype='ALL' or lmsubtype=v_subtype)
                            order by decode(lmsubtype,v_subtype,0,1)
                         ) where rownum=1;
        END;

        --Kiem tra han muc hop le
        plog.debug(pkgctx, 'v_avllimit:' || v_avllimit);
        plog.debug(pkgctx, 'v_outstanding:' || v_outstanding);
        plog.debug(pkgctx, 'v_allmaxlimit:' || v_allmaxlimit);
        plog.debug(pkgctx, 'v_alloutstanding:' || v_alloutstanding);

        plog.setendsection(pkgctx, 'fn_getavlcflimit');
        return least(v_avllimit-v_outstanding,v_allmaxlimit-v_alloutstanding);
    END IF;



    plog.setendsection(pkgctx, 'fn_getavlcflimit');

    RETURN v_return;
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_getavlcflimit');
   return 0;
END;



FUNCTION fn_getavlcflimitDFMR (p_lntype in varchar2, p_afacctno in varchar2) RETURN NUMBER IS
    l_avlamt number(20,0);
    l_rrtype varchar2(1);
    l_custbank varchar2(100);
    l_custid varchar2(100);
BEGIN
    plog.setbeginsection(pkgctx, 'fn_getavlcflimitDFMR');
    l_avlamt:= 0;
    select custid into l_custid from afmast where acctno = p_afacctno;
    begin
        select rrtype, custbank into l_rrtype, l_custbank from lntype where actype = p_lntype;
    exception when others then
        l_rrtype:= 'X';
        l_custbank:= 'XXXXXXXXXXXX';
    end;
    if l_rrtype = 'B' then
        begin
            l_avlamt:= cspks_cfproc.fn_getavlcflimit(l_custbank, l_custid, 'DFMR');
        exception when others then
            l_avlamt:= 0;
        end;
    end if;
    plog.setendsection(pkgctx, 'fn_getavlcflimitDFMR');
    RETURN l_avlamt;
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_getavlcflimitDFMR');
   return 0;
END;


FUNCTION fn_getavlbanklimit (v_bankid in varchar2, v_subtype in varchar2) RETURN NUMBER IS
    v_allmaxlimit   NUMBER;
    v_alloutstanding    NUMBER;
    v_defsubtyp     VARCHAR2(4);
BEGIN
    plog.setbeginsection(pkgctx, 'fn_getavlbanklimit');
    v_alloutstanding:=0;
    v_allmaxlimit:=0;
    v_defsubtyp:=v_subtype;
    --Lay du no cua khach hang theo ngan hang
    IF v_defsubtyp='ADV' THEN -- UTTB
        BEGIN
            v_alloutstanding:=fn_get_bank_outstanding (v_bankid, v_defsubtyp);

            --Xac dinh han muc tong toi da do ngan hang quy dinh
            SELECT NVL(LMAMTMAX,0) INTO v_allmaxlimit
            FROM (SELECT LMAMTMAX, DECODE(LMSUBTYPE,v_subtype,0,1) PRIORITYORD
                    FROM CFLIMIT WHERE BANKID=v_bankid AND STATUS='A' AND (LMSUBTYPE='ALL' OR LMSUBTYPE=v_subtype)
                    ORDER BY DECODE(LMSUBTYPE,v_subtype,0,1))
            WHERE ROWNUM=1;
        END;

        plog.setendsection(pkgctx, 'fn_getavlbanklimit');
        return v_allmaxlimit-v_alloutstanding;
    END IF;


    --Lay du no cua khach hang theo ngan hang
    IF v_defsubtyp='DFMR' THEN -- CL + Margin
        BEGIN
            v_alloutstanding:=fn_get_bank_outstanding (v_bankid, v_defsubtyp);

            --Xac dinh han muc tong toi da do ngan hang quy dinh
            select nvl(lmamtmax,0) into v_allmaxlimit
                    from (select lmamtmax, decode(lmsubtype,v_subtype,0,1) priorityord
                            from cflimit where bankid=v_bankid and status='A' and (lmsubtype='ALL' or lmsubtype=v_subtype)
                            order by decode(lmsubtype,v_subtype,0,1)
                         ) where rownum=1;
        END;

        plog.setendsection(pkgctx, 'fn_getavlbanklimit');
        return v_allmaxlimit-v_alloutstanding;
    END IF;
    plog.setendsection(pkgctx, 'fn_getavlbanklimit');

    RETURN 0;
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_getavlbanklimit');
   return 0;
END;


FUNCTION fn_getavlbanklimitcf (v_bankid in varchar2,v_custid IN VARCHAR2  ,v_subtype in varchar2) RETURN NUMBER IS
    v_alllmamt   NUMBER;
    v_alloutstanding    NUMBER;
    v_defsubtyp     VARCHAR2(4);

BEGIN
    plog.setbeginsection(pkgctx, 'fn_getavlbanklimitcf');
   -- v_alloutstanding:=0;
    v_defsubtyp:=v_subtype;
    --Lay du no cua khach hang theo ngan hang
    IF v_defsubtyp='ADV' THEN -- UTTB

        BEGIN
      v_alloutstanding := fn_get_bank_outstandingcf (v_bankid,v_custid , v_defsubtyp);
            SELECT NVL(lmamt,0) INTO v_alllmamt
            FROM (SELECT lmamt, DECODE(LMSUBTYPE,v_subtype,0,1) PRIORITYORD
                    FROM CFLIMIT WHERE BANKID=v_bankid AND STATUS='A' AND (LMSUBTYPE='ALL' OR LMSUBTYPE=v_subtype)
                    ORDER BY DECODE(LMSUBTYPE,v_subtype,0,1))
            WHERE ROWNUM=1;
        END;

       return v_alllmamt - v_alloutstanding;
    END IF;


    RETURN 0;
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_getavlbanklimit');
   return 0;
END;


FUNCTION fn_checkNonCustody (v_strCustodycd in varchar2) RETURN NUMBER IS
     /*
     **  Module: Neu khach hang thuoc cong ty return 0, else return -1.
     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  ThanhNM     26-Feb-2012    Created
     ** (c) 2012 by Financial Software Solutions. JSC.
     */
    v_result   NUMBER;
    v_strCusType    varchar2(1);
    v_count    NUMBER;
BEGIN
    v_result:=0;
    v_count:=0;
    v_strCusType:='';
    plog.setbeginsection(pkgctx, 'fn_checkNonCustody');
    --Lay noi luu ky

     select count(1) into  v_count from cfmast  where  custodycd = replace(upper(v_strCustodycd),'.','');
     if v_count>0 then
            select CUSTATCOM into v_strCusType from cfmast  where  custodycd = replace(upper(v_strCustodycd),'.','');
            if v_strCusType ='Y' then
                v_result:=0;
                plog.setendsection(pkgctx, 'fn_checkNonCustody');
                return v_result;
            else
                 v_result:=-1;
                 plog.setendsection(pkgctx, 'fn_checkNonCustody');
                 return v_result;
            end if;
     else
        v_result:=-1;
        plog.setendsection(pkgctx, 'fn_checkNonCustody');
        return v_result;
     end if;
     plog.setendsection(pkgctx, 'fn_checkNonCustody');

    RETURN 0;
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_checkNonCustody');
   return 0;
END;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_cfproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
