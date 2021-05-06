create or replace function fn_get_ratio_by_floor_code(pv_varname in varchar2,
                                                  pv_type in varchar2)
  return number is
  l_ratio number := 1.07;

begin
  -- Tinh bien do theo type truyen vao   
  -- C: Ceiling Price
  -- F: Floor Price

  if pv_type = 'C' then
    select to_number(sys1.varvalue) / 100 + 1 into l_ratio
      from sysvar sys1
     where sys1.grname = 'SYSTEM'
       and sys1.varname = pv_varname;
  elsif pv_type = 'F' then
    select 1 - to_number(sys1.varvalue) / 100 into l_ratio
      from sysvar sys1
     where sys1.grname = 'SYSTEM'
       and sys1.varname = pv_varname;
  end if;

  return l_ratio;
exception
  when others then
    plog.error(dbms_utility.format_error_backtrace);
    return l_ratio;
end;
/

