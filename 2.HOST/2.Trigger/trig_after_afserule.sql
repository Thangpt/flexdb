CREATE OR REPLACE TRIGGER trig_after_afserule
 AFTER
  UPDATE OR DELETE OR INSERT
 ON afserule
REFERENCING NEW AS NEW_VAL OLD AS OLD_VAL
 FOR EACH ROW
DECLARE
BEGIN
if fopks_api.fn_is_ho_active then
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
END;
/

