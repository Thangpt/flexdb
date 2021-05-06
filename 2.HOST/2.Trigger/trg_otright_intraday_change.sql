CREATE OR REPLACE TRIGGER TRG_OTRIGHT_INTRADAY_CHANGE
 AFTER
 UPDATE OR INSERT OR DELETE
  ON OTRIGHT
 REFERENCING OLD AS OLD_VAL NEW AS NEW_VAL
 FOR EACH ROW
   DECLARE
     v_count NUMBER;
     v_custid VARCHAR2(10);
     v_currdate DATE;
BEGIN
  SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') CURRDATE INTO v_currdate
  FROM SYSVAR
  WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';
  SELECT COUNT(1) INTO v_count
  FROM intraday_change_event
  WHERE table_name = 'CFMAST'
  AND EXISTS (SELECT 1 FROM cfmast cf WHERE cf.custid = NVL(:NEW_VAL.cfcustid,:OLD_VAL.cfcustid));
  IF v_count = 0 THEN
    IF :NEW_VAL.AUTHTYPE <> :OLD_VAL.AUTHTYPE THEN
      INSERT INTO intraday_change_event(table_name, table_key, key_value, event_time, txdate)
      VALUES ('CFMAST','CUSTID', NVL(:NEW_VAL.cfcustid,:OLD_VAL.cfcustid), SYSTIMESTAMP, v_currdate);
    END IF;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;
/
