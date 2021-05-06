CREATE OR REPLACE FUNCTION fnc_fo_getwithdrawpp (v_acctno varchar2)
RETURN NUMBER  AS
 v_ISFO varchar2(10);
 v_Result number(20,2);
BEGIN


    begin
        SELECT NVL(ISFO,'N') INTO v_ISFO FROM afmast WHERE acctno = v_acctno AND ISFO = 'Y' AND EXISTS (SELECT varname FROM sysvar WHERE varname = 'FOMODE' AND varvalue = 'ON');
    EXCEPTION WHEN OTHERS THEN
        v_ISFO:='N';
    END;

    IF v_ISFO = 'Y' THEN
        v_Result :=CSPKS_FO_ACCOUNT.fn_get_withdraw_PP@DBL_FO(v_acctno);
    ELSE
        v_Result := 1000000000000;

    END IF;
    RETURN NVL(v_Result,0);
EXCEPTION WHEN OTHERS THEN
   RETURN 0;
END;
/

