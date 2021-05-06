CREATE OR REPLACE FUNCTION fn_getfee_bankid(PV_BANKID IN VARCHAR2, pv_amt in varchar2)
    RETURN VARCHAR2 IS
    V_RESULT VARCHAR2(10);
    v_amt number;

BEGIN
v_amt:= to_number(pv_amt);
SELECT CASE WHEN SUBSTR(PV_BANKID,1,3) in ('202','302','309') THEN '00016' -- 1.8.2.1: chinh sua loai bieu phi
            ELSE ( case when v_amt < 500000000 then '00017'
                        else '20000'
                    end  )
       END INTO V_RESULT FROM DUAL;

RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/

