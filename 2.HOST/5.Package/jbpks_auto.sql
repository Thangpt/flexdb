CREATE OR REPLACE PACKAGE jbpks_auto
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

  PROCEDURE pr_se_generate_data;
  PROCEDURE pr_gen_ci_buffer;
  PROCEDURE pr_gen_se_buffer;
  PROCEDURE pr_gen_od_buffer;
  PROCEDURE pr_process_od_bankaccount;
END;
/

CREATE OR REPLACE PACKAGE BODY jbpks_auto
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

PROCEDURE pr_se_generate_data
IS
l_count number;
CURSOR seRecords IS
    select l.*
    from afseinfo_log l
    where l.status = 'P'
        and exists (select 1 from afmast af, aftype aft, mrtype mrt where af.acctno = l.afacctno and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype in ('S','T'))
    order by autoid;
se_rec seRecords%ROWTYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'pr_se_generate_data');
    ----plog.debug (pkgctx, '<<BEGIN OF pr_se_generate_data');
    OPEN seRecords;
    loop
        FETCH seRecords INTO se_rec;
        EXIT WHEN seRecords%NOTFOUND;
        select count(1) into l_count
        from afmast af, aftype aft, mrtype mrt, lntype lnt
        where af.acctno = se_rec.afacctno
            and af.actype = aft.actype
            and aft.mrtype = mrt.actype
            and mrt.mrtype = 'T'
            and aft.lntype = lnt.actype(+);
        if l_count>0 then
            --semargininfo
            update semargininfo
            set sytrade = sytrade + se_rec.trade
            where codeid = se_rec.codeid;
        end if;
        select count(1) into l_count
        from afmast af, aftype aft, mrtype mrt, lntype lnt
        where af.acctno = se_rec.afacctno
            and af.actype = aft.actype
            and aft.mrtype = mrt.actype
            and mrt.mrtype = 'T'
            and aft.lntype = lnt.actype(+)
            and (   nvl(lnt.chksysctrl,'N') = 'Y'
                or exists (select 1 from afidtype afi, lntype lnt1 where afi.objname = 'LN.LNTYPE' and afi.aftype = af.actype and afi.actype = lnt1.actype and lnt1.chksysctrl='Y'));
        if l_count > 0 then
            update semargininfo
            set trade = trade + se_rec.trade
            where codeid = se_rec.codeid;
        end if;

        --
        for rec in
        (
            select * from v_getsecmargininfo_bod where afacctno = se_rec.afacctno
        )
        loop
            update afmargininfo
            set SEASS = rec.SEASS, SEAMT = rec.SEAMT, SEMRAMT = rec.SEMRAMT, SEMRASS = rec.SEMRASS, SEREALAMT = rec.SEREALAMT, SEREALASS = rec.SEREALASS
            where afacctno = rec.afacctno;
        end loop;
        -- update status
        update afseinfo_log
        set status = 'A'
        where autoid = se_rec.autoid;
    end loop;

    delete afseinfo_log l
    where not exists (select 1 from afmast af, aftype aft, mrtype mrt
                    where af.acctno = l.afacctno
                    and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype in ('S','T'));

    commit;
    plog.setendsection (pkgctx, 'pr_se_generate_data');
EXCEPTION WHEN OTHERS THEN
    plog.error(SQLERRM);
    ROLLBACK;
    plog.debug (pkgctx,'got error on release pr_se_generate_data');
    plog.setbeginsection(pkgctx, 'pr_se_generate_data');
END pr_se_generate_data;


PROCEDURE pr_gen_se_buffer
IS
CURSOR logRecords IS
    select * from log_se_account where status = 'P' order by autoid;
    log_rec logRecords%ROWTYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'pr_gen_se_buffer');
    --plog.debug (pkgctx, '<<BEGIN OF pr_gen_se_buffer');
    OPEN logRecords;
    loop
        FETCH logRecords INTO log_rec;
        EXIT WHEN logRecords%NOTFOUND;
        --Xu ly cap nhat lai buffer theo account
        fopks_api.pr_gen_buf_se_account(log_rec.acctno);
        COMMIT;
        update log_se_account
        set status = 'A', applytime= SYSTIMESTAMP
        where autoid = log_rec.autoid;
    end loop;
    commit;
    plog.setendsection (pkgctx, 'pr_gen_se_buffer');
