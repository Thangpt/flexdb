CREATE OR REPLACE PROCEDURE pr_lockaccountdirect(p_acctno varchar2, p_apptype  varchar2, p_err_code in out varchar2)
is
begin

    insert into accupdate (acctno,updatetype,createdate)
        values (p_acctno, p_apptype, SYSTIMESTAMP);

exception when others then
    p_err_code:='-100201';
end;
/

