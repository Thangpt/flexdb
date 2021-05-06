CREATE OR REPLACE PROCEDURE se0020 (
       PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
       OPT            IN       VARCHAR2,
       BRID           IN       VARCHAR2,
       I_DATE         IN       VARCHAR2,
       PLSENT         IN       VARCHAR2
)
IS

-- PURPOSE:
-- B?O C?O V? T?H H?H S? H?U CH?NG KHO?N LUU K?C?A NH? ?U TU NU?C NGO?I
-- PERSON               DATE                COMMENTS
-- ---------------      ----------          ----------------------
-- QUOCTA               15/02/2012          SUA THEO YC BVS
-- ---------------      ----------          ----------------------

  V_STROPTION           VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_STRBRID             VARCHAR2 (4);

  V_IN_DATE             DATE;
  V_CURR_DATE           DATE;


BEGIN

    V_STROPTION := OPT;

    IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
    THEN
         V_STRBRID := BRID;
    ELSE
         V_STRBRID := '%%';
    END IF;

    V_IN_DATE := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    SELECT TO_DATE(SY.VARVALUE, SYSTEMNUMS.C_DATE_FORMAT) INTO V_CURR_DATE
    FROM SYSVAR SY WHERE SY.VARNAME = 'CURRDATE' AND SY.GRNAME = 'SYSTEM';

-- MAIN REPORT
OPEN PV_REFCURSOR FOR
SELECT  max(CASE WHEN SB.SECTYPE IN ('001','011') THEN ' I. CỔ PHIẾU '
              WHEN SB.SECTYPE in ('003','006') THEN ' II. TRÁI PHIẾU '
              WHEN SB.SECTYPE = '008' THEN ' III. CHỨNG CHỈ QUỸ ' END) GR_I,
        max(CASE WHEN SB.TRADEPLACE = '001' THEN ' 2. Niêm yết tại HOSE '
              WHEN SB.TRADEPLACE = '002' THEN ' 1. Niêm yết tại HNX '
              ELSE ' 3. UPCOM ' END) GR_II,
        SB.SYMBOL,  (CF.CUSTODYCD || ' : ' || CF.FULLNAME) CUST_FULLNAME,
        max(CASE WHEN CF.CUSTTYPE = 'B' THEN ' 2 '
              ELSE ' 1 ' END) CUSTTYPE_NAME,
        (CASE WHEN CF.country = '234' THEN CF.idcode ELSE CF.tradingcode END) IDCODE,
        SUM(MST.TOTAL_AMT) TOTAL_AMT , PLSENT PLSENT, V_IN_DATE DATE_TRANS
FROM
        (
        SELECT CRR.CUSTODYCD, CRR.CODEID, (NVL(CRR.CRR_TOTAL_TRANS, 0) - NVL(MST.MST_TOTAL_TRANS, 0)) TOTAL_AMT
        FROM
        --- SO DU SO HUU HIEN TAI
        (SELECT  CF.CUSTODYCD, SE.CODEID,
            SUM(SE.TRADE + SE.MORTAGE + SE.BLOCKED + SE.NETTING + SE.WTRADE) CRR_TOTAL_TRANS
         FROM     SEMAST SE, CFMAST CF, AFMAST AF
         WHERE    SE.AFACCTNO       =   AF.ACCTNO
         AND      CF.CUSTID         =   AF.CUSTID
         --- AND      cf.COUNTRY <> '234' ---
         and TRIM(SUBSTR(CF.CUSTODYCD, 4, 1)) = 'F'
         and cf.custatcom = 'Y'
         GROUP BY CF.CUSTODYCD, SE.CODEID
         ) CRR
        LEFT JOIN
        --- LAY CAC PHAT SINH TU NGAY IN_DATE + 1 DEN NGAY HIEN TAI
        (SELECT MT.custodycd, MT.codeid,
                (ROUND(SUM(CASE WHEN MT.FIELD = 'TRADE' THEN (CASE WHEN MT.TXTYPE = 'D' THEN -MT.NAMT ELSE MT.NAMT END)
                                ELSE 0 END)) +        -- SO DU DAT LENH
                ROUND(SUM(CASE WHEN MT.FIELD = 'MORTAGE' THEN (CASE WHEN MT.TXTYPE = 'D' THEN -MT.NAMT ELSE MT.NAMT END)
                                ELSE 0 END)) +        -- SO DU CAM CO
                ROUND(SUM(CASE WHEN MT.FIELD = 'BLOCKED' THEN (CASE WHEN MT.TXTYPE = 'D' THEN -MT.NAMT ELSE MT.NAMT END)
                                ELSE 0 END)) +        -- SO DU PHONG TOA
                ROUND(SUM(CASE WHEN MT.FIELD = 'NETTING' THEN (CASE WHEN MT.TXTYPE = 'D' THEN -MT.NAMT ELSE MT.NAMT END)
                                ELSE 0 END)) +        -- SO DU CHO GIAO
                ROUND(SUM(CASE WHEN MT.FIELD = 'WTRADE' THEN (CASE WHEN MT.TXTYPE = 'D' THEN -MT.NAMT ELSE MT.NAMT END)
                                ELSE 0 END))
                ) MST_TOTAL_TRANS                     -- TONG CAC PHAT SINH SO DU
         FROM   VW_SETRAN_GEN MT, cfmast cf
         WHERE  MT.deltd      <>   'Y'
         AND    MT.busdate    >    V_IN_DATE
         AND    MT.busdate    <=   V_CURR_DATE
         AND    MT.namt       >    0
         and mt.CUSTODYCD =  cf.CUSTODYCD
         AND    MT.field      IN   ('TRADE', 'MORTAGE', 'BLOCKED', 'NETTING', 'WTRADE')
----         AND    cf.COUNTRY <> '234' ---
         and TRIM(SUBSTR(MT.CUSTODYCD, 4, 1)) = 'F'
         and cf.custatcom = 'Y'
         GROUP BY MT.custodycd, MT.codeid
         ) MST ON CRR.CUSTODYCD   =   MST.CUSTODYCD AND CRR.CODEID = MST.CODEID
    ) MST,  (select NVL(SB1.TRADEPLACE,SB.TRADEPLACE) TRADEPLACE, NVL(SB.SECTYPE,SB1.SECTYPE) SECTYPE ,SB.CODEID,
    nvl(sb1.symbol,sb.symbol) symbol, nvl(sb1.CODEID,sb.CODEID) REFCODEID
from sbsecurities sb, sbsecurities sb1
where nvl(sb.refcodeid,' ') = sb1.codeid(+) ) SB
---sbsecurities SB
, CFMAST CF
WHERE    TRIM(SUBSTR(MST.CUSTODYCD, 4, 1)) = 'F'
    AND      MST.CUSTODYCD =  CF.CUSTODYCD
    AND      MST.CODEID    =  SB.CODEID
    AND      SB.SECTYPE    IN ('001', '006','003', '008','011')
    AND      SB.TRADEPLACE IN ('001', '002', '005')
    AND      MST.TOTAL_AMT > 0
    GROUP BY SB.SYMBOL,  (CF.CUSTODYCD || ' : ' || CF.FULLNAME) , (CASE WHEN CF.country = '234' THEN CF.idcode ELSE CF.tradingcode END)

