CREATE OR REPLACE PACKAGE cspks_saproc
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

  FUNCTION fn_BackupSMSData(p_err_code out varchar2)
RETURN NUMBER;
  FUNCTION fn_ApplySystemParam(p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_SBS_AutoGen4SpecialAccount(p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_SBS_AutoGenAdvanceLine(p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_apply_crintacr_schedule (p_err_code out varchar2) return number;
END;
/

CREATE OR REPLACE PACKAGE BODY cspks_saproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

 ---------------------------------fn_ApplySystemParam------------------------------------------------
FUNCTION fn_ApplySystemParam(p_err_code out varchar2)
RETURN NUMBER
IS
l_lngErrCode    number(20,0);
v_nextdate varchar2(20);
v_currdate varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_ApplySystemParam');
    plog.debug (pkgctx, '<<BEGIN OF fn_ApplySystemParam');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_nextdate:=cspks_system.fn_get_sysvar ('SYSTEM', 'NEXTDATE');
    v_currdate:=cspks_system.fn_get_sysvar ('SYSTEM', 'CURRDATE');
    --Luu cac thong tin Margin chung khoan gan theo loai hinh cu
    INSERT INTO afseriskhist (CODEID,ACTYPE,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,EXPDATE,BACKUPDT,ISMARGINALLOW)
        select CODEID,ACTYPE,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,
            MRPRICELOAN,EXPDATE,to_char(sysdate,'DD/MM/YYYY:HH:MI:SS'),ISMARGINALLOW
        FROM afserisk;
    --Xoa cac thong tin Margin chung khoan gan theo loai hinh cu
    DELETE FROM AFSERISK;


    --Luu cac thong tin Margin chung khoan gan theo loai hinh cu
    INSERT INTO afmrseriskhist (CODEID,ACTYPE,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,EXPDATE,BACKUPDT,ISMARGINALLOW)
        select CODEID,ACTYPE,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,
            MRPRICELOAN,EXPDATE,to_char(sysdate,'DD/MM/YYYY:HH:MI:SS'),ISMARGINALLOW
        FROM AFMRSERISK;
    --Xoa cac thong tin Margin chung khoan gan theo loai hinh cu
    DELETE FROM AFMRSERISK;

    --Lay ngay hieu luc lon nhat nho hon ngay hien tai
    --Luu cac basket chung khoan het hieu luc
    for rec in
    (
        select actype, max(effdate) effdate
        from lnsebasket WHERE EFFDATE <= TO_DATE(v_currdate,systemnums.c_date_format)
        group by actype
        having count(1) > 1
    )
    loop
        INSERT INTO lnsebaskethist (autoid,BASKETID,actype,effdate,expdate,BACKUPDT)
            select autoid,BASKETID,actype,effdate,expdate,to_char(sysdate,'DD/MM/YYYY:HH:MI:SS')
            from lnsebasket WHERE EFFDATE < rec.effdate and actype = rec.actype;
        --Xoa cac basket chung khoan da het hieu luc.
        DELETE FROM LNSEBASKET WHERE EFFDATE < rec.effdate and actype = rec.actype;
    end loop;

    --Dua cac tham so Margin chung khoan vao ap dung cho cac loai hinh
    for rec in
    (
        SELECT ACTYPE, MAX(AUTOID) AUTOID
            FROM (  SELECT * FROM LNSEBASKET
                    WHERE EFFDATE <= TO_DATE(v_currdate,systemnums.c_date_format)
                    ORDER BY AUTOID DESC
                    ) GROUP BY ACTYPE
    )
    loop
        --1. Cap nhat thong tin Margin cac chung khoan theo loai hinh
        INSERT INTO afserisk (CODEID,ACTYPE,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,ISMARGINALLOW)
               SELECT distinct SB.CODEID,AFT.ACTYPE,
               LEAST(SEC.MRRATIORATE,RATE.MRRATIORATE) MRRATIORATE,
               LEAST(SEC.MRRATIOLOAN,RATE.MRRATIOLOAN) MRRATIOLOAN,
               LEAST(SEC.MRPRICERATE,RSK.MRPRICERATE) MRPRICERATE,
               LEAST(SEC.MRPRICELOAN,RSK.MRPRICELOAN) MRPRICELOAN,ISMARGINALLOW
               FROM LNSEBASKET LNB, SECBASKET SEC, SECURITIES_INFO SB,
                    SECURITIES_RISK RSK, SECURITIES_RATE RATE, AFTYPE AFT, LNTYPE LNT
               WHERE RSK.CODEID=RATE.CODEID AND RATE.FROMPRICE<=SB.FLOORPRICE
               AND RATE.TOPRICE>SB.FLOORPRICE AND LNB.AUTOID= rec.AUTOID
               AND LNB.BASKETID=SEC.BASKETID AND TRIM(SEC.SYMBOL)=TRIM(SB.SYMBOL)
               AND SB.CODEID=RSK.CODEID and LNB.actype = lnt.actype and aft.lntype = lnt.actype;



        INSERT INTO afmrserisk (CODEID,ACTYPE,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,ISMARGINALLOW)
            select * from (
            SELECT distinct SB.CODEID,AFT.ACTYPE,
               LEAST(SEC.MRRATIORATE,RATE.MRRATIORATE) MRRATIORATE,
               LEAST(SEC.MRRATIOLOAN,RATE.MRRATIOLOAN) MRRATIOLOAN,
               LEAST(SEC.MRPRICERATE,RSK.MRPRICERATE) MRPRICERATE,
               LEAST(SEC.MRPRICELOAN,RSK.MRPRICELOAN) MRPRICELOAN,ISMARGINALLOW
               FROM LNSEBASKET LNB, SECBASKET SEC, SECURITIES_INFO SB,
                    SECURITIES_RISK RSK, SECURITIES_RATE RATE, AFTYPE AFT, LNTYPE LNT
               WHERE RSK.CODEID=RATE.CODEID AND RATE.FROMPRICE<=SB.FLOORPRICE
               AND RATE.TOPRICE>SB.FLOORPRICE AND LNB.AUTOID= rec.AUTOID
               AND LNB.BASKETID=SEC.BASKETID AND TRIM(SEC.SYMBOL)=TRIM(SB.SYMBOL)
               AND SB.CODEID=RSK.CODEID and LNB.actype = lnt.actype and aft.lntype = lnt.actype
               and lnt.chksysctrl = 'Y' and rsk.ismarginallow = 'Y'

            union all

            SELECT distinct SB.CODEID,AFT.ACTYPE,
               LEAST(SEC.MRRATIORATE,RATE.MRRATIORATE) MRRATIORATE,
               LEAST(SEC.MRRATIOLOAN,RATE.MRRATIOLOAN) MRRATIOLOAN,
               LEAST(SEC.MRPRICERATE,RSK.MRPRICERATE) MRPRICERATE,
               LEAST(SEC.MRPRICELOAN,RSK.MRPRICELOAN) MRPRICELOAN,ISMARGINALLOW
               FROM LNSEBASKET LNB, SECBASKET SEC, SECURITIES_INFO SB,
                    SECURITIES_RISK RSK, SECURITIES_RATE RATE, AFTYPE AFT, AFIDTYPE AFI, LNTYPE LNT
               WHERE RSK.CODEID=RATE.CODEID AND RATE.FROMPRICE<=SB.FLOORPRICE
               AND RATE.TOPRICE>SB.FLOORPRICE AND LNB.AUTOID= rec.AUTOID
               AND LNB.BASKETID=SEC.BASKETID AND TRIM(SEC.SYMBOL)=TRIM(SB.SYMBOL)
               AND SB.CODEID=RSK.CODEID and LNB.actype = lnt.actype and aft.actype = afi.aftype
               and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype
               and lnt.chksysctrl = 'Y' and rsk.ismarginallow = 'Y');
    end loop;

    insert into afserisk (codeid,actype,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,expdate,ismarginallow)
        select codeid,actype,0 mrratiorate,0 mrratioloan,0 mrpricerate,0 mrpriceloan,null expdate,'N' ismarginallow
        from afmrserisk rsk2
        where not exists (select 1 from afserisk rsk where rsk.actype = rsk2.actype and rsk.codeid = rsk2.codeid);


    insert into afmrserisk (codeid,actype,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,expdate,ismarginallow)
        select codeid,actype,0 mrratiorate,0 mrratioloan,0 mrpricerate,0 mrpriceloan,null expdate,'N' ismarginallow
        from afserisk rsk
        where not exists (select 1 from afmrserisk rsk2 where rsk.actype = rsk2.actype and rsk.codeid = rsk2.codeid);

    --Cap nhat giai toa CK khi chung khoan margin rut khoi ro.
    for rec in
    (
        select * from
            (select afacctno, codeid, alloctyp, sum(prinused) prinused from vw_afpralloc_all where restype = 'M'
            having sum(prinused) <> 0
            group by afacctno, codeid, alloctyp) afpr
        where not exists (select 1 from afmast af, afmrserisk rsk where af.actype = rsk.actype and af.acctno = afpr.afacctno and rsk.codeid = afpr.codeid and rsk.mrratiorate * rsk.mrratioloan > 0)
    )
    loop
        INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
        VALUES(seq_afpralloc.nextval,rec.afacctno,-rec.prinused,rec.codeid,rec.alloctyp,null,to_date(v_currdate,systemnums.c_date_format), null, 'M');
    end loop;


    --Cap nhat giai toa CK khi chung khoan margin rut khoi ro.
    for rec in
    (
        select * from
            (select afacctno, codeid, alloctyp, sum(prinused) prinused from vw_afpralloc_all where restype = 'S'
            having sum(prinused) <> 0
            group by afacctno, codeid, alloctyp) afpr
        where not exists (select 1 from afmast af, afserisk rsk where af.actype = rsk.actype and af.acctno = afpr.afacctno and rsk.codeid = afpr.codeid and rsk.mrratiorate * rsk.mrratioloan > 0)
    )
    loop
        INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
        VALUES(seq_afpralloc.nextval,rec.afacctno,-rec.prinused,rec.codeid,rec.alloctyp,null,to_date(v_currdate,systemnums.c_date_format), null, 'S');
    end loop;

    --Ap lich lai tien gui moi cho he thong.


    plog.debug (pkgctx, '<<END OF fn_ApplySystemParam');
    plog.setendsection (pkgctx, 'fn_ApplySystemParam');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_ApplySystemParam');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_ApplySystemParam;

 ---------------------------------fn_BackupSMSData------------------------------------------------
FUNCTION fn_BackupSMSData(p_err_code out varchar2)
RETURN NUMBER
IS
l_lngErrCode    number(20,0);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_BackupSMSData');
    plog.debug (pkgctx, '<<BEGIN OF fn_BackupSMSData');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    Insert into SMSMARGINCALLHIST (autoid, actype, acctno, email, mobile, address,
            fullname, phone1, desc_status, balance, bamt, odamt,
            advlimit, mrcrlimitmax, mrclamt, mrcrlimit, mrirate,
            mrmrate, mrlrate, marginrate, avlwithdraw, pp,
            avllimit, navaccount, outstanding, addvnd, smsstatus,
            execdate, exectime, calldate, calltime)
            select autoid, actype, acctno, email, mobile, address,
            fullname, phone1, desc_status, balance, bamt, odamt,
            advlimit, mrcrlimitmax, mrclamt, mrcrlimit, mrirate,
            mrmrate, mrlrate, marginrate, avlwithdraw, pp,
            avllimit, navaccount, outstanding, addvnd, smsstatus,
            execdate, exectime, calldate, calltime
            from SMSMARGINPROCESSED
            where to_date(EXECDATE,'DD/MM/YYYY') - (select VARVALUE FROM SYSVAR WHERE GRNAME='DEFINED' and VARNAME= 'EXPSMSDAY')
            >=(select to_date(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' and VARNAME= 'CURRDATE');

    Delete from SMSMARGINPROCESSED
         where to_date(EXECDATE,'DD/MM/YYYY') - (select VARVALUE FROM SYSVAR WHERE GRNAME='DEFINED' and VARNAME= 'EXPSMSDAY')
         >=(select to_date(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' and VARNAME= 'CURRDATE');

    plog.debug (pkgctx, '<<END OF fn_BackupSMSData');
    plog.setendsection (pkgctx, 'fn_BackupSMSData');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_BackupSMSData');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_BackupSMSData;


FUNCTION fn_apply_crintacr_schedule (p_err_code out varchar2) return number
is
    v_nextdate varchar2(20);
    v_currdate varchar2(20);
begin
    plog.setbeginsection (pkgctx, 'fn_apply_crintacr_schedule');
    plog.debug (pkgctx, '<<BEGIN OF fn_apply_crintacr_schedule');
    v_nextdate:=cspks_system.fn_get_sysvar ('SYSTEM', 'NEXTDATE');
    v_currdate:=cspks_system.fn_get_sysvar ('SYSTEM', 'CURRDATE');
    --Neu truoc buoc tinh lai tien gui thi currdate, neu sau buoc lai tien gui thi nextdate
    for rec in (
        select * from iccftypeschd
        where effectivedt <=to_date(v_currdate,'DD/MM/RRRR') and eventcode ='CRINTACR' and deltd <> 'Y'
        order by effectivedt
    )
    loop
        for rec1 in (
            select * from iccftypeschdmap where refid = rec.autoid
        )
        loop
            --Backup su kien lai tien gui
            insert into iccftypedefhist (autoid, modcode, actype, glacctno, eventcode,
               ruletype, monthday, yearday, period, periodday,
               ictype, icflat, icratecd, icrateid, icrate, minval,
               maxval, varrate, iccfstatus, deltd, operand, line,
               flrate, cerate, effectivedt)
            select autoid, modcode, actype, glacctno, eventcode,
               ruletype, monthday, yearday, period, periodday,
               ictype, icflat, icratecd, icrateid, icrate, minval,
               maxval, varrate, iccfstatus, deltd, operand, line,
               flrate, cerate, effectivedt
            from iccftypedef where actype =rec1.actype and eventcode ='CRINTACR' and modcode ='CI';
            delete from iccftypedef where actype =rec1.actype and eventcode ='CRINTACR' and modcode ='CI';

            insert into iccftierhist (autoid, modcode, actype, eventcode, tiername, framt,
               toamt, delta, iccfstatus, deltd)
            select autoid, modcode, actype, eventcode, tiername, framt,
               toamt, delta, iccfstatus, deltd
            from iccftier where actype =rec1.actype and eventcode ='CRINTACR'  and modcode ='CI';
            delete from iccftier where actype =rec1.actype and eventcode ='CRINTACR'  and modcode ='CI';

            -- Ap moi su kien lai tien gui
            insert into iccftypedef (autoid, modcode, actype, glacctno, eventcode,
               ruletype, monthday, yearday, period, periodday,
               ictype, icflat, icratecd, icrateid, icrate, minval,
               maxval, varrate, iccfstatus, deltd, operand, line,
               flrate, cerate, effectivedt )
            select seq_iccftypedef.nextval, 'CI', rec1.actype, glacctno, eventcode,
               ruletype, monthday, yearday, period, periodday,
               ictype, icflat, icratecd, icrateid, icrate, minval,
               maxval, varrate, iccfstatus, deltd, operand, line,
               flrate, cerate, effectivedt
            from iccftypeschd where autoid = rec.autoid;

            insert into iccftier (autoid, modcode, actype, eventcode, tiername, framt,
               toamt, delta, iccfstatus, deltd)
            select seq_iccftier.nextval, 'CI' modcode, rec1.actype actype, eventcode, tiername, framt,
               toamt, delta, iccfstatus, deltd
            from iccftier where actype =rec.actype and eventcode ='CRINTACR'  and modcode ='SA';
        end loop;

        --Backup dong lich da duoc apply vao lich su
        insert into iccftypeschdhist (autoid, modcode, actype, glacctno, eventcode,
             ruletype, monthday, yearday, period, periodday,
             ictype, icflat, icratecd, icrateid, icrate, minval,
             maxval, varrate, iccfstatus, deltd, operand, line,
             flrate, cerate, effectivedt, acname, expireddt)
        select autoid, modcode, actype, glacctno, eventcode,
            ruletype, monthday, yearday, period, periodday,
            ictype, icflat, icratecd, icrateid, icrate, minval,
            maxval, varrate, iccfstatus, deltd, operand, line,
            flrate, cerate, effectivedt, acname, expireddt
        from iccftypeschd where autoid = rec.autoid;
        delete from iccftypeschd where autoid = rec.autoid;

        insert into iccftypeschdmaphist (autoid, refid, actype)
        select autoid, refid, actype from iccftypeschdmap
        where refid = rec.autoid;
        delete from iccftypeschdmap where refid = rec.autoid;

        insert into iccftierhist (autoid, modcode, actype, eventcode, tiername, framt,
           toamt, delta, iccfstatus, deltd)
        select autoid, modcode, actype, eventcode, tiername, framt,
           toamt, delta, iccfstatus, deltd
        from iccftier where actype =rec.actype and eventcode ='CRINTACR'  and modcode ='SA';
        delete from iccftier where actype =rec.actype and eventcode ='CRINTACR'  and modcode ='SA';
    end loop;
    return 0;
    plog.debug (pkgctx, '<<END OF fn_apply_crintacr_schedule');
    plog.setendsection (pkgctx, 'fn_apply_crintacr_schedule');
exception when others then
    p_err_code := errnums.C_SYSTEM_ERROR;
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_apply_crintacr_schedule');
    RAISE errnums.E_SYSTEM_ERROR;
end fn_apply_crintacr_schedule;

 ---------------------------------fn_SBS_AutoGen4SpecialAccount------------------------------------------------
FUNCTION fn_SBS_AutoGen4SpecialAccount(p_err_code out varchar2)
RETURN NUMBER
IS
    l_currdate varchar2(20);
    l_account varchar2(10);
    l_toaccount varchar2(10);
    l_bankid varchar2(50);
    l_bankacctno varchar2(100);
    l_glmast varchar2(100);
    l_refnum varchar2(100);
    l_amount number(20,0);
    l_1141amount number(20,0);
    l_1120amount number(20,0);
    l_rlsamt  number(20,0);
    l_desc varchar2(500);
    l_txdate  varchar2(20);
    l_txnum  varchar2(20);

    l_benefbank varchar2(100);
    l_benefacct varchar2(100);
    l_benefcustname varchar2(100);
    l_beneflicense varchar2(100);
    l_count     number(5);
    l_feecd     varchar2(100);
    l_feeamt number(20,0);
    l_vatamt number(20,0);

    v_forp  varchar2(10);
    v_feeamt number(20,0);
    v_feerate   number(20,4);
    v_feemin    number(20,0);
    v_feemax    number(20,0);
    v_vatrate   number(20,4);

BEGIN
    plog.setbeginsection (pkgctx, 'fn_SBS_AutoGen4SpecialAccount');
    plog.debug (pkgctx, '<<BEGIN OF fn_SBS_AutoGen4SpecialAccount');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_currdate:=cspks_system.fn_get_sysvar ('SYSTEM', 'CURRDATE');
    v_forp:='F';
    v_feeamt:=0;
    v_feerate:=0;
    v_feemin:=0;
    v_feemax:=0;
    v_vatrate:=0;
    --01.Tinh toan so tien giai ngan cho cac tai khoan giai ngan cho deal
    for rec in (
        select acc.ciacctno, (ci.balance-ci.odamt) balance,
                 (af.advanceline) advanceline, (af.t0amt) t0amt, (af.mrcrlimitmax) mrcrlimitmax
             from cimast ci, afmast af,
                 (select distinct ciacctno from dftype where ciacctno is not null) acc
             where acc.ciacctno is not null
             and acc.ciacctno= ci.acctno
             and ci.acctno = af.acctno
    )
    loop
        --Giao dich 1141
        l_account:= rec.ciacctno;
        l_bankid:='1';
        SELECT BANKACCTNO,GLACCOUNT into l_bankacctno,l_glmast FROM BANKNOSTRO WHERE shortname='1';
        l_refnum:=l_account;
        --Xac dinh so tien da giai ngan
        begin
            select sum(df.amt) amount into l_1141amount
                         from dfmast df, lnmast ln
                         where df.lnacctno = ln.acctno and ln.ftype='DF'
                         and ln.rlsdate =to_date(l_currdate,systemnums.c_date_format)
                         and df.ciacctno= rec.ciacctno;
        exception when others then
            l_1141amount:=0;
        end;
        l_1141amount :=nvl(l_1141amount,0);
        l_desc :='Nhan chuyen khoan tu ngan hang';
        --Thuc hien giai ngan cho tai khoan theo so giai ngan
        plog.debug (pkgctx, '1141.Nhan chuyen khoan de giai ngan');
        if l_1141amount>0 then
            txpks_auto.pr_ReceiveTransfer(l_account ,l_bankid ,l_bankacctno,l_glmast ,l_refnum ,l_1141amount ,l_desc ,p_err_code  ,l_txdate  ,l_txnum );
            if p_err_code <>  systemnums.C_SUCCESS then
                plog.setendsection (pkgctx, 'fn_SBS_AutoGen4SpecialAccount');
                return errnums.C_SYSTEM_ERROR;
            end if;
        end if;
        plog.debug (pkgctx, '1141.Ket thuc Nhan chuyen khoan de giai ngan');
        --Giao dich 1120
        --Tinh toan so phi dich vu, chuyen sang tai khoan doi ung khac
        begin
            SELECT sum(round(TR.NAMT * df.cisvrfee/100/360 * (to_date(l_currdate,systemnums.c_date_format) - ln.rlsdate),0)) RLSAMT
                into l_1120amount
            from dftran tr, apptx tx, dfmast df, lnmast ln
            where tr.txcd = tx.txcd and tr.acctno = df.acctno and df.lnacctno = ln.acctno and ln.ftype ='DF'
                and tx.field = 'RLSAMT' and tx.apptype = 'DF' and tx.txtype = 'C'
                and tr.namt <> 0
                and df.ciacctno =rec.ciacctno;
        exception when others then
            l_1120amount:=0;
        end;
        l_1120amount :=nvl(l_1120amount,0);
        l_desc:='Chuyen khoan noi bo';
        --Xac dinh so tieu khoan chuyen khoan sang
        begin
            select count(1) into l_count from cfotheracc where ciaccount is not null and afacctno = l_account;
            if l_count>0 then
                select ciaccount
                    into l_toaccount
                from cfotheracc where ciaccount is not null and afacctno = l_account and rownum=1;
                plog.debug (pkgctx, '1120.Chuyen khoan noi bo');
                if l_1120amount>0 then
                    txpks_auto.pr_InternalTransfer(l_account ,l_toaccount  ,l_1120amount ,l_desc ,p_err_code  ,l_txdate  ,l_txnum  );
                    if p_err_code <>  systemnums.C_SUCCESS then
                        plog.setendsection (pkgctx, 'fn_SBS_AutoGen4SpecialAccount');
                        return errnums.C_SYSTEM_ERROR;
                    end if;
                end if;
                plog.debug (pkgctx, '1120.Ket thuc Chuyen khoan noi bo');
            end if;
        end;



        --Giao dich 1101
        --Tinh toan so tien chuyen ra ngoai
        l_amount:= l_1141amount + rec.balance - l_1120amount;
        begin
            select count(1) into l_count from cfotheracc where bankacc is not null and afacctno = l_account;
            if l_count>0 then
                select bankname,bankacc,bankacname,acnidcode,feecd
                    into l_benefbank,l_benefacct,l_benefcustname,l_beneflicense,l_feecd
                from cfotheracc where afacctno = l_account and rownum=1 and type=1;
                if l_feecd is not null then
                    select forp, feeamt,feerate,minval, maxval , vatrate
                        into v_forp, v_feeamt, v_feerate, v_feemin, v_feemax, v_vatrate
                    from feemaster where feecd=l_feecd;
                    if v_forp='F' then
                        l_feeamt:= round(greatest(least(v_feemin,v_feeamt),v_feemax),0);
                        l_vatamt:=round(v_vatrate/100 * l_feeamt,0);
                    elsif v_forp='P' then
                        l_feeamt:= round(greatest(least(v_feemin,v_feerate/100*l_amount),v_feemax),0);
                        l_vatamt:=round(v_vatrate/100 * l_feeamt,0);
                    else
                        l_feeamt :=0;
                        l_vatamt :=0;
                    end if;
                else
                    l_feeamt :=0;
                    l_vatamt :=0;
                end if;
            else
                l_benefbank:='';
                l_benefacct:='';
                l_benefcustname:='';
                l_beneflicense:='';
                l_feeamt :=0;
                l_vatamt :=0;
            end if;
        end;

        l_desc :='Chuyen khoan tien ra ngan hang';
        --Thuc hien chuyen khoan ra ngoai so tien da thu ngan
        plog.debug (pkgctx, '1101.Chuyen khoan tien thu ngan ra ngan hang');
        if l_amount>0 then
            txpks_auto.pr_ExternalTransfer(l_account ,l_bankid ,l_benefbank ,l_benefacct ,l_benefcustname ,l_beneflicense ,l_amount ,l_feeamt ,l_vatamt ,l_desc ,p_err_code  ,l_txdate  ,l_txnum  );
            if p_err_code <>  systemnums.C_SUCCESS then
                plog.setendsection (pkgctx, 'fn_SBS_AutoGen4SpecialAccount');
                return errnums.C_SYSTEM_ERROR;
            end if;
        end if;
        plog.debug (pkgctx, '1101.Ket thuc Chuyen khoan tien thu ngan ra ngan hang');
    end loop;

    plog.debug (pkgctx, '<<END OF fn_SBS_AutoGen4SpecialAccount');
    plog.setendsection (pkgctx, 'fn_SBS_AutoGen4SpecialAccount');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_SBS_AutoGen4SpecialAccount');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_SBS_AutoGen4SpecialAccount;


 ---------------------------------fn_SBS_AutoGenAdvanceLine------------------------------------------------
FUNCTION fn_SBS_AutoGenAdvanceLine(p_err_code out varchar2)
RETURN NUMBER
IS
    l_currdate varchar2(20);
    l_account varchar2(10);
    l_amount number(20,0);
    l_rlsamt  number(20,0);
    l_desc varchar2(500);
    l_txdate  varchar2(20);
    l_txnum  varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_SBS_AutoGenAdvanceLine');
    plog.debug (pkgctx, '<<BEGIN OF fn_SBS_AutoGenAdvanceLine');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_currdate:=cspks_system.fn_get_sysvar ('SYSTEM', 'CURRDATE');
    --01.Tinh toan so tien giai ngan cho cac tai khoan giai ngan cho deal
    for rec in (
        select nvl(amount,0) amount, acc.ciacctno, (ci.balance-ci.odamt) balance,
                 (af.advanceline) advanceline, (af.t0amt) t0amt, (af.mrcrlimitmax) mrcrlimitmax
             from (select sum(amt) amount, ciacctno
                         from dfmast
                         where txdate =to_date(l_currdate,systemnums.c_date_format)
                         group by ciacctno) df,
                  cimast ci, afmast af,
                 (select distinct ciacctno from dftype where ciacctno is not null) acc
             where acc.ciacctno is not null
             and acc.ciacctno= ci.acctno
             and ci.acctno = af.acctno
             and acc.ciacctno=df.ciacctno(+)
    )
    loop
        plog.debug (pkgctx, '1158.Cap bao lanh tu dong cho tai khoan giai ngan');
        l_account:= rec.ciacctno;
        l_rlsamt:=0;
        begin
            select nvl(sum(amt-rlsamt),0) into l_rlsamt from dfmast where ciacctno = rec.ciacctno;
        exception when others then
            l_rlsamt:=0;
        end;
        l_amount:=least(rec.mrcrlimitmax- l_rlsamt,rec.t0amt);
        l_desc:='Cap bao lanh tu dong cho tai khoan giai ngan';
        --Cap han muc ngay hom sau cho tieu khoan

        if l_amount>0 then
            txpks_auto.pr_AllocateGuarantee(l_account ,l_amount ,l_desc ,p_err_code  ,l_txdate  ,l_txnum );
            if p_err_code <>  systemnums.C_SUCCESS then
                plog.setendsection (pkgctx, 'fn_SBS_AutoGenAdvanceLine');
                return errnums.C_SYSTEM_ERROR;
            end if;
        end if;
        plog.debug (pkgctx, '1158.Ket thuc cap bao lanh tu dong cho tai khoan giai ngan');
    end loop;

    plog.debug (pkgctx, '<<END OF fn_SBS_AutoGenAdvanceLine');
    plog.setendsection (pkgctx, 'fn_SBS_AutoGenAdvanceLine');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_SBS_AutoGenAdvanceLine');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_SBS_AutoGenAdvanceLine;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_saproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/

