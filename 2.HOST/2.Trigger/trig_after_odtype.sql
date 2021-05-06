CREATE OR REPLACE TRIGGER trig_after_odtype
 AFTER
  INSERT OR DELETE OR UPDATE
 ON odtype
REFERENCING NEW AS NEW_VAL OLD AS OLD_VAL
 FOR EACH ROW
DECLARE
v_count number(20);
BEGIN
if fopks_api.fn_is_ho_active then
    IF (:NEW_VAL.deffeerate IS NULL  AND  :OLD_VAL.deffeerate IS NOT NULL )
     OR (:NEW_VAL.deffeerate IS NOT NULL  AND  :OLD_VAL.deffeerate IS NULL )
     OR (:NEW_VAL.deffeerate IS NOT NULL  AND  :OLD_VAL.deffeerate IS NOT NULL AND :NEW_VAL.deffeerate <> :OLD_VAL.deffeerate)   THEN
	    SELECT count(*) INTO v_count FROM t_fo_event WHERE tltxcd ='CHGODFEE' AND process ='N';
		  IF v_count = 0 THEN
            INSERT INTO t_fo_event (autoid,
                                    txnum,
                                    txdate,
                                    acctno,
                                    tltxcd,
                                    CVALUE,
                                    logtime,
                                    processtime,
                                    process,
                                    errcode,
                                    errmsg)
                    VALUES (seq_fo_event.NEXTVAL,
                            '',
                            '',
                            '',
                            'CHGODFEE',
                            :NEW_VAL.ACTYPE,
                            systimestamp,
                            '',
                            'N',
                            '',
                            '');

          END IF;
		 END IF;
		
END IF;
/*IF INSERTING  THEN
  v_Acction :='I';
ELSIF UPDATING THEN
  v_Acction :='U';
ELSE
  v_Acction :='D';
END IF;*/
END;
/

