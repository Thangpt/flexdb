CREATE OR REPLACE TRIGGER "TRG_SENDSMGLOG_AFTER"
 AFTER
  INSERT
 ON sendmsglog
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
declare
  l_datasource   varchar2(1000);
  l_custody_code cfmast.custodycd%type;
  l_fullname     cfmast.fullname%type;
  l_marginrate    number;
  l_mrmrate       number;
  l_CLAMT         number;
  l_ODAMT         number;
  -- Private variable declarations
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;
begin
  -- Initialization
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('TRG_SENDSMGLOG_AFTER',
                      plevel                => nvl(logrow.loglevel, 30),
                      plogtable             => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert                => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace                => (nvl(logrow.log4trace, 'N') = 'Y'));

  plog.setBeginSection(pkgctx, 'TRG_SENDSMGLOG_AFTER');

  if :new.sendvia = 'S' then

    l_datasource := 'select ''' || :new.msgbody || ''' msgbody from dual';

    nmpks_ems.InsertEmailLog(:new.toaddr,
                             '327A',
                             l_datasource,
                             :new.acctno);
  ELSif length(nvl(:new.msgbody,'x'))>1 then


    if instr( :new.msgbody,'T0219')>0 then


    nmpks_ems.InsertEmailLog(:new.toaddr,
                             '0219',
                             :new.msgbody,
                             :new.acctno);
   ELSif instr( :new.msgbody,'T0218')>0 then

    nmpks_ems.InsertEmailLog(:new.toaddr,
                             '0218',
                             :new.msgbody,
                             :new.acctno);
    ELSif instr( :new.msgbody,'T4003')>0 then

    nmpks_ems.InsertEmailLog(:new.toaddr,
                             '4003',
                             :new.msgbody,
                             :new.acctno);
    ELSif instr( :new.msgbody,'T4004')>0 then

    nmpks_ems.InsertEmailLog(:new.toaddr,
                             '4004',
                             :new.msgbody,
                             :new.acctno);
     --- Begin binhvt
     ELSif (instr( :new.msgbody,'T2218')>0
     or instr( :new.msgbody,'T2219')>0
     or instr( :new.msgbody,'T4084')>0
     or instr( :new.msgbody,'T4033')>0) then
      insert into log_notify_event
      (autoid, msgtype, keyvalue, status, CommandType, CommandText, logtime)
    values
      (seq_log_notify_event.nextval, 'SENDMG', :new.autoid, 'A', 'P', 'GENERATE_TEMPLATES', sysdate);
    ---- end binhvt
     end if;
     end if;

  plog.setEndSection(pkgctx, 'TRG_SENDSMGLOG_AFTER');
exception
  when others then
    plog.error(pkgctx, sqlerrm);
    plog.setEndSection(pkgctx, 'TRG_SENDSMGLOG_AFTER');
end TRG_SENDSMGLOG_AFTER;
/

