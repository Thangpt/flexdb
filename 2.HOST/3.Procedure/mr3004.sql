CREATE OR REPLACE PROCEDURE mr3004 (
       PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
       OPT            IN       VARCHAR2,
       BRID           IN       VARCHAR2,
       I_DATE         IN       VARCHAR2,
       TRADEPLACE     IN       VARCHAR2,
       ACTYPE         IN       VARCHAR2,
       PLSENT         IN       VARCHAR2
)
IS

-- PURPOSE:
-- BAO CAO DANH SACH TAI SAN DAM BAO MARGIN
-- PERSON               DATE                COMMENTS
-- ---------------      ----------          ----------------------
-- QUOCTA               18/02/2012          TAO MOI
-- ---------------      ----------          ----------------------

  V_STROPTION           VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_STRBRID             VARCHAR2 (4);

  V_IN_DATE             DATE;
  V_TRADEPLACE          VARCHAR2 (100);
  V_ACTYPE              VARCHAR2 (100);
  V_PLSENT              VARCHAR2 (100);

BEGIN

    V_STROPTION := OPT;

    IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
    THEN
         V_STRBRID := BRID;
    ELSE
         V_STRBRID := '%%';
    END IF;

    V_IN_DATE := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    IF (TRADEPLACE <> 'ALL' OR TRADEPLACE <> '' OR TRADEPLACE <> NULL) THEN
       V_TRADEPLACE  :=    TRADEPLACE;
    ELSE
       V_TRADEPLACE  :=    '%';
    END IF;

    IF (ACTYPE <> 'ALL' OR ACTYPE <> '' OR ACTYPE <> NULL) THEN
       V_ACTYPE  :=    ACTYPE;
    ELSE
       V_ACTYPE  :=    '%';
    END IF;

    V_PLSENT     := UPPER(PLSENT);

IF (V_PLSENT = '1') THEN

   OPEN PV_REFCURSOR
   FOR
     SELECT SB.CODEID, SB.SYMBOL, A1.CDCONTENT TRADEPLACE, SE.TRADE SE_TRADE, MS.PRINUSED PRINUSED, V_IN_DATE DATE_TRANS
     FROM  SBSECURITIES SB, ALLCODE A1,
      (SELECT SE.CODEID, SUM(SE.TRADE + SE.MORTAGE + SE.BLOCKED + SE.NETTING + SE.WTRADE) TRADE
      FROM   SEMAST SE, AFMAST AF, AFTYPE AFT
      WHERE  SE.AFACCTNO = AF.ACCTNO
      AND    AF.ACTYPE   = AFT.ACTYPE
      AND    AFT.ACTYPE  LIKE V_ACTYPE
      GROUP BY SE.CODEID
      ) SE,
      (SELECT MST.CODEID, SUM(PRINUSED) PRINUSED
      FROM
          (
          SELECT  cf.custodycd, AFACCTNO, SB.SYMBOL, SB.CODEID, C1.cdcontent ALLOCTYP,
          SUM(case when AFPR.restype = 'M' then PRINUSED else 0 end) PRINUSED,
          SUM(case when AFPR.restype = 'S' then PRINUSED else 0 end) SYPRINUSED
          FROM vw_afpralloc_all AFPR, ALLCODE C1, sbsecurities SB, afmast af, cfmast cf
          where AFPR.alloctyp = C1.cdval and C1.cdtype = 'PR' and C1.cdname = 'ALLOCTYP'
          and SB.codeid = afpr.codeid and AFPR.afacctno = af.acctno and af.custid = cf.custid
          AND AF.ACTYPE LIKE V_ACTYPE
          GROUP BY  AFACCTNO, SB.SYMBOL, SB.CODEID, cf.custodycd, C1.cdcontent
          ORDER BY  AFACCTNO,cf.custodycd, CODEID
          ) MST
      WHERE  0 = 0
      GROUP BY MST.CODEID
      ) MS
    WHERE SB.CODEID      =      SE.CODEID
    AND   SB.CODEID      =      MS.CODEID
    AND   SB.TRADEPLACE  =      A1.CDVAL
    AND   A1.CDNAME      =      'TRADEPLACE'
    AND   A1.CDTYPE      =      'SE'
    AND   SB.TRADEPLACE  LIKE   V_TRADEPLACE
    order by sb.tradeplace,sb.symbol
   ;

ELSE

   OPEN PV_REFCURSOR
   FOR
     SELECT SB.CODEID, SB.SYMBOL, A1.CDCONTENT TRADEPLACE, NVL(SE.TRADE, 0) SE_TRADE, NVL(MS.PRINUSED, 0) PRINUSED, V_IN_DATE DATE_TRANS
     FROM  SBSECURITIES SB, ALLCODE A1,
      (SELECT SE.CODEID, SUM(SE.TRADE + SE.MORTAGE + SE.BLOCKED + SE.NETTING + SE.WTRADE) TRADE
      FROM   SEMAST SE, AFMAST AF, AFTYPE AFT
      WHERE  SE.AFACCTNO = AF.ACCTNO
      AND    AF.ACTYPE   = AFT.ACTYPE
      AND    AFT.ACTYPE  LIKE V_ACTYPE
      GROUP BY SE.CODEID
      ) SE,
      (SELECT MST.CODEID, SUM(PRINUSED) PRINUSED
      FROM
          (
          SELECT  cf.custodycd, AFACCTNO, SB.SYMBOL, SB.CODEID, C1.cdcontent ALLOCTYP,
          SUM(case when AFPR.restype = 'M' then PRINUSED else 0 end) PRINUSED,
          SUM(case when AFPR.restype = 'S' then PRINUSED else 0 end) SYPRINUSED
          FROM vw_afpralloc_all AFPR, ALLCODE C1, sbsecurities SB, afmast af, cfmast cf
          where AFPR.alloctyp = C1.cdval and C1.cdtype = 'PR' and C1.cdname = 'ALLOCTYP'
          and SB.codeid = afpr.codeid and AFPR.afacctno = af.acctno and af.custid = cf.custid
          AND AF.ACTYPE LIKE V_ACTYPE
          GROUP BY  AFACCTNO, SB.SYMBOL, SB.CODEID, cf.custodycd, C1.cdcontent
          ORDER BY  AFACCTNO,cf.custodycd, CODEID
          ) MST
      WHERE  0 = 0
      GROUP BY MST.CODEID
      ) MS
    WHERE SB.CODEID      =      SE.CODEID (+)
    AND   SB.CODEID      =      MS.CODEID (+)
    AND   SB.TRADEPLACE  =      A1.CDVAL
    AND   A1.CDNAME      =      'TRADEPLACE'
    AND   A1.CDTYPE      =      'SE'
    AND   SB.TRADEPLACE  LIKE   V_TRADEPLACE
    order by sb.tradeplace,sb.symbol
   ;

END IF;

EXCEPTION
   WHEN OTHERS THEN
      RETURN;
END;
/

