create or replace procedure pr_add_list_indicators(p_symbol varchar2, p_afacctno varchar2) is
begin
  insert into tracklist(symbol,afacctno) values(p_symbol,p_afacctno);
  exception
    when others then
      return;
end pr_add_list_indicators;
/

