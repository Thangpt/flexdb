CREATE OR REPLACE FUNCTION fn_check_clearday_sec2(pv_clearday in number)
--T10/2015 TTBT T+2:
--Ham check Chu ky thanh toan tren man hinh OD co khac Chu ky TT tren sysvar khong
--Neu co tra ve True, neu ko tra ve False
    RETURN varchar2 IS
    v_Result  varchar2(5);
    v_codeid varchar2(10);
    v_sectype varchar2(5);
    v_clearday number;
    v_sysclearday number;
    v_sybol_sectype varchar2(5);
BEGIN
    v_clearday := pv_clearday;

    SELECT TO_NUMBER(NVL(MAX(VARVALUE),'0')) INTO V_SYSCLEARDAY FROM SYSVAR WHERE GRNAME LIKE 'OD' AND VARNAME='CLEARDAY' ;
    IF (v_clearday > v_sysclearday) THEN
            v_result := 'False';
          ELSE
            v_result := 'True' ;
          END IF;


    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 'False';
END;
/

