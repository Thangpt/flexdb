CREATE OR REPLACE FUNCTION fnc_isAdvOrd(v_Orderid IN varchar2)
RETURN varchar2 IS
v_Result varchar2(100);
BEGIN
  SELECT varvalue INTO v_Result FROM sysvar WHERE varname ='FOMODE';
  
  IF  v_Result = 'ON' THEN
    RETURN fnc_isAdvOrd@dbl_fo(v_Orderid);
    
  ELSE 
    RETURN ' ';  
  END IF;  

EXCEPTION WHEN OTHERS THEN
  RETURN ' ';
END;
/

