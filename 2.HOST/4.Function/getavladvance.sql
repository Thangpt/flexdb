CREATE OR REPLACE FUNCTION getavladvance(p_afacctno IN VARCHAR2)
RETURN NUMBER
  IS
    l_avladvance NUMBER(20,2);
BEGIN
     SELECT NVL(sum(maxavlamt),0) INTO l_avladvance
     from vw_advanceschedule
     WHERE acctno=p_afacctno;

RETURN l_avladvance;
EXCEPTION WHEN others THEN
    --plog.error(dbms_utility.format_error_backtrace);
    return 0;
END;
/
