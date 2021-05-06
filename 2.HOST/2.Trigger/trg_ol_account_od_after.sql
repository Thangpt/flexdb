CREATE OR REPLACE TRIGGER "TRG_OL_ACCOUNT_OD_AFTER"
 AFTER
  INSERT OR UPDATE
 ON ol_account_od
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
declare
  v_afacctno varchar2(20);
begin
  v_afacctno := :newval.AFACCTNO;
  MSGPKS_SYSTEM.SP_NOTIFICATION_OBJ('ORDERBOOK',
                                    :newval.ORDERID,
                                    v_afacctno);
end;
/

