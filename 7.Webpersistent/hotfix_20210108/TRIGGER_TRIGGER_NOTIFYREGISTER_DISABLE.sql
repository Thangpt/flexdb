CREATE OR REPLACE TRIGGER TRIGGER_NOTIFYREGISTER_DISABLE
AFTER UPDATE ON NOTIFYREGISTER
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
BEGIN
  --ROLLBACK;
  dbms_output.put_line('Should be rollback');
  if :NEWVAL.devicetoken='abc' THEN
    RAISE_APPLICATION_ERROR (-20000, 'Deletion or Update not supported on this table '||:NEWVAL.devicetoken);
  end if;
END;
