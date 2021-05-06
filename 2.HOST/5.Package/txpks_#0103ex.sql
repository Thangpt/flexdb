CREATE OR REPLACE PACKAGE txpks_#0103ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0103EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      02/04/2011     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#0103ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_orgorderid       CONSTANT CHAR(2) := '03';
   c_ciacctno         CONSTANT CHAR(2) := '05';
   c_trfamt           CONSTANT CHAR(2) := '11';
   c_cutmtrfday       CONSTANT CHAR(2) := '15';
   c_blockt0amt       CONSTANT CHAR(2) := '16';
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
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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

    IF NOT (to_number(p_txmsg.txfields('10').VALUE) <= to_number(p_txmsg.txfields('04').VALUE)) THEN
        p_err_code := '-100548';
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    IF NOT (to_number(p_txmsg.txfields('11').VALUE) <= to_number(p_txmsg.txfields('03').VALUE)) THEN
        p_err_code := '-100548';
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

     IF NOT (to_number(p_txmsg.txfields('11').VALUE) > 0) THEN
        p_err_code := '-100549';
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    -- Kiem tra lai han muc duoc phep dao
    IF NOT (to_number(p_txmsg.txfields('11').VALUE) <= fn_getavlmarkedtransferqtty(p_txmsg.txfields('01').VALUE, to_number(p_txmsg.txfields('11').VALUE))) THEN
        p_err_code := '-100550';
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;


   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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
      plog.error (pkgctx, SQLERRM);
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
                (select sb.codeid, (semr.trade + semr.receiving + semr.odqtty) avlmarginqtty
                    from semargininfo semr,
                    (select codeid, Max(ismarginallow) ismarginallow from afmrserisk where ismarginallow = 'Y' group by codeid) sb
                    where sb.codeid = semr.codeid (+)) se,
                (select pr.codeid, (pr.roomlimit - nvl(afpr.prinused,0)) pravllimit, pr.roomlimit prlimit,nvl(afpr.prinused,0) prinused
                                        from vw_marginroomsystem pr, (select codeid, sum(prinused) prinused from vw_afpralloc_all where restype = 'M' group by codeid) afpr
                                        where pr.CODEID = afpr.CODEID(+)
                    ) pr
            where se.codeid = pr.codeid and pr.codeid <> p_txmsg.txfields('01').VALUE
            and decode(pr.prlimit, 0, 100, round((100*nvl(pr.prinused,0))/pr.prlimit)) < (select to_number(varvalue)
                                                                                                    from sysvar
                                                                                                    where grname = 'MARGIN' and varname = 'ROLLLIMIT')
            order by case when nvl(se.avlmarginqtty,0)/decode(nvl(pr.prlimit,0),0,1,pr.prlimit) < 1 then
                        nvl(se.avlmarginqtty,0)/decode(nvl(pr.prlimit,0),0,1,pr.prlimit) else 1 end,
                        pr.prinused / decode(nvl(pr.prlimit,0),0,1,pr.prlimit);

    incre_rec IncreRecords%ROWTYPE;


    CURSOR AfIncreRecords IS
       -- So du cac ma CK cua khach hang
       select seb.afacctno, seb.codeid, seb.trade + seb.receiving + nvl(sed.od_qtty,0) avlQtty from
       (select se.afacctno, se.codeid, sum(se.trade) trade, sum(nvl(sts.receiving,0)) receiving
         from semast se, afmast af, aftype aft, mrtype mrt,
         (select codeid,afacctno, (qtty - aqtty) receiving from stschd where txdate <> (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') and duetype = 'RS' and status <> 'C') sts
         where se.afacctno = af.acctno
         and af.actype = aft.actype
         and aft.mrtype = mrt.actype
         and se.afacctno = sts.afacctno (+) and se.codeid = sts.codeid (+)
         and mrt.mrtype = 'T'
         group by se.afacctno, se.codeid) seb,
       (select od.afacctno, od.codeid, sum(case when od.exectype = 'NB' then od.remainqtty else 0 end) - sum(execsellqtty) + sum(execbuyqtty) od_qtty
         from odmast od, afmast af, aftype aft, mrtype mrt,
         (select sts.codeid,sts.afacctno,
                 sum(case when sts.duetype = 'SS' then sts.qtty - decode(sts.status,'C',sts.qtty,sts.aqtty)  - nvl(dfexecqtty,0) else 0 end) execsellqtty,
                 sum(case when sts.duetype = 'RS' then sts.qtty - decode(sts.status,'C',sts.qtty,sts.aqtty) else 0 end) execbuyqtty
             from stschd sts, odmast od,
                            (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
             where sts.txdate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
             and sts.orgorderid = dfex.orderid(+)
             and sts.orgorderid = od.orderid
             and not (od.grporder='Y' and od.matchtype='P')
             and duetype in ('RS','SS') and status <> 'C'
             group by sts.codeid, sts.afacctno) sts
         where od.afacctno = af.acctno
         and af.actype = aft.actype
         and aft.mrtype = mrt.actype
         and od.afacctno = sts.afacctno (+) and od.codeid = sts.codeid (+)
         and mrt.mrtype = 'T'
         group by od.afacctno, od.codeid) sed
       where seb.afacctno = sed.afacctno(+) and seb.codeid = sed.codeid(+) and seb.codeid = incre_rec.codeid
       and seb.trade + seb.receiving + nvl(sed.od_qtty,0) > 0
       order by seb.trade + seb.receiving + nvl(sed.od_qtty,0) desc;

afincre_rec AfIncreRecords%ROWTYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    l_codeid := p_txmsg.txfields('01').VALUE;
    l_amount := to_number(p_txmsg.txfields('11').VALUE);
    l_result := 0;
    l_oldamt    := 0;
    l_tempqtty  := 0;
    l_oldprice  := 0;
    l_newprice  := 0;
    l_tempnewqtty  := 0;
    l_tempavlqtty  := 0;
    select to_number(varvalue) into l_rolllimit
    from sysvar
    where grname = 'MARGIN' and varname = 'ROLLLIMIT';

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
                            select round((least(nvl(rsk.mrratioloan,0),100-af.mriratio)/100)*least(sei.marginrefprice, rsk.mrpriceloan)) into l_oldprice
                            from afmast af, afmrserisk rsk, securities_info sei
                            where af.acctno = afincre_rec.afacctno
                                       and af.actype = rsk.actype
                                       and rsk.codeid = sei.codeid
                                       and rsk.codeid = l_codeid;
                        exception when others then
                            l_oldprice:=0;
                        end;
                        begin
                            select round((least(nvl(rsk.mrratioloan,0),100-af.mriratio)/100)*least(sei.marginrefprice, rsk.mrpriceloan)) into l_newprice
                            from afmast af, afmrserisk rsk, securities_info sei
                            where af.acctno = afincre_rec.afacctno
                                and af.actype = rsk.actype
                                and rsk.codeid = sei.codeid
                                and rsk.codeid = afincre_rec.codeid;
                        exception when others then
                            l_newprice:=0;
                        end;
                        if l_oldprice * l_newprice > 0 then
                             -- Danh day M hay T
                             for alloctyp_rec in (select afp.alloctyp, sum(afp.prinused)*l_oldprice usedamt
                                         from vw_afpralloc_all afp
                                         where afp.afacctno = afincre_rec.afacctno
                                              and afp.codeid = l_codeid and restype = 'M'
                                         group by afp.alloctyp)
                             loop

                                    select sum(afp.prinused)*l_oldprice into l_tempamt
                                    from vw_afpralloc_all afp
                                    where afp.afacctno = afincre_rec.afacctno
                                          and afp.codeid = l_codeid and restype = 'M'
                                    group by afp.afacctno, afp.codeid;

                                    select least(floor(((pr.roomlimit*l_rolllimit)/100)-nvl(pru.usedqtty, 0))*l_newprice,l_tempamt, greatest(afincre_rec.avlqtty-nvl(pra.usedqtty, 0),0)*l_newprice)
                                        into l_oldamt
                                    from vw_marginroomsystem pr,
                                         (select codeid, sum(prinused) usedqtty from vw_afpralloc_all where restype = 'M' group by codeid) pru,
                                         (select codeid, sum(prinused) usedqtty from vw_afpralloc_all where afacctno = afincre_rec.afacctno and restype = 'M' group by codeid) pra
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
                                        values (seq_afpralloc.nextval, afincre_rec.afacctno, l_tempqtty*(-1), l_codeid, alloctyp_rec.alloctyp, '', TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), p_txmsg.txnum,'M');
                                        insert into afpralloc (AUTOID, AFACCTNO, PRINUSED, CODEID, ALLOCTYP, ORGORDERID, TXDATE, TXNUM,RESTYPE)
                                        values (seq_afpralloc.nextval, afincre_rec.afacctno, l_tempnewqtty, afincre_rec.codeid, alloctyp_rec.alloctyp, '', TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), p_txmsg.txnum,'M');

                                        l_result := l_result+l_tempqtty;
                                        l_tempavlqtty := l_tempavlqtty - l_tempnewqtty;
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
      plog.error (pkgctx, dbms_utility.format_error_backtrace);
      plog.error (pkgctx, SQLERRM);
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
         plog.init ('TXPKS_#0103EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0103EX;
/

