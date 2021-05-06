CREATE OR REPLACE TRIGGER "TRG_FOMAST_AFTER"
 AFTER
  INSERT OR UPDATE
 ON fomast
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
DECLARE
    diff NUMBER(20,8);
    v_hostatus varchar2(10);
    v_errmsg varchar2(2000);
    v_custid varchar2(10);
    v_currdate date;
    v_symbol varchar2(10);
    v_debugmsg varchar2(1700);
    l_afacctno varchar2(20);
    l_seacctno varchar2(20);
    l_orderid varchar2(20);
    diff_cancel NUMBER(20,0);
    diff_exec NUMBER(20,0);
BEGIN
SELECT      VARVALUE
INTO        V_HOSTATUS
FROM        SYSVAR
WHERE       VARNAME = 'HOSTATUS';

IF V_HOSTATUS = '1' THEN
    --Begin GianhVG Log trigger for buffer
    if inserting then
        fopks_api.pr_trg_account_log(:newval.acctno,'OD');
    else
        if :newval.status<>:oldval.status then
            fopks_api.pr_trg_account_log(:newval.acctno,'OD');
        end if;
    end if;
END IF;
/*EXCEPTION
WHEN OTHERS THEN
    v_errmsg := substr(sqlerrm, 1, 200);
    pr_error(v_debugmsg || ' ' || v_errmsg, 'trg_fomast_after');*/
END;
/

