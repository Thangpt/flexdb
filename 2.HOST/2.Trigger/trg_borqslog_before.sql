CREATE OR REPLACE TRIGGER "TRG_BORQSLOG_BEFORE"
 BEFORE
  INSERT OR UPDATE
 ON borqslog
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
begin
:newval.last_change:= SYSTIMESTAMP;

  if fopks_api.fn_is_ho_active and (:newval.rqstyp = 'TRF' or :newval.rqstyp = 'CAR') then
    msgpks_system.sp_notification_obj('MONEYTRANSFER',
                                      :newval.rqstyp,
                                      :newval.requestid);
  end if;

END;
/

