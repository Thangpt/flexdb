CREATE OR REPLACE PACKAGE txpks_#0105ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0105EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      02/05/2012     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY txpks_#0105ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_prlimit          CONSTANT CHAR(2) := '03';
   c_prinused         CONSTANT CHAR(2) := '04';
   c_syroomused       CONSTANT CHAR(2) := '05';
   c_pramt            CONSTANT CHAR(2) := '10';
   c_prramt           CONSTANT CHAR(2) := '11';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    IF NOT (to_number(p_txmsg.txfields(c_pramt).VALUE) <= to_number(p_txmsg.txfields(c_prinused).VALUE)) THEN
        p_err_code := '-100548';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    IF NOT (to_number(p_txmsg.txfields(c_prramt).VALUE) <= to_number(p_txmsg.txfields(c_prlimit).VALUE)) THEN
        p_err_code := '-100548';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

     IF NOT (to_number(p_txmsg.txfields(c_prramt).VALUE) > 0) THEN
        p_err_code := '-100549';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    -- Kiem tra lai han muc duoc phep dao
    IF NOT (to_number(p_txmsg.txfields(c_prramt).VALUE) <= fn_getavlsymarkedtransferqtty(p_txmsg.txfields(c_codeid).VALUE, to_number(p_txmsg.txfields(c_prramt).VALUE))) THEN
        p_err_code := '-100550';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_codeid      varchar2(6);
    l_amount      number;
    l_result      number;
    l_rolllimit   number;
    l_oldamt      number;
    l_oldprice    number;
    l_newprice    number;
    l_tempamt     number;
    l_tempqtty    number;
    l_tempnewqtty number;
    l_tempavlqtty number;


    CURSOR IncreRecords IS
