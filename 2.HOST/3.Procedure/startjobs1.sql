CREATE OR REPLACE PROCEDURE startjobs1 is
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

  pkgctx := plog.init('Startjobs',

                      plevel => logrow.loglevel,

                      plogtable => (logrow.log4table = 'Y'),

                      palert => (logrow.log4alert = 'Y'),

                      ptrace => (logrow.log4trace = 'Y'));

  plog.setbeginsection(pkgctx, 'Startjobs');

  plog.error(pkgctx, 'Init Startjobs');

    begin
  plog.error(pkgctx, 'Enable GTWJBS_#STRADE');
  dbms_scheduler.enable(name => 'GTWJBS_#STRADE');
  exception when others then
        plog.error(pkgctx, sqlerrm);
  end;
  plog.setendsection(pkgctx, 'Startjobs');
end startjobs1;
/

