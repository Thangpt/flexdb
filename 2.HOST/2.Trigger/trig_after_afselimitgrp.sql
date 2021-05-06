CREATE OR REPLACE TRIGGER trig_after_afselimitgrp
 AFTER
  INSERT OR DELETE OR UPDATE
 ON afselimitgrp
REFERENCING NEW AS NEW_VAL OLD AS OLD_VAL
 FOR EACH ROW
DECLARE
v_action varchar2(100);
v_roomID varchar2(100);
v_acctno varchar2(100);
BEGIN
IF  fopks_api.fn_is_ho_active then
        IF :NEW_VAL.REFAUTOID IS NOT NULL THEN
          v_action:='I';
          v_roomID:=:NEW_VAL.REFAUTOID;
          v_acctno:=:NEW_VAL.AFACCTNO;
        ELSE
          v_action:='D';
          v_roomID:=:OLD_VAL.REFAUTOID;
          v_acctno:=:OLD_VAL.AFACCTNO;
        END IF;
		
		 IF (v_action ='I'and :NEW_VAL.STATUS = 'A' AND :OLD_VAL.STATUS = 'P') or ( v_action ='D'  and :OLD_VAL.STATUS = 'A') THEN
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
                        v_roomID,
                        'ACC2SPROOM',
                        v_action||v_acctno,
                        systimestamp,
                        '',
                        'N',
                        '',
                        '');
   END IF;

 END IF;
END;
/

