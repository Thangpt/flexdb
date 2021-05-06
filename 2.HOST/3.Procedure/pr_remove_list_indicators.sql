create or replace procedure pr_remove_list_indicators(p_symbol varchar2, p_afacctno varchar2) is
begin
  update tracklist set deltd = 'Y' where symbol = p_symbol and afacctno = p_afacctno;
  exception
    when others then
      return;
end pr_remove_list_indicators;
/

