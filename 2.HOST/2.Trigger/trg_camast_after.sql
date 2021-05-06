CREATE OR REPLACE TRIGGER "TRG_CAMAST_AFTER"
  after update on camast
  for each row
declare
  -- local variables here
begin
  --Gui mau email 216
  if :new.status = 'V' and :new.status <> :old.status and :new.catype = '014' then
  -- MSBS-2643
    insert into log_notify_event
      (autoid, msgtype, keyvalue, status, CommandType, CommandText, logtime)
    values
      (seq_log_notify_event.nextval, 'CAMAST_A', :new.camastid, 'A', 'P', 'GENERATE_TEMPLATES', sysdate);
    insert into log_notify_event
      (autoid, msgtype, keyvalue, status, CommandType, CommandText, logtime)
    values
      (seq_log_notify_event.nextval, 'CAMAST_V', :new.camastid, 'A', 'P', 'GENERATE_TEMPLATES', sysdate);
  end if;

  if :new.status = 'S' and :new.status <> :old.status and :new.catype <> '014' then
    insert into log_notify_event
      (autoid, msgtype, keyvalue, status, CommandType, CommandText, logtime)
    values
      (seq_log_notify_event.nextval, 'CAMAST_S', :new.camastid, 'A', 'P', 'GENERATE_TEMPLATES', sysdate);
  end if;
  
  /*if :new.status = 'A' and :new.status <> :old.status and :new.catype = '014' then
    insert into log_notify_event
      (autoid, msgtype, keyvalue, status, CommandType, CommandText, logtime)
    values
      (seq_log_notify_event.nextval, 'CAMAST_A', :new.camastid, 'A', 'P', 'GENERATE_TEMPLATES', sysdate);
  end if;  */ --MSBS-2643
end TRG_CAMAST_AFTER;
/

