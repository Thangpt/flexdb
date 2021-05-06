create or replace procedure sp_exec_money_ca_action(pv_refcursor in out pkg_report.ref_cursor,
                                              p_camastid   varchar2) is
begin
  sp_demo_exec_cop_action(p_camastid,'CI');
  open pv_refcursor for
    select sysdate from dual;
end;
/

