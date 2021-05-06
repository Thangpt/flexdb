create or replace function check_email(p_email varchar2) return varchar2 is
    l_is_email_valid boolean;
--p_email varchar2(100) := 'maihoa0210@gmail.c?m';
  begin

    if owa_pattern.match(p_email,
                         '^\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}' ||
                         '@\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}$') then
      --dbms_output.put_line('true');
      return '0';
    else
     -- dbms_output.put_line('false');
     return '-1';
    end if;
    
  exception
    when others then
 return '-1';
  end;
/

