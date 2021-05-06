CREATE OR REPLACE FUNCTION fn_getfowithdraw
  ( v_acctno IN varchar2)
  RETURN  NUMBER IS
  v_FOwithdraw NUMBER;
  v_ISFO VARCHAR2(5);


BEGIN
    SELECT NVL(ISFO,'N') INTO v_ISFO FROM afmast WHERE acctno = v_acctno AND ISFO = 'Y' AND EXISTS (SELECT varname FROM sysvar WHERE varname = 'FOMODE' AND varvalue = 'ON');
    IF v_ISFO = 'Y' THEN
        v_FOwithdraw :=CSPKS_FO_ACCOUNT.fn_get_withdraw@DBL_FO(v_acctno);
    ELSE
        v_FOwithdraw := 9999999999999;
    END IF;

    RETURN v_FOwithdraw ;
EXCEPTION
   WHEN OTHERS THEN
   dbms_output.put_line('err'||sqlerrm);
    RETURN 9899999999999;
END;
/

