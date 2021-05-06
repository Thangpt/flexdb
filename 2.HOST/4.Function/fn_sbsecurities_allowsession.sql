CREATE OR REPLACE FUNCTION FN_SBSECURITIES_ALLOWSESSION(pv_TRADEPLACE IN VARCHAR2,pv_ALLOWSESSION VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(10);

BEGIN
    if(pv_TRADEPLACE <>'001') THEN
        v_Result:='AL';
    ELSE
        v_Result:=pv_ALLOWSESSION;
    END IF;

    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 'AL';
END;
/

