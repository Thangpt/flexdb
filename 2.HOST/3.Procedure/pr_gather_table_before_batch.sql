CREATE OR REPLACE PROCEDURE pr_gather_table_before_batch
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;
begin
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
    if fn_get_sysvar_for_report('SYSTEM','GATHER_TABLE_BEFORE_BATCH') = 'Y' then

        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'CIMAST',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'AFMAST',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'CFMAST',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'SEMAST',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);

        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'CASCHD',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'LNMAST',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'LNSCHD',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);

        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'CIREMITTANCE',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'SBCURRDATE',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
--        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'AFSELIMIT',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'AFSERISK',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'SECURITIES_INFO',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'SECURITIES_RISK',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'SBSECURITIES',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);

        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'ODMAST',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'OOD',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'IOD',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'STSCHD',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);

        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'TLLOG',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'TLLOGFLD',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'CITRAN',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
        DBMS_STATS.GATHER_TABLE_STATS(null,tabname=>'SETRAN',estimate_percent =>100, cascade=>true, no_invalidate=>false, force=>true);
    end if;
EXCEPTION WHEN OTHERS THEN
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_IRCalcCreditInterest');
      RAISE errnums.E_SYSTEM_ERROR;
end;
/