union all
select ' I. CỔ PHIẾU ' GR_I, ' 1. Niêm yết tại HNX ' GR_II,
    NULL SYMBOL, NULL CUST_FULLNAME, NULL CUSTTYPE_NAME,
    null IDCODE, 0 TOTAL_AMT , PLSENT PLSENT, V_IN_DATE DATE_TRANS
from dual
union all
select ' I. CỔ PHIẾU ' GR_I, ' 2. Niêm yết tại HOSE ' GR_II,
        NULL SYMBOL, NULL CUST_FULLNAME, NULL CUSTTYPE_NAME,
    null IDCODE, 0 TOTAL_AMT , PLSENT PLSENT, V_IN_DATE DATE_TRANS
from dual
union all
select ' I. CỔ PHIẾU ' GR_I, ' 3. UPCOM ' GR_II,
    NULL SYMBOL, NULL CUST_FULLNAME, NULL CUSTTYPE_NAME,
    null IDCODE, 0 TOTAL_AMT , PLSENT PLSENT, V_IN_DATE DATE_TRANS
from dual

union all
select ' II. TRÁI PHIẾU ' GR_I, ' 1. Niêm yết tại HNX ' GR_II,
    NULL SYMBOL, NULL CUST_FULLNAME, NULL CUSTTYPE_NAME,
    null IDCODE, 0 TOTAL_AMT , PLSENT PLSENT, V_IN_DATE DATE_TRANS
from dual
union all
select ' II. TRÁI PHIẾU ' GR_I, ' 2. Niêm yết tại HOSE ' GR_II,
        NULL SYMBOL, NULL CUST_FULLNAME, NULL CUSTTYPE_NAME,
    null IDCODE, 0 TOTAL_AMT , PLSENT PLSENT, V_IN_DATE DATE_TRANS
from dual
union all
select ' II. TRÁI PHIẾU ' GR_I, ' 3. UPCOM 'GR_II,
    NULL SYMBOL, NULL CUST_FULLNAME, NULL CUSTTYPE_NAME,
    null IDCODE, 0 TOTAL_AMT , PLSENT PLSENT, V_IN_DATE DATE_TRANS
from dual

union all
select ' III. CHỨNG CHỈ QUỸ ' GR_I, ' 1. Niêm yết tại HNX ' GR_II,
    NULL SYMBOL, NULL CUST_FULLNAME, NULL CUSTTYPE_NAME,
    null IDCODE, 0 TOTAL_AMT , PLSENT PLSENT, V_IN_DATE DATE_TRANS
from dual
union all
select ' III. CHỨNG CHỈ QUỸ ' GR_I, ' 2. Niêm yết tại HOSE ' GR_II,
        NULL SYMBOL, NULL CUST_FULLNAME, NULL CUSTTYPE_NAME,
    null IDCODE, 0 TOTAL_AMT , PLSENT PLSENT, V_IN_DATE DATE_TRANS
from dual
union all
select ' III. CHỨNG CHỈ QUỸ ' GR_I, ' 3. UPCOM 'GR_II,
    NULL SYMBOL, NULL CUST_FULLNAME, NULL CUSTTYPE_NAME,
    null IDCODE, 0 TOTAL_AMT , PLSENT PLSENT, V_IN_DATE DATE_TRANS
from dual

;


EXCEPTION
   WHEN OTHERS THEN
      RETURN;
END;



-- End of DDL Script for Procedure HOST.SE0020

 
/
