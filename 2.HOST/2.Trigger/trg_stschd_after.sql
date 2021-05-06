CREATE OR REPLACE TRIGGER "TRG_STSCHD_AFTER"
 AFTER
  INSERT OR UPDATE
 ON stschd
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
declare
    v_afacctno varchar2(20);
    v_errmsg varchar2(10000);
begin
    if fopks_api.fn_is_ho_active then
        --Log trigger for buffer if match sell order or
        -- TheNN, 04-Feb-2012
        IF :newval.DUETYPE = 'RM' THEN
            fopks_api.pr_trg_account_log(:newval.acctno,'CI');
        END IF;
        --End Log trigger for buffer
    end if;
end;
/

