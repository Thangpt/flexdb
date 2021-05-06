CREATE OR REPLACE TRIGGER trig_after_prmaster
 AFTER
  INSERT OR DELETE OR UPDATE
 ON prmaster
REFERENCING NEW AS NEW_VAL OLD AS OLD_VAL
 FOR EACH ROW
DECLARE
BEGIN
 if fopks_api.fn_is_ho_active then
        IF :NEW_VAL.PRTYP ='P' AND ((:NEW_VAL.PRLIMIT IS NULL  AND  :OLD_VAL.PRLIMIT IS NOT NULL )
         OR (:NEW_VAL.PRLIMIT IS NOT NULL  AND  :OLD_VAL.PRLIMIT IS NULL )
         OR (:NEW_VAL.PRLIMIT IS NOT NULL  AND  :OLD_VAL.PRLIMIT IS NOT NULL
                 AND :NEW_VAL.PRLIMIT <> :OLD_VAL.PRLIMIT) )  THEN


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
                                :NEW_VAL.PRCODE,
                                'CHGPOOL',
                                '',
                                systimestamp,
                                '',
                                'N',
                                '',
                                '');

            END IF;
        /*IF INSERTING  THEN
          v_Acction :='I';
        ELSIF UPDATING THEN
          v_Acction :='U';
        ELSE
          v_Acction :='D';
        END IF;*/
 END IF;
END;
/

