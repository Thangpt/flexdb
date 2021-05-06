CREATE OR REPLACE FUNCTION fn_checkMAS10Regist(p_afacctno  IN VARCHAR2, p_isNormalSbTypeReq  IN VARCHAR2)
RETURN VARCHAR2
IS
l_return    VARCHAR2(10) := 'N';
BEGIN
  IF p_isNormalSbTypeReq = 'Y' THEN
    SELECT DECODE(COUNT(1), 0, 'N', 'Y') INTO l_return
    FROM registerproduc r
    WHERE r.afacctno = p_afacctno
    AND r.produccode = 'MAS10'
    AND r.sbtype = 'N';
  ELSE
    SELECT DECODE(COUNT(1), 0, 'N', 'Y') INTO l_return
    FROM registerproduc r
    WHERE r.afacctno = p_afacctno
    AND r.produccode = 'MAS10';
  END IF;
  RETURN l_return;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'N';
END;
/
