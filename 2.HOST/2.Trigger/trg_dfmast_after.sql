CREATE OR REPLACE TRIGGER "TRG_DFMAST_AFTER"
 AFTER
  UPDATE
 ON dfmast
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
begin
    if fopks_api.fn_is_ho_active then
        --Log trigger for buffer if modify
            fopks_api.pr_trg_account_log(:newval.afacctno || :newval.codeid,'SE');
        --End Log trigger for buffer
    end if;
end;
/

