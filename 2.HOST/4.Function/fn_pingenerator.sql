create or replace function fn_pingenerator return varchar2
IS
    l_Password   sysvar.varvalue%TYPE;
BEGIN
    Select to_char(round(dbms_random.value(10000,99999))) str INTO l_Password from dual;
      RETURN l_Password;

END;                                                              -- PROCEDURE
/

