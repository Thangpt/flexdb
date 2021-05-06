CREATE OR REPLACE FUNCTION fnc_hft_get_avlbal_5540( pv_ACCTNO IN VARCHAR2)
    RETURN NUMBER IS
    v_Result number(20);
    v_fomode varchar2(10);
    v_isfo   varchar2(10);
BEGIN

   --Kiem tra neu fomode la off hoac afmast is fo =N thi tra ve 1 000 000 000 0000
   BEGIN
    SELECT s.varvalue INTO v_fomode FROM sysvar s WHERE s.varname ='FOMODE';
    SELECT a.isfo into v_isfo FROM afmast a WHERE a.acctno = pv_ACCTNO;
   EXCEPTION WHEN OTHERS THEN
     v_fomode:= 'OFF';
     v_isfo  := 'N';
   END;
   IF v_fomode= 'OFF' OR v_isfo ='N' THEN
     v_Result:= 10000000000000;
   ELSE

        SELECT trunc(bod_balance + bod_adv + calc_advbal) INTO v_result  FROM accounts@dbl_fo WHERE acctno = pv_acctno;
   END IF;
   RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/

