CREATE OR REPLACE FUNCTION fn_getworkday( FDATE IN DATE)
  RETURN number IS
    v_Result number(18,5);
BEGIN
       If FDATE is null then
        Return 0;
    end if;
    SELECT GREATEST( 1-  numday,0) INTO  v_Result  FROM SBCURRDATE
    WHERE  SBDATE = FDATE and sbtype ='B';
    RETURN v_Result;
EXCEPTION WHEN OTHERS THEN
    SELECT GREATEST( 1- max( numday),0) INTO  v_Result  FROM SBCURRDATE
    WHERE  SBDATE <= FDATE and sbtype ='B';
    RETURN v_Result;
END;
/

