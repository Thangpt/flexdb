CREATE OR REPLACE FUNCTION fn_getsepitbo_max(p_ACCTNO IN VARCHAR2,p_QTTY IN NUMBER,p_TYPE IN NUMBER)
RETURN NUMBER
IS
v_pitqtty_max NUMBER(20);
v_taxrate NUMBER(20,2);
v_return NUMBER;
v_custid VARCHAR2(10);
v_codeid VARCHAR2(10);
BEGIN
  SELECT custid INTO v_custid FROM afmast WHERE acctno=substr(p_ACCTNO,1,10);
  v_codeid := substr(p_ACCTNO,11);
  
  SELECT NVL(SUM(qtty - mapqtty),0) pitqtty, NVL(MAX(pitrate),0) taxrate
    INTO v_pitqtty_max,v_taxrate
    FROM sepitlog se, afmast af
    WHERE se.afacctno = af.acctno
    AND af.custid = v_custid
    AND se.codeid = v_codeid
    AND se.deltd <> 'Y'
    AND se.qtty - se.mapqtty > 0;

  IF p_TYPE=0 THEN
    v_return := least(v_pitqtty_max,p_QTTY);
  ELSE
    v_return := v_taxrate;
  END IF;

  RETURN v_return;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
