CREATE OR REPLACE TRIGGER trig_after_aftype
 AFTER
  UPDATE
 ON aftype
REFERENCING NEW AS NEW_VAL OLD AS OLD_VAL
 FOR EACH ROW
DECLARE

BEGIN
 if fopks_api.fn_is_ho_active then
   IF :NEW_VAL.LNTYPE IS NOT NULL
     AND :NEW_VAL.LNTYPE <> :OLD_VAL.LNTYPE  THEN
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
                        :NEW_VAL.ACTYPE,
                        'CHGLNTYPE',
                        '',
                        systimestamp,
                        '',
                        'N',
                        '',
                        '');
    END IF;
    IF :NEW_VAL.POLICYCD <> :OLD_VAL.POLICYCD THEN
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
                            'CHGDEFRULE',
                            '',
                            systimestamp,
                            '',
                            'N',
                            '',
                            '');

     END IF;
END IF;
END;
/

