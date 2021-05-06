CREATE OR REPLACE FUNCTION FN_GEN_DESC_1201(P_CUSTODYCD    VARCHAR2,
                                            P_FULLNAME     VARCHAR2,
                                            P_AFACCTNO     VARCHAR2)
  RETURN STRING IS
  V_DESC      VARCHAR2(500);
  V_CUSTODYCD VARCHAR2(500);
  V_FULLNAME  VARCHAR2(500);
  V_PRODTYPE  VARCHAR2(10);
BEGIN

  V_CUSTODYCD := NVL(P_CUSTODYCD, '');
  V_FULLNAME  := NVL(P_FULLNAME, '');
  
  SELECT aft.prodtype INTO V_PRODTYPE FROM afmast af, aftype aft WHERE af.actype = aft.actype AND af.acctno =P_AFACCTNO;

  IF LENGTH(REPLACE(V_CUSTODYCD, '.', '')) = 10 AND LENGTH(V_FULLNAME) > 0 THEN
    V_DESC := 'IAC '|| V_CUSTODYCD ||'  '|| V_FULLNAME ||'  '|| V_CUSTODYCD ||V_PRODTYPE||'' ;
  END IF;

  RETURN V_DESC;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'IAC Chuyen khoan noi bo';
END;
/
