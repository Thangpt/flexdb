CREATE OR REPLACE TRIGGER trig_after_securities_info
 AFTER
  INSERT OR DELETE OR UPDATE
 ON securities_info
REFERENCING NEW AS NEW_VAL OLD AS OLD_VAL
 FOR EACH ROW
DECLARE
v_count number(20);
BEGIN
 if fopks_api.fn_is_ho_active THEN
   -- 1.5.8.9|iss:2056 Dong bo gia tinh tai san, SL giao dich trung binh sang HFT
   IF :NEW_VAL.navprice <> :OLD_VAL.navprice OR
      :NEW_VAL.avrtradeqtt <> :OLD_VAL.avrtradeqtt THEN
      SELECT count(*) INTO v_count FROM t_fo_event WHERE tltxcd ='CHGSEINFO' AND process ='N';
        IF v_count = 0 THEN
           INSERT INTO t_fo_event(autoid, txnum, txdate, acctno, tltxcd, logtime, processtime, process, errcode, errmsg, nvalue, cvalue)
                 VALUES (
                        seq_fo_event.NEXTVAL,
                        '',
                        '',
                        '',
                        'CHGSEINFO',
                        SYSTIMESTAMP,
                        NULL,
                        'N',
                        '0',
                        NULL,
                        NULL,
                        :NEW_VAL.symbol);
        END IF;
   END IF;     
        IF (:NEW_VAL.ROOMLIMIT IS NULL  AND  :OLD_VAL.ROOMLIMIT IS NOT NULL )
         OR (:NEW_VAL.ROOMLIMIT IS NOT NULL  AND  :OLD_VAL.ROOMLIMIT IS NULL )
         OR (:NEW_VAL.ROOMLIMIT IS NOT NULL  AND  :OLD_VAL.ROOMLIMIT IS NOT NULL
                 AND :NEW_VAL.ROOMLIMIT <> :OLD_VAL.ROOMLIMIT)
         OR (:NEW_VAL.ROOMLIMITMAX IS NULL  AND  :OLD_VAL.ROOMLIMITMAX IS NOT NULL )
         OR (:NEW_VAL.ROOMLIMITMAX IS NOT NULL  AND  :OLD_VAL.ROOMLIMITMAX IS NULL )
         OR (:NEW_VAL.ROOMLIMITMAX IS NOT NULL  AND  :OLD_VAL.ROOMLIMITMAX IS NOT NULL
                 AND :NEW_VAL.ROOMLIMITMAX <> :OLD_VAL.ROOMLIMITMAX)
                   THEN
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
                                'UB',
                                'CHGROOM',
                                 :NEW_VAL.symbol,
                                systimestamp,
                                '',
                                'N',
                                '',
                                '');

            END IF;

        IF /* (:NEW_VAL.SYROOMLIMIT IS NULL  AND  :OLD_VAL.SYROOMLIMIT IS NOT NULL )
         OR (:NEW_VAL.SYROOMLIMIT IS NOT NULL  AND  :OLD_VAL.SYROOMLIMIT IS NULL )
         OR (:NEW_VAL.SYROOMLIMIT IS NOT NULL  AND  :OLD_VAL.SYROOMLIMIT IS NOT NULL
                 AND*/ :NEW_VAL.SYROOMLIMIT <> :OLD_VAL.SYROOMLIMIT  THEN
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
                                'SYSTEM',
                                'CHGROOM',
                                 :NEW_VAL.symbol,
                                systimestamp,
                                '',
                                'N',
                                '',
                                '');

            END IF;

          SELECT count(*) INTO v_count FROM t_fo_event WHERE tltxcd ='CHGMRPRICE' AND process ='N';
          IF v_count = 0 THEN
              IF :NEW_VAL.marginprice <> :OLD_VAL.marginprice  THEN
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
                                    'CHGMRPRICE',
                                     :NEW_VAL.symbol,
                                    systimestamp,
                                    '',
                                    'N',
                                    '',
                                    '');

                END IF;
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
