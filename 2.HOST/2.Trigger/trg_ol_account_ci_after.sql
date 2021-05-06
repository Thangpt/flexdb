CREATE OR REPLACE TRIGGER "TRG_OL_ACCOUNT_CI_AFTER"
 AFTER
  INSERT OR UPDATE
 ON ol_account_ci
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
declare
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;

  v_afacctno varchar2(20);
begin
    -- Initialization log
  for i in (select * from tlogdebug)
  loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('trgr_event_vw_getcifull',
                      plevel                => nvl(logrow.loglevel, 30),
                      plogtable             => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert                => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace                => (nvl(logrow.log4trace, 'N') = 'Y'));

  plog.setBeginSection(pkgctx, 'trgr_event_vw_getcifull');

  v_afacctno := :newval.AFACCTNO;
  MSGPKS_SYSTEM.SP_NOTIFICATION_OBJ('GETCIFULL',
                                    :newval.AFACCTNO,
                                    v_afacctno);

plog.setEndSection(pkgctx, 'trgr_event_vw_getcifull');

exception
  when others then
    plog.error(pkgctx, sqlerrm);
    plog.setEndSection(pkgctx, 'trgr_event_vw_getcifull');
end;
/

