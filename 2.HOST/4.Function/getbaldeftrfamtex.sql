CREATE OR REPLACE FUNCTION getbaldeftrfamtex (
        p_afacctno IN VARCHAR2)
RETURN NUMBER
  IS
    l_BALDEFTRFAMTEX NUMBER(20,2);
    l_cimastcheck_arr txpks_check.cimastcheck_arrtype;
BEGIN
     l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(p_afacctno,'CIMAST','ACCTNO');
     l_BALDEFTRFAMTEX := l_CIMASTcheck_arr(0).BALDEFTRFAMTEX;
     l_BALDEFTRFAMTEX :=least(l_BALDEFTRFAMTEX,fnc_fo_getwithdraw(p_afacctno));
RETURN l_BALDEFTRFAMTEX;
EXCEPTION WHEN others THEN
    --plog.error(dbms_utility.format_error_backtrace);
    return 0;
END;
/

