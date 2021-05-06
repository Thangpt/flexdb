CREATE OR REPLACE FUNCTION getbaldeftrfamt (
        p_afacctno IN VARCHAR2)
RETURN NUMBER
  IS
    l_BALDEFTRFAMT NUMBER(20,2);
    l_cimastcheck_arr txpks_check.cimastcheck_arrtype;
BEGIN
     l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(p_afacctno,'CIMAST','ACCTNO');
     l_BALDEFTRFAMT := l_CIMASTcheck_arr(0).BALDEFTRFAMT;
     l_BALDEFTRFAMT :=least(l_BALDEFTRFAMT,fnc_fo_getwithdraw(p_afacctno));
RETURN l_BALDEFTRFAMT;
EXCEPTION WHEN others THEN
    --plog.error(dbms_utility.format_error_backtrace);
    return 0;
END;
/

