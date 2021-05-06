CREATE OR REPLACE PROCEDURE pr_eventslog(p_etype varchar2, p_enode number, p_etext varchar2) is
begin
    insert into eventslog values (seq_eventslog.nextval, p_etype, p_enode, p_etext, systimestamp);
end;
/

