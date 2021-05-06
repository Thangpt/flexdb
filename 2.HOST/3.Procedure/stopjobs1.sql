CREATE OR REPLACE PROCEDURE stopjobs1 is

  pkgctx     plog.log_ctx;
  logrow     tlogdebug%ROWTYPE;

  job_is_running exception;
  PRAGMA EXCEPTION_INIT(job_is_running, -27366);
begin

  --Init log
  SELECT *
    INTO logrow
    FROM tlogdebug
   WHERE rownum <= 1;

  pkgctx := plog.init('Stopjobs',

                      plevel => logrow.loglevel,

                      plogtable => (logrow.log4table = 'Y'),

                      palert => (logrow.log4alert = 'Y'),

                      ptrace => (logrow.log4trace = 'Y'));

  plog.setbeginsection(pkgctx, 'Stopjobs');

  plog.error(pkgctx, 'Init Stopjobs');

--  UPDATE SYSVAR SET VARVALUE = 'N' WHERE GRNAME='SYSTEM' AND VARNAME='GXJBS_STATUS';
  COMMIT;



    BEGIN
    plog.error(pkgctx, 'STOP GTWJBS_#STRADE');
    dbms_scheduler.stop_job(job_name => 'GTWJBS_#STRADE', force =>  true);
    dbms_scheduler.disable(name => 'GTWJBS_#STRADE', force =>  true);
    EXCEPTION WHEN OTHERS THEN
        plog.error(pkgctx, sqlerrm);
        plog.error(pkgctx, 'Disable GTWJBS_#STRADE');
        dbms_scheduler.disable(name => 'GTWJBS_#STRADE', force =>  true);
    END;

  plog.setendsection(pkgctx, 'Stopjobs');

end stopjobs1;
/

