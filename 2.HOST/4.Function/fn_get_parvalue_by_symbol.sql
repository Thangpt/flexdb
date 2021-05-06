CREATE OR REPLACE FUNCTION fn_get_parvalue_by_symbol(pv_symbol IN varchar2)
RETURN number IS
v_symbol VARCHAR2(20);
v_dblResult number;
BEGIN
    v_symbol := upper(pv_symbol);
    BEGIN
        SELECT to_number(s.parvalue) INTO v_dblResult FROM sbsecurities s WHERE s.symbol = v_symbol;
    EXCEPTION WHEN OTHERS THEN
        v_dblResult := 0;
    END;
    RETURN v_dblResult;
EXCEPTION WHEN OTHERS THEN
    RETURN 0;
END;
/