EXCEPTION WHEN OTHERS THEN
    plog.error(SQLERRM);
    ROLLBACK;
    plog.debug (pkgctx,'got error on release pr_gen_se_buffer');
    plog.setbeginsection(pkgctx, 'pr_gen_se_buffer');
END pr_gen_se_buffer;

PROCEDURE pr_gen_ci_buffer
IS
CURSOR logRecords IS
    select distinct acctno  from log_ci_account where status = 'P' AND ACCTNO IS NOT NULL AND LENGTH(NVL(ACCTNO,'Z'))>5 ;--order by autoid;
    log_rec logRecords%ROWTYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'pr_gen_ci_buffer');
    --plog.debug (pkgctx, '<<BEGIN OF pr_gen_ci_buffer');
    OPEN logRecords;
    loop
        FETCH logRecords INTO log_rec;
        EXIT WHEN logRecords%NOTFOUND;

        update log_ci_account
        set status = 'A', applytime= SYSTIMESTAMP
        where acctno = log_rec.acctno;
        --Xu ly cap nhat lai buffer theo account
        fopks_api.pr_gen_buf_ci_account(log_rec.acctno);
        COMMIT;
        /*update log_ci_account
        set status = 'A', applytime= SYSTIMESTAMP
        where autoid = log_rec.autoid;*/
    end loop;
    commit;
    plog.setendsection (pkgctx, 'pr_gen_ci_buffer');
EXCEPTION WHEN OTHERS THEN
    plog.error(SQLERRM);
    ROLLBACK;
    plog.debug (pkgctx,'got error on release pr_gen_ci_buffer');
    plog.setbeginsection(pkgctx, 'pr_gen_ci_buffer');
END pr_gen_ci_buffer;


PROCEDURE pr_gen_od_buffer
IS
CURSOR logRecords IS
    select * from log_od_account where status = 'P' order by autoid;
    log_rec logRecords%ROWTYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'pr_gen_od_buffer');

    OPEN logRecords;
    loop
        FETCH logRecords INTO log_rec;
        EXIT WHEN logRecords%NOTFOUND;
        --Xu ly cap nhat lai buffer theo account
        fopks_api.pr_gen_buf_od_account(log_rec.acctno);
        COMMIT;
        update log_od_account
        set status = 'A', applytime= SYSTIMESTAMP
        where autoid = log_rec.autoid;
    end loop;
    commit;
    plog.setendsection (pkgctx, 'pr_gen_od_buffer');
EXCEPTION WHEN OTHERS THEN
    plog.error(SQLERRM);
    ROLLBACK;
    plog.debug (pkgctx,'got error on release pr_gen_od_buffer');
    plog.setbeginsection(pkgctx, 'pr_gen_od_buffer');
END pr_gen_od_buffer;

PROCEDURE pr_process_od_bankaccount
IS
CURSOR logRecords IS
    select * from log_od_account where status = 'P' order by autoid;
    log_rec logRecords%ROWTYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'pr_process_od_bankaccount');
   -- plog.debug (pkgctx, '<<BEGIN OF pr_process_od_bankaccount');
    OPEN logRecords;
    loop
        FETCH logRecords INTO log_rec;
        EXIT WHEN logRecords%NOTFOUND;
        --Xu ly cap nhat lai buffer theo account
        fopks_api.pr_gen_buf_od_account(log_rec.acctno);
        COMMIT;
        update log_od_account
        set status = 'A', applytime= SYSTIMESTAMP
        where autoid = log_rec.autoid;
    end loop;
    commit;
    plog.setendsection (pkgctx, 'pr_process_od_bankaccount');
EXCEPTION WHEN OTHERS THEN
    plog.error(SQLERRM);
    ROLLBACK;
    plog.debug (pkgctx,'got error on release pr_process_od_bankaccount');
    plog.setbeginsection(pkgctx, 'pr_process_od_bankaccount');
END pr_process_od_bankaccount;
-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('jbpks_auto',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/

