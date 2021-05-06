CREATE OR REPLACE FUNCTION fnc_fo_getwithdrawnormal(v_acctno varchar2)
RETURN NUMBER  AS
 v_ISFO varchar2(10);
 v_Result number(20,2) := NULL;
BEGIN
    RETURN CSPKS_FO_ACCOUNT.fn_get_withdraw@DBL_FO(v_acctno);
EXCEPTION WHEN OTHERS THEN
    RETURN v_Result;
END;
/
