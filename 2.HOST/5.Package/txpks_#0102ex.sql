CREATE OR REPLACE PACKAGE txpks_#0102ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0102EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      10/10/2011     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#0102ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '01';
   c_acctno           CONSTANT CHAR(2) := '02';
   c_codeid           CONSTANT CHAR(2) := '03';
   c_codeidre         CONSTANT CHAR(2) := '04';
   c_qtty             CONSTANT CHAR(2) := '05';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_ACCTNO               VARCHAR2(30);
    l_CODEID               VARCHAR2(10);
    l_CODEIDRE             VARCHAR2(10);
    l_QTTY                    NUMBER;
    l_count                   NUMBER;

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
    l_ACCTNO             := p_txmsg.txfields('02').VALUE;
    l_CODEID             := p_txmsg.txfields('03').VALUE;
    l_CODEIDRE           := p_txmsg.txfields('04').VALUE;
    l_QTTY               := p_txmsg.txfields('05').VALUE;

    IF p_txmsg.deltd <> 'Y' THEN
        select count(1)
            into l_count
        from afmast af, aftype aft, mrtype mrt
        where af.actype = aft.actype and aft.mrtype = mrt.actype and af.acctno = l_ACCTNO
        and (exists (select 1 from lntype lnt where to_char(lnt.actype) = to_char(aft.lntype) and lnt.chksysctrl = 'Y')
            or exists (select 1 from afidtype afi, lntype lnt where lnt.actype = afi.actype and afi.objname = 'LN.LNTYPE' and afi.aftype = aft.actype and lnt.chksysctrl = 'Y'));

        IF l_count = 0 THEN
            p_err_code := '-100542';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        SELECT COUNT(1)
            INTO l_count
        FROM vw_afpralloc_all
        WHERE AFACCTNO = l_ACCTNO and restype = 'M'
            AND CODEID = l_CODEID;

        IF l_count = 0 THEN
            p_err_code := '-100543';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        SELECT COUNT(1)
            INTO l_count
        FROM   SEMAST SE, AFMAST AF, AFMRSERISK RS
        WHERE  AF.ACCTNO = SE.AFACCTNO
            AND    AF.ACTYPE = RS.ACTYPE(+)
            AND    SE.CODEID = RS.CODEID
            AND    AF.ACCTNO = l_ACCTNO
            AND    SE.CODEID = l_CODEIDRE
            AND    SE.CODEID <> l_CODEID;

        IF l_count = 0 THEN
            p_err_code := '-100545';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    END IF;

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
    l_AFACCTNO               VARCHAR2(30);
    l_FR_CODEID               VARCHAR2(10);
    l_TO_CODEID             VARCHAR2(10);
    l_qtty                    NUMBER;
    l_remain_qtty               number;
    l_advanceline             NUMBER(20,0);
    l_pravllimit              number(20,0);
    l_ALLOCTYP             VARCHAR2(10);
    l_ORGORDERID           VARCHAR2(50);
    --l_mrratioratio          number(20,4);
    l_marked_outstanding      NUMBER(20,0);
    l_unmarked_outstanding    NUMBER(20,0);
    l_actype                  varchar2(4);
    l_avlqtty                 number(20,0);
    l_fr_marginPrice             number(20,0);
    l_to_marginPrice             number(20,0);
    l_fr_marginRate             number(20,0);
    l_to_marginRate             number(20,0);
    l_exec_outstanding        number(20,0);
    l_exec_amtCODEID          NUMBER(20,0);
    l_fr_securedqtty             number(20,0);
    l_to_securedqtty             number(20,0);
    l_type                    varchar2(10);
    l_fr_mrratiorate        number(20,4);
    l_to_mrratiorate        number(20,4);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    if p_txmsg.deltd <> 'Y' then
        l_AFACCTNO             := p_txmsg.txfields('02').VALUE;
        l_FR_CODEID             := p_txmsg.txfields('03').VALUE;
        l_TO_CODEID           := p_txmsg.txfields('04').VALUE;
        l_qtty                  := p_txmsg.txfields('05').VALUE;

        --- LAY BAO LANH T0
        plog.debug(pkgctx,'Lay Bao lanh T0');
        SELECT advanceline
            INTO l_advanceline
        FROM afmast
        WHERE acctno = l_AFACCTNO;

        --- LAY GT CK CHUYEN
        plog.debug(pkgctx,'Lay gia vay ma chung khoan chuyen');
        begin
            SELECT least(nvl(sb.marginrefprice, 0), nvl(rsk.mrpriceloan, 0)), least(nvl(rsk.mrratioloan,0),100-af.mriratio)
                INTO  l_fr_marginPrice, l_fr_mrratiorate
            FROM  afmast af, afmrserisk rsk, securities_info sb
            WHERE af.actype = rsk.actype AND rsk.codeid = sb.codeid AND AF.ACCTNO = l_AFACCTNO AND SB.CODEID = l_FR_CODEID;
        exception when others then
            p_err_code := '-100543';
            RETURN errnums.C_BIZ_RULE_INVALID;
        end;

        plog.debug(pkgctx,'Lay gia vay ma chung khoan nhan');
        begin
            SELECT least(nvl(sb.marginrefprice, 0), nvl(rsk.mrpriceloan, 0)), least(nvl(rsk.mrratioloan,0),100-af.mriratio)
                INTO  l_to_marginPrice, l_to_mrratiorate
            FROM  afmast af, afmrserisk rsk, securities_info sb
            WHERE af.actype = rsk.actype AND rsk.codeid = sb.codeid AND AF.ACCTNO = l_AFACCTNO AND SB.CODEID = l_TO_CODEID;
        exception when others then
            p_err_code := '-100543';
            RETURN errnums.C_BIZ_RULE_INVALID;
        end;

        --- han muc con lai cua room ck nhan VA SL CK MARGIN
        plog.debug(pkgctx,'Lay gioi hang nguon');
        SELECT nvl(pravllimit,0) pravllimit
        INTO l_pravllimit
        From
                (select codeid, max(prinused) prinused, max(prlimit) prlimit, min(pravllimit) pravllimit
                    from
                        (select pr.codeid, sum(nvl(afpr.prinused,0)) prinused, max(pr.roomlimit) prlimit,
                                    max(pr.roomlimit) - sum(nvl(afpr.prinused,0)) pravllimit
                                        from (select * from vw_afpralloc_all where restype = 'M') afpr, vw_marginroomsystem pr
                                        where afpr.codeid(+) = pr.codeid
                                        group by pr.codeid)
                    group by codeid
                    ) pr
        WHERE PR.codeid = l_TO_CODEID;

        plog.debug(pkgctx,'Lay SO DU CK MARGIN');
        select (se.trade - nvl(sts.execsellqtty,0) + nvl(od.buyqtty,0) + nvl(sts.execbuyqtty,0)) - nvl(pr.prinused,0)
            into l_avlqtty
        from (select * from semast where afacctno = l_AFACCTNO and codeid = l_TO_CODEID) se,
             (select * from afmast where acctno = l_AFACCTNO) af,
             aftype aft, mrtype mrt, securities_info sb, afmrserisk rsk,
            (select sts.afacctno, sts.codeid,
                sum(case when duetype = 'SS' then qtty - decode(status,'C',qtty,aqtty) - nvl(dfexecqtty,0) else 0 end) execsellqtty,
                sum(case when duetype = 'RS' then case when nvl(sts_trf.islatetransfer,0) = 0 then qtty - decode(status,'C',qtty,aqtty) else 0 end else 0 end) execbuyqtty
                from stschd sts, odmast od,
                    (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex,
                    (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf
                where duetype in ('SS','RS') and sts.afacctno = l_AFACCTNO and sts.codeid = l_TO_CODEID and sts.deltd <> 'Y'
                and sts.orgorderid = dfex.orderid(+)
                and sts.orgorderid = sts_trf.orgorderid(+)
                and sts.orgorderid = od.orderid
                and not (od.grporder='Y' and od.matchtype='P')
                group by sts.afacctno, sts.codeid) sts,
            (select afacctno, codeid,
                sum(case when exectype = 'NB' and nvl(trfbuyrate*trfbuyext,0) = 0 then remainqtty else 0 end) buyqtty
                from odmast od, afmast af
                where exectype = 'NB' and afacctno = l_AFACCTNO and codeid = l_TO_CODEID and od.deltd <> 'Y'
                and not (od.grporder='Y' and od.matchtype='P')
                and od.afacctno = af.acctno
                group by afacctno, codeid) od,
            (select afacctno, codeid, sum(prinused) prinused
                           from vw_afpralloc_all
                           where afacctno = l_AFACCTNO and codeid = l_TO_CODEID and restype = 'M'
                           group by afacctno,codeid
                ) pr
        where se.afacctno = l_AFACCTNO and se.codeid = l_TO_CODEID
        and se.afacctno = af.acctno and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
        and se.afacctno = sts.afacctno(+) and se.codeid = sts.codeid(+)
        and se.afacctno = od.afacctno(+) and se.codeid = od.codeid(+)
        and se.afacctno = pr.afacctno(+) and se.codeid = pr.codeid(+)
        and af.actype = rsk.actype and se.codeid = rsk.codeid and sb.codeid = se.codeid;



         --- THUC HIEN KIEM TRA VA CAP NHAT
         l_remain_qtty:=  l_qtty;
         plog.debug(pkgctx,'Phan bo chuyen dao tai san dam bao. SL:'||l_remain_qtty);
         for rec_afpr in
         (
             select alloctyp, sum(prinused) prinused
             from vw_afpralloc_all
             where afacctno = l_AFACCTNO and codeid = l_FR_CODEID and restype = 'M'
             having sum(prinused) > 0
             group by alloctyp
             order by decode(alloctyp,'T',0,1)
         )
         loop
             plog.debug(pkgctx,'BEGIN LOOP');
             if l_fr_marginPrice * l_fr_mrratiorate > 0 then
                 --- GT chung khoan chuyen
                 l_exec_outstanding:= greatest(least(nvl(rec_afpr.prinused, 0), l_remain_qtty) * l_fr_marginPrice * (l_fr_mrratiorate/100), 0);

                 --- SL chung khoan chuyen
                 l_fr_securedqtty:= round(l_exec_outstanding / (l_fr_marginPrice * (l_fr_mrratiorate/100)), 0);

                 --- QUI DOI SL CK NHAN TUONG UNG VOI SL CK CHUYEN
                 l_to_securedqtty     := CEIL(l_exec_outstanding / (l_to_marginPrice * (l_to_mrratiorate/100)));

                 IF (l_to_securedqtty <= l_avlqtty AND l_to_securedqtty <= l_pravllimit) then
                    l_remain_qtty:= l_remain_qtty - l_fr_securedqtty;

                    l_pravllimit := l_pravllimit - l_to_securedqtty;

                    l_avlqtty    := l_avlqtty - l_to_securedqtty;

                   --- GO BO DANH DAU TUONG UNG VOI CK CHUYEN
                   INSERT INTO afpralloc (AUTOID, AFACCTNO, PRINUSED, CODEID, ALLOCTYP, ORGORDERID, TXDATE, TXNUM, RESTYPE)
                   VALUES(seq_afpralloc.nextval, l_AFACCTNO, -l_fr_securedqtty, l_FR_CODEID, rec_afpr.alloctyp, l_ORGORDERID,
                          TO_DATE(p_txmsg.txdate, SYSTEMNUMS.C_DATE_FORMAT), p_txmsg.txnum, 'M');

                   --- DANH DAU CK NHAN
                   INSERT INTO afpralloc (AUTOID, AFACCTNO, PRINUSED, CODEID, ALLOCTYP, ORGORDERID, TXDATE, TXNUM, RESTYPE)
                   VALUES(seq_afpralloc.nextval, l_AFACCTNO, l_to_securedqtty, l_TO_CODEID, rec_afpr.alloctyp, l_ORGORDERID,
                              TO_DATE(p_txmsg.txdate, SYSTEMNUMS.C_DATE_FORMAT), p_txmsg.txnum, 'M');
                 else
                    p_err_code := '-100546';
                    RETURN errnums.C_BIZ_RULE_INVALID;
                    exit;
                 end if;
             end if;

             exit when least(l_remain_qtty, l_pravllimit, l_avlqtty) <= 0;
         end loop;

         plog.debug(pkgctx,'l_remain_qtty:'||l_remain_qtty);

         if l_remain_qtty > 0 then
             p_err_code := '-100546';
             RETURN errnums.C_BIZ_RULE_INVALID;
         end if;

    else
        delete afpralloc where txdate = p_txmsg.txdate and txnum = p_txmsg.txnum;
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
         plog.init ('TXPKS_#0102EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0102EX;
/

