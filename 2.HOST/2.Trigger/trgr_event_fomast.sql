CREATE OR REPLACE TRIGGER trgr_event_fomast
 AFTER
  INSERT OR UPDATE
 ON fomast
REFERENCING NEW AS NEW_VAL OLD AS OLD_VAL
 FOR EACH ROW
  WHEN (new_val.book = 'A' and new_val.status = 'P' and new_val.status = 'W'
) declare
  v_afacctno varchar2(20);
begin
  if fopks_api.fn_is_ho_active then
    v_afacctno := :new_val.afacctno;
    /*if :new_val.status = 'W' then
      msgpks_system.sp_notification_fo('FOW', :new_val.acctno, v_afacctno);
    else
      msgpks_system.sp_notification_fo('FO', :new_val.acctno, v_afacctno);
    end if;*/
  end if;
end;
/

