CREATE OR REPLACE TRIGGER trig_after_AFIDTYPE
 AFTER
  INSERT OR DELETE OR UPDATE
 ON AFIDTYPE
REFERENCING NEW AS NEW_VAL OLD AS OLD_VAL
 FOR EACH ROW
DECLARE

BEGIN
if fopks_api.fn_is_ho_active then
IF :NEW_VAL.OBJNAME ='OD.ODTYPE' OR :OLD_VAL.OBJNAME ='OD.ODTYPE' THEN
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
END;
/

