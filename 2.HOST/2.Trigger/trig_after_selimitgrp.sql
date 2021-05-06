CREATE OR REPLACE TRIGGER trig_after_selimitgrp
 AFTER
  INSERT OR DELETE OR UPDATE
 ON selimitgrp
REFERENCING NEW AS NEW_VAL OLD AS OLD_VAL
 FOR EACH ROW
DECLARE
v_symbol varchar2(100);
BEGIN
 if fopks_api.fn_is_ho_active then
        IF :NEW_VAL.SELIMIT IS NOT NULL
          AND :NEW_VAL.STATUS ='A' AND :OLD_VAL.STATUS <>'A' THEN
        --Them moi room dac biet
                 SELECT symbol INTO v_symbol FROM SECURITIES_INFO WHERE codeid = :NEW_VAL.CODEID;

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
                                :NEW_VAL.AUTOID,
                                'ADDSPROOM',
                                v_symbol,
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

