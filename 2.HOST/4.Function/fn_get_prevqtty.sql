CREATE OR REPLACE FUNCTION fn_get_prevqtty
(
    p_accno         IN      VARCHAR2
)
RETURN NUMBER
IS
    l_prevqtty          NUMBER(20,4);

BEGIN
    SELECT se.trade INTO l_prevqtty FROM secostprice_prev se WHERE acctno = p_accno;
    RETURN l_prevqtty;

EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END;
/

