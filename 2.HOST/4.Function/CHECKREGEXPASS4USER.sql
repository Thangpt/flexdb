CREATE OR REPLACE FUNCTION CHECKREGEXPASS4USER( f_password IN  varchar )
RETURN  number IS
v_Return Number;
v_strRegEx varchar2(1000);
v_length number;
v_check varchar2(500);
BEGIN
  v_Return := 0;
  -- lay chuoi xac thuc. Neu khong co --> khong check
  begin
    SELECT VARVALUE INTO v_strRegEx  FROM SYSVAR WHERE VARNAME = 'REGEXPASS4USER' AND GRNAME ='SYSTEM';
  exception 
    when others THEN
    RETURN 0;
  end;
  -- NEU CHUOI XAC THUC TRONG --> KHONG CHECK
  IF( LENGTH(v_strRegEx) = 0) THEN
   RETURN 0;
  END IF;
  -- CHECK DO DAI, KY TU DAU TIEN CUA CHUOI
  begin
  v_length := TO_NUMBER(SUBSTR(v_strRegEx, 1, INSTR(v_strRegEx, '##') -1 )) ;
  -- LAY CHUOI DA LOAI BO DO DAI DE CHECK f_password PHAI BAO GOM
  v_strRegEx := SUBSTR (v_strRegEx, INSTR(v_strRegEx, '##') +2); 
  exception 
    when others THEN
    v_length :=  0;
  end;
  IF( LENGTH(f_password)< v_length) THEN 
   RETURN -1; -- mã lỗi
  END IF;
  -- check chuoi phai chua cac ky tu theo chuoi regex
   WHILE LENGTH(v_strRegEx) > 0
   LOOP
      v_check := '^.*'||SUBSTR(v_strRegEx, 1, INSTR(v_strRegEx, '##') -1 )||'.*$' ;  -- examp: '^.*[A-Z].*$'
      if regexp_like(f_password,v_check) then 
        v_strRegEx := SUBSTR (v_strRegEx, INSTR(v_strRegEx, '##') +2); 
      else
        v_Return := -1; -- ma loi
        exit;
      end if;     
   END LOOP;
 Return v_Return;
 EXCEPTION WHEN OTHERS THEN
   RETURN -1; -- ma loi
END;
/
