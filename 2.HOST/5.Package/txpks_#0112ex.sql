CREATE OR REPLACE PACKAGE txpks_#0112ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0112EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      22/06/2012     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#0112ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_afacctno         CONSTANT CHAR(2) := '03';
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

    l_txnum varchar2(10);
    l_currdate varchar2(10);
    CURSOR markedRecords IS
        select afacctno
        from
        (
            select af.acctno afacctno,
                   least(
                        greatest(    -least(
                                            greatest(nvl(adv.avladvance,0)
                                                + balance,
                                            0)
                                        - (nvl(trf.trfsecuredamt_inday,0) + nvl(trf.secureamt_inday,0))
                                        +least(af.mrcrlimit,(nvl(trf.trfsecuredamt_inday,0) + nvl(trf.secureamt_inday,0)))
                                    ,0)
                                ,0),
                        least(least(nvl(af.mrcrlimitmax,0),to_number(cspks_system.fn_get_sysvar('MARGIN','MAXDEBTCF'))) - mst.dfodamt,/*af.mrcrlimit + */nvl(sec.setotalmramt,0) )) outstanding,
                   nvl(se.usedmargin,0) /*+ least(nvl(af.mrcrlimitmax,0),to_number(cspks_system.fn_get_sysvar('MARGIN','MAXDEBTCF')), af.mrcrlimit)*/ outstanding_prinused,
                   least(
                        greatest(    -least(
                                        greatest(nvl(adv.avladvance,0)
                                        + balance
                                        - mst.dfdebtamt
                                        - mst.dfintdebtamt
                                        - mst.depofeeamt
                                        - nvl(t0.t0prin,0),0)

                                        - mst.trfbuyamt
                                        - nvl(t0.nonmarginamt,0)
                                        - nvl(t0.marginamt,0)
                                    ,0)
                                ,0),
                         least(nvl(af.mrcrlimitmax,0) - mst.dfodamt,/*af.mrcrlimit +*/ nvl(sec.setotalamt,0) )) sy_outstanding,
                   nvl(se.sy_usedmargin,0) /*+ least(nvl(af.mrcrlimitmax,0),af.mrcrlimit)*/ sy_outstanding_prinused,
                   af.trfbuyrate * af.trfbuyext isLateTransfer


                from cimast mst,
                    afmast af,
                    (select pr.afacctno,
                            sum(nvl(pr.prinused,0) * least(nvl(rsk2.mrpriceloan,0), sb.marginrefprice) * least(nvl(rsk2.mrratioloan,0),100-mrt.mriratio) / 100) usedmargin,
                            sum(nvl(pr.sy_prinused,0) * least(nvl(rsk1.mrpriceloan,0), sb.marginprice) * nvl(rsk1.mrratioloan,0) / 100) sy_usedmargin
                         from aftype aft, mrtype mrt,
                              (select afpr.afacctno, afpr.actype, pr.codeid,
                                    sum(case when restype = 'M' then nvl(afpr.prinused,0) else 0 end) prinused,
                                    sum(case when restype = 'S' then nvl(afpr.prinused,0) else 0 end) sy_prinused
                                    from (select afacctno, af.actype, codeid, restype, sum(prinused) prinused
                                            from afmast af,
                                                 vw_afpralloc_all afp
                                            where af.acctno = afp.afacctno
                                            group by afacctno, af.actype, codeid, restype) afpr, vw_marginroomsystem pr
                                    where afpr.codeid = pr.codeid
                                    group by afpr.afacctno, afpr.actype, pr.codeid
                                 ) pr,
                                securities_info sb,
                                afserisk rsk1,
                                afmrserisk rsk2
                             where pr.codeid = sb.codeid
                             and pr.codeid = rsk1.codeid and pr.actype = rsk1.actype
                             and pr.codeid = rsk2.codeid and pr.actype = rsk2.actype
                             and pr.actype = aft.actype and aft.mrtype = mrt.actype
                             and mrt.mrtype = 'T'
                        group by pr.afacctno) se,
                    v_getbuyorderinfo b,
                    v_getsecmargininfo sec,
                    (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance group by afacctno) adv,
                    (select trfacctno,
                                sum(decode(lnt.chksysctrl,'Y',1,0)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) marginamt,
                                sum(decode(lnt.chksysctrl,'Y',0,1)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) nonmarginamt,
                                sum(oprinnml + oprinovd + ointnmlacr + ointdue + ointovdacr + ointnmlovd) t0prin
                            from lnmast ln, lntype lnt
                            where ln.actype = lnt.actype and ln.ftype = 'AF'
                            group by trfacctno) t0,
                    vw_trfbuyinfo_inday trf
                where mst.acctno = af.acctno
                    AND af.trfbuyrate * af.trfbuyext > 0 -- chi lay cac tai khoan T2
                    and mst.afacctno = se.afacctno(+)
                    and mst.afacctno = b.afacctno(+)
                    and mst.afacctno = sec.afacctno(+)
                    and mst.afacctno = adv.afacctno(+)
                    and mst.afacctno = t0.trfacctno(+)
                    AND mst.afacctno = trf.afacctno(+)

        )
        where greatest(outstanding_prinused,0) - greatest(outstanding,0) <> 0 or
                greatest(sy_outstanding_prinused,0) - greatest(sy_outstanding,0)<> 0
        order by (case when isLateTransfer = 0 then 0 else 1 end),
                greatest(sy_outstanding_prinused - greatest(sy_outstanding,0),0) desc ,greatest(greatest(sy_outstanding, 0) - sy_outstanding_prinused,0);

    marked_rec markedRecords%ROWTYPE;
    l_count number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    l_txnum:=null;
    l_currdate:= cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
    if trim(p_txmsg.txfields(c_afacctno).value) = 'ALL'
        or length(trim(p_txmsg.txfields(c_afacctno).value)) = 0
        or p_txmsg.txfields(c_afacctno).value = ''
        or p_txmsg.txfields(c_afacctno).value is null then
        -- Thuc hien phan bo lai.
        plog.error('LOOP');
        OPEN markedRecords;
        loop
            FETCH markedRecords INTO marked_rec;
            EXIT WHEN markedRecords%NOTFOUND;
            plog.error('LOOP IN: '||marked_rec.afacctno);
            if fn_markedafpralloc(marked_rec.afacctno,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(l_currdate,systemnums.c_date_format),
                            l_txnum,
                            p_err_code,
                            'Y') <> systemnums.C_SUCCESS then
                null;
            end if;
        end loop;
        close markedRecords;
    else
        select count(1) into l_count from afmast where acctno = p_txmsg.txfields(c_afacctno).value;
        if l_count > 0 then
            plog.error('p_txmsg.txfields(c_afacctno).value: '||p_txmsg.txfields(c_afacctno).value);
            if fn_markedafpralloc(p_txmsg.txfields(c_afacctno).value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(l_currdate,systemnums.c_date_format),
                            l_txnum,
                            p_err_code,
                            'Y') <> systemnums.C_SUCCESS then
                null;
            end if;
        end if;
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
         plog.init ('TXPKS_#0112EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0112EX;
/

