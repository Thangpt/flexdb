CREATE OR REPLACE FUNCTION fn_get_bankid(pv_bankorgid In VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(250);

BEGIN
   SELECT bank_no||'.'||sb_branch_code INTO v_Result FROM bank_branch_info WHERE bank_no||org_no= replace(pv_bankorgid,'.','');

    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/

