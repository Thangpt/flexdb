CREATE OR REPLACE FUNCTION fnc_fo_getcash4paymentdebt (v_acctno varchar2)
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
        v_Result :=CSPKS_FO_ACCOUNT.fn_get_cash4DebtPayment@DBL_FO(v_acctno);
    ELSE
        v_Result := 1000000000000;

    END IF;
    RETURN v_Result;
EXCEPTION WHEN OTHERS THEN
    RETURN  1000000000001;
END;
/

