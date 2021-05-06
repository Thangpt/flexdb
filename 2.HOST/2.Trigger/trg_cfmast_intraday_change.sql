CREATE OR REPLACE TRIGGER TRG_CFMAST_INTRADAY_CHANGE
 AFTER
 INSERT OR UPDATE OF fullname,tradingcode,idcode,tradingcodedt,iddate,idexpired,address,fax,mobile,
 mobilesms,idplace,country,dateofbirth,phone,idtype,email,sex,custtype,pin,brid OR DELETE
  ON CFMAST
 REFERENCING OLD AS OLD_VAL NEW AS NEW_VAL
 FOR EACH ROW
   DECLARE
      v_count NUMBER;
      v_currdate DATE;
BEGIN
  SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') CURRDATE INTO v_currdate
  FROM SYSVAR
  WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';
  SELECT COUNT(1) INTO v_count FROM intraday_change_event
  WHERE table_name = 'CFMAST' AND key_value = :NEW_VAL.custid AND txdate = v_currdate;
  IF v_count = 0 THEN
    IF :old_val.fullname <> :new_val.fullname OR :old_val.tradingcode <> :new_val.tradingcode
      OR :old_val.idcode <> :new_val.idcode OR :old_val.tradingcodedt <> :new_val.tradingcodedt
      OR :old_val.iddate <> :new_val.iddate OR :old_val.idexpired <> :new_val.idexpired
      OR :old_val.address <> :new_val.address OR :old_val.fax <> :new_val.fax
      OR :old_val.mobile <> :new_val.mobile OR :old_val.mobilesms <> :new_val.mobilesms
      OR :old_val.idplace <> :new_val.idplace OR :old_val.country <> :new_val.country
      OR :old_val.dateofbirth <> :new_val.dateofbirth OR :old_val.phone <> :new_val.phone
      OR :old_val.idtype <> :new_val.idtype OR :old_val.status <> :new_val.status
      OR :old_val.email <> :new_val.email OR :old_val.sex <> :new_val.sex
      OR :old_val.custtype <> :new_val.custtype 
      OR :old_val.pin <> :new_val.pin OR :old_val.activests <> :new_val.activests
      OR :old_val.brid <> :new_val.brid THEN

      INSERT INTO intraday_change_event(table_name, table_key, key_value, event_time, txdate)
      VALUES ('CFMAST','CUSTID', :NEW_VAL.custid, SYSTIMESTAMP, v_currdate);
    END IF;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;
/