select se.codeid, nvl(se.avlmarginqtty,0) Si, nvl(pravllimit,0) pravllimit,
                pr.prinused / decode(nvl(pr.prlimit,0),0,1,pr.prlimit) rollratio
        from
            (select semr.codeid, (semr.trade + semr.receiving + semr.odqtty) avlmarginqtty
                from semargininfo semr) se,
            (select pr.codeid, (pr.syroomlimit-pr.syroomused - nvl(afpr.prinused,0)) pravllimit, pr.syroomlimit prlimit,nvl(afpr.prinused,0) prinused
                                    from vw_marginroomsystem pr, (select codeid, sum(prinused) prinused from vw_afpralloc_all where restype = 'S' group by codeid) afpr
                                    where pr.CODEID = afpr.CODEID(+)
                ) pr
        where se.codeid = pr.codeid and pr.codeid <> p_txmsg.txfields('01').value
        and decode(pr.prlimit, 0, 100, round((100*nvl(pr.prinused,0))/pr.prlimit)) < (select to_number(varvalue)
                                                                                                from sysvar
                                                                                                where grname = 'MARGIN' and varname = 'SYROLLLIMIT')
        order by case when nvl(se.avlmarginqtty,0)/decode(nvl(pr.prlimit,0),0,1,pr.prlimit) < 1 then
                    nvl(se.avlmarginqtty,0)/decode(nvl(pr.prlimit,0),0,1,pr.prlimit) else 1 end,
                    pr.prinused / decode(nvl(pr.prlimit,0),0,1,pr.prlimit);

    incre_rec IncreRecords%ROWTYPE;


    CURSOR AfIncreRecords IS
       -- So du cac ma CK cua khach hang
        select se.afacctno , se.codeid,
                least(trade + TOTALRECEIVING - EXECQTTY + TOTALBUYQTTY, nvl(sy_pravlremain,0) + nvl(sy_prinused,0)) AVLQTTY

                from
                (select se.codeid, af.actype, af.mriratio, se.afacctno,se.acctno, se.trade , nvl(sts.receiving,0) receiving,nvl(sts.t0receiving,0) t0receiving,nvl(sts.totalreceiving,0) totalreceiving,nvl(BUYQTTY,0) BUYQTTY,nvl(TOTALBUYQTTY,0) TOTALBUYQTTY,nvl(od.EXECQTTY,0) EXECQTTY, nvl(STS.MAMT,0) mamt, nvl(afpr.sy_prinused,0) sy_prinused
                    from semast se inner join afmast af on se.afacctno =af.acctno
                    left join
                    (select sum(BUYQTTY) BUYQTTY,sum(TOTALBUYQTTY) TOTALBUYQTTY, sum(EXECQTTY) EXECQTTY , AFACCTNO, CODEID
                            from (
                                SELECT (case when od.exectype IN ('NB','BC')
                                            then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                                    + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                            else 0 end) BUYQTTY,
                                            (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                        (case when od.exectype IN ('NS','MS') and od.stsstatus <> 'C' then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY,AFACCTNO, CODEID
                                FROM odmast od, afmast af,
                                    (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                                    (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                                   where od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                                   and od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                                   AND od.deltd <> 'Y'
                                   and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                                   AND od.exectype IN ('NS', 'MS','NB','BC')
                                )
                     group by AFACCTNO, CODEID
                     ) OD
                    on OD.afacctno =se.afacctno and OD.codeid =se.codeid
                    left join
                    (SELECT STS.CODEID,STS.AFACCTNO,
                            SUM(CASE WHEN DUETYPE ='RM' THEN AMT-AAMT-FAMT+PAIDAMT+PAIDFEEAMT-AMT*TYP.DEFFEERATE/100 ELSE 0 END) MAMT,
                            SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) RECEIVING,
                            SUM(CASE WHEN DUETYPE ='RS' AND (nvl(sts_trf.islatetransfer,0) = 0 or sts_trf.trfbuydt = TO_DATE(sy.VARVALUE,'DD/MM/RRRR')) AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) T0RECEIVING,
                            SUM(CASE WHEN DUETYPE ='RS' AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) TOTALRECEIVING
                        FROM STSCHD STS, ODMAST OD, ODTYPE TYP,
                        (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer, trfbuydt from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                        sysvar sy
                        WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
                            and sy.grname = 'SYSTEM' and sy.varname = 'CURRDATE'
                            AND STS.DELTD <>'Y' AND STS.ORGORDERID=OD.ORDERID AND OD.ACTYPE =TYP.ACTYPE
                            and od.orderid = sts_trf.orgorderid(+)
                            GROUP BY STS.AFACCTNO,STS.CODEID
                     ) sts
                    on sts.afacctno =se.afacctno and sts.codeid=se.codeid
                    left join
                    (
                        select afacctno, codeid,
                            nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                        from vw_afpralloc_all
                        group by afacctno, codeid
                    ) afpr  on afpr.afacctno =se.afacctno and afpr.codeid=se.codeid
                ) se,
                afserisk rsk1,
                securities_info sb,
                (
                    select pr.codeid,
                        greatest(max(pr.syroomlimit) - max(pr.syroomused) - nvl(sum(case when restype = 'S' then nvl(afpr.prinused,0) else 0 end),0),0) sy_pravlremain
                    from vw_marginroomsystem pr, vw_afpralloc_all afpr
                    where pr.codeid = afpr.codeid(+)
                    group by pr.codeid
                ) pr
                where se.codeid = pr.codeid
                and se.codeid <> p_txmsg.txfields('01').value
                and se.codeid = incre_rec.codeid
                and (se.actype =rsk1.actype and se.codeid=rsk1.codeid)
                and se.codeid=sb.codeid
                and least(trade + TOTALRECEIVING - EXECQTTY + TOTALBUYQTTY,
            nvl(sy_pravlremain,0) + nvl(sy_prinused,0)) * nvl(rsk1.mrratioloan,0)/100 * least(sb.MARGINPRICE,nvl(rsk1.mrpriceloan,0))  > 0
       order by least(trade + TOTALRECEIVING - EXECQTTY + TOTALBUYQTTY, nvl(sy_pravlremain,0) + nvl(sy_prinused,0)) desc;


afincre_rec AfIncreRecords%ROWTYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_codeid := p_txmsg.txfields(c_codeid).VALUE;
    l_amount := to_number(p_txmsg.txfields(c_prramt).VALUE);
    l_result := 0;
    l_oldamt    := 0;
    l_tempqtty  := 0;
    l_oldprice  := 0;
    l_newprice  := 0;
    l_tempnewqtty  := 0;
    l_tempavlqtty  := 0;
    select to_number(varvalue) into l_rolllimit
    from sysvar
    where grname = 'MARGIN' and varname = 'SYROLLLIMIT';

    if p_txmsg.deltd <> 'Y' then


        OPEN IncreRecords;
        loop
            FETCH IncreRecords INTO incre_rec;
            EXIT WHEN IncreRecords%NOTFOUND;
            -- Theo thu tu chon ma chung khoan co nguon kha dung la CAO NHAT.

            begin
                OPEN AfIncreRecords;
                loop
                    FETCH AfIncreRecords INTO afincre_rec;
                    EXIT WHEN AfIncreRecords%NOTFOUND;
                    -- Voi theo tung ma chung khoan chon duoc. Chon cac tieu khoan phu hop. Chuyen nguon tu ma chung khoan can chuyen sang ma tuong ung.

                    begin
                        begin
                            select round((nvl(rsk.mrratioloan,0)/100)*least(sei.marginprice, rsk.mrpriceloan)) into l_oldprice
                            from afmast af, afserisk rsk, securities_info sei
                            where af.acctno = afincre_rec.afacctno
                                       and af.actype = rsk.actype
                                       and rsk.codeid = sei.codeid
                                       and rsk.codeid = l_codeid;
                        exception when others then
                            l_oldprice:=0;
                        end;
                        begin
                            select round((nvl(rsk.mrratioloan,0)/100)*least(sei.marginprice, rsk.mrpriceloan)) into l_newprice
                            from afmast af, afserisk rsk, securities_info sei
                            where af.acctno = afincre_rec.afacctno
                                and af.actype = rsk.actype
                                and rsk.codeid = sei.codeid
                                and rsk.codeid = afincre_rec.codeid;
                        exception when others then
                            l_newprice:=0;
                        end;
                        if l_oldprice * l_newprice > 0 then
                             -- Danh day M hay T
                             for alloctyp_rec in
                             (
                                select afp.alloctyp, sum(afp.prinused)*l_oldprice usedamt
                                         from vw_afpralloc_all afp
                                         where afp.afacctno = afincre_rec.afacctno
                                              and afp.codeid = l_codeid and restype = 'S'
                                         group by afp.alloctyp
                             )
                             loop

                                    select sum(afp.prinused)*l_oldprice into l_tempamt
                                    from vw_afpralloc_all afp
                                    where afp.afacctno = afincre_rec.afacctno
                                          and afp.codeid = l_codeid and restype = 'S'
                                    group by afp.afacctno, afp.codeid;

                                    select least(floor(((pr.syroomlimit*l_rolllimit)/100)-(nvl(pru.usedqtty, 0)+pr.syroomused))*l_newprice,l_tempamt, greatest(afincre_rec.avlqtty-nvl(pra.usedqtty, 0),0)*l_newprice)
                                        into l_oldamt
                                    from vw_marginroomsystem pr,
                                         (select codeid, sum(prinused) usedqtty from vw_afpralloc_all where restype = 'S' group by codeid) pru,
                                         (select codeid, sum(prinused) usedqtty from vw_afpralloc_all where afacctno = afincre_rec.afacctno and restype = 'S' group by codeid) pra
                                    where pr.codeid = afincre_rec.codeid
                                          and pr.codeid = pru.codeid(+)
                                          and pr.codeid = pra.codeid(+);

                                    l_tempqtty := floor(l_oldamt/l_oldprice);
                                    l_tempnewqtty := ceil(l_oldamt/l_newprice);

                                    if l_result+l_tempqtty > l_amount then
                                        l_tempqtty := l_amount - l_result;
                                        l_tempnewqtty := ceil((l_tempqtty*l_oldprice)/l_newprice);
                                    end if;

                                    if l_tempqtty > 0 and l_tempnewqtty > 0 then
                                        insert into afpralloc (AUTOID, AFACCTNO, PRINUSED, CODEID, ALLOCTYP, ORGORDERID, TXDATE, TXNUM,RESTYPE)
                                        values (seq_afpralloc.nextval, afincre_rec.afacctno, l_tempqtty*(-1), l_codeid, alloctyp_rec.alloctyp, '', TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), p_txmsg.txnum,'S');
                                        insert into afpralloc (AUTOID, AFACCTNO, PRINUSED, CODEID, ALLOCTYP, ORGORDERID, TXDATE, TXNUM,RESTYPE)
                                        values (seq_afpralloc.nextval, afincre_rec.afacctno, l_tempnewqtty, afincre_rec.codeid, alloctyp_rec.alloctyp, '', TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), p_txmsg.txnum,'S');

                                        l_result := l_result+l_tempqtty;
                                        l_tempavlqtty := l_tempavlqtty - l_tempnewqtty;
                                        plog.error('EXE:'||'afincre_rec.afacctno:'||afincre_rec.afacctno||'.Qtty'||l_tempqtty);
                                    end if;

                                    exit when l_result >= l_amount;
                            end loop;
                        end if;
                     end;
                    exit when l_result >= l_amount;
                end loop;
                close AfIncreRecords;

                exit when l_result >= l_amount;
            end;
        end loop;
        close IncreRecords;
    ELSE -- Reversal: Giao dich khong duoc xoa
        -- DO nothing
        null;
    end if;
    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('TXPKS_#0105EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0105EX;
/

