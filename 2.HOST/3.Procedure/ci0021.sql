CREATE OR REPLACE PROCEDURE CI0021 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD_EX         IN       VARCHAR2
)
IS

  V_STROPTION            VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_STRBRID              VARCHAR2 (4);
  V_FRDATE              DATE;
  V_TODATE              DATE;
  v_custodycd           varchar2(10);


BEGIN
    V_STROPTION := OPT;

    V_FRDATE:= to_date(F_DATE,'DD/MM/RRRR');
    V_TODATE:= to_date(T_DATE,'DD/MM/RRRR');

    IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID := BRID;
    END IF;

    IF CUSTODYCD_EX = 'ALL' OR CUSTODYCD_EX IS NULL  OR CUSTODYCD_EX = '' THEN
        v_custodycd := '%%';
    ELSE
        v_custodycd := CUSTODYCD_EX;
    END IF;

-- Main report
    OPEN PV_REFCURSOR FOR

    SELECT tg.tltxcd,cf.custodycd,ci.* FROM cicustwithdraw ci, vw_tllog_all tg, cfmast cf, afmast af
    WHERE ci.txnum = tg.txnum AND ci.txdate = tg.txdate AND af.acctno = ci.afacctno AND af.custid = cf.custid
    AND ci.REF IS NOT NULL AND cf.custodycd LIKE v_custodycd
    AND ci.txdate BETWEEN V_FRDATE AND V_TODATE
    order BY ci.autoid;

EXCEPTION
   WHEN OTHERS THEN
      RETURN;
END;
/

