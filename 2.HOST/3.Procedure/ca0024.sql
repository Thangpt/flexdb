CREATE OR REPLACE PROCEDURE ca0024 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   CACODE         IN       VARCHAR2,
   I_BRIDGD       IN       VARCHAR2,
   ISCOREBANK     IN       VARCHAR2,
   CASHPLACE      IN       VARCHAR2
 )
IS
--
-- PURPOSE: BAO CAO DANH SACH NGUOI SO HUU CHUNG KHOAN LUU KY
-- MODIFICATION HISTORY
-- PERSON      DATE      COMMENTS
-- DIENT  04-01-2011   CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION         VARCHAR2  (5);
   V_STRBRID           VARCHAR2  (4);
   V_CACODE            VARCHAR2(100);
   V_CIROUND           NUMBER;
   V_I_BRIDGD          VARCHAR2(100);
   V_ISCOREBANK        VARCHAR2(10);
   V_CASHPLACE         VARCHAR2(100);

   V_BRNAME            NVARCHAR2(500);
   V_COREBANK_NAME     NVARCHAR2(100);
   V_CASHPLACE_NAME    NVARCHAR2(500);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
   IF (CACODE <> 'ALL' OR CACODE <> '')
   THEN
      V_CACODE :=  CACODE;
   ELSE
      V_CACODE := '%%';
   END IF;

   SELECT CIROUNDTYPE INTO V_CIROUND FROM CAMAST WHERE CAMASTID LIKE V_CACODE;

   IF (I_BRIDGD <> 'ALL' OR I_BRIDGD <> '')
   THEN
      V_I_BRIDGD :=  I_BRIDGD;
   ELSE
      V_I_BRIDGD := '%';
   END IF;

   IF (ISCOREBANK <> 'ALL' OR ISCOREBANK <> '')
   THEN
            V_ISCOREBANK :=  ISCOREBANK;
   ELSE
      V_ISCOREBANK := '%';
   END IF;

   IF (CASHPLACE <> 'ALL' OR CASHPLACE <> '')
   THEN
      V_CASHPLACE :=  CASHPLACE;
   ELSE
      V_CASHPLACE := '%';
   END IF;

   IF (I_BRIDGD <> 'ALL' OR I_BRIDGD <> '')
   THEN
      BEGIN
            SELECT BRNAME INTO V_BRNAME FROM BRGRP WHERE BRID LIKE I_BRIDGD;
      END;
   ELSE
      V_BRNAME   :=  'Toàn công ty';
   END IF;

   IF (ISCOREBANK <> 'ALL' OR ISCOREBANK <> '')
   THEN
        if (ISCOREBANK = 'Y') then
            V_COREBANK_NAME := 'Corebank';
        else
            V_COREBANK_NAME := 'T?i BVSC';
        end if;
   ELSE
      V_COREBANK_NAME   :=  'Toàn công ty';
   END IF;

   IF (CASHPLACE <> 'ALL' OR CASHPLACE <> '')
   THEN
      BEGIN
            SELECT CDCONTENT INTO V_CASHPLACE_NAME FROM ALLCODE WHERE CDTYPE = 'CF' AND CDNAME = 'BANKNAME' AND CDVAL LIKE CASHPLACE;
      END;

   ELSE
      V_CASHPLACE_NAME   :=  'All';

   END IF;

   -- GET REPORT'S DATA

OPEN PV_REFCURSOR
FOR
            SELECT max(ISS.FULLNAME) ISS_NAME, SB.SYMBOL, max(SB.PARVALUE) PARVALUE,
            'L?y ? ki?n c? d?b?ng van b?n' CADESC,
            max(MST.REPORTDATE) REPORTDATE,
            max(NVL(MST.EXRATE, 0))  PCENT, max(MST.REPORTDATE) FR_DATE, max(MST.ACTIONDATE) TO_DATE,
            /*
            max(CASE WHEN SUBSTR(CF.CUSTODYCD, 4, 1) = 'C' THEN 'I.  M? GI?I TRONG NU?C'
                  WHEN SUBSTR(CF.CUSTODYCD, 4, 1) = 'F'    THEN 'II. M? GI?I NU?C NGO?I'
                  WHEN SUBSTR(CF.CUSTODYCD, 4, 1) = 'P'    THEN 'III.T? DOANH' END) GR_I,
            */
            MAX(SUBSTR(CF.CUSTODYCD, 4, 1)) GR_I,
            /*
            max(CASE WHEN CF.CUSTTYPE =  'I'  THEN '1. C?h?
                  WHEN CF.CUSTTYPE =  'B'     THEN '2. T? ch?c' END) AFTYPE,
            */
            (case when CF.CUSTTYPE = 'I' then '1.' else '2.' end) || CF.CUSTTYPE AFTYPE,
            max(CF.CUSTID) CUSTID, max(CF.FULLNAME) FULLNAME,
            --max(CF.IDCODE) IDCODE,
            (case when max(cf.country) = '234' then max(cf.idcode) else max(cf.tradingcode) end) IDCODE,
            max(case when cf.country = '234' then cf.IDDATE else cf.tradingcodedt end)  IDDATE, max(CF.ADDRESS) ADDRESS,max(AL.CDCONTENT) COUNTRY_NAME,
            CF.CUSTODYCD, max(AF.ACCTNO) AFACCTNO,sum(CA.TRADE) TRADE ,SUM(CA.QTTY) QTTY,sum(CA.AMT) AMT,max(MST.EXPRICE) EXPRICE,round(sum(CA.AMT/MST.EXPRICE),V_CIROUND) LE
            , V_BRNAME BR_NAME, V_COREBANK_NAME COREBANK_NAME, V_CASHPLACE_NAME CASHPLACE_NAME
    FROM VW_CASCHD_ALL CA, AFMAST AF, CFMAST CF, ALLCODE AL, SBSECURITIES SB, ISSUERS ISS, AFTYPE AFT, VW_CAMAST_ALL MST
    WHERE CA.AFACCTNO    = AF.ACCTNO
    AND   AF.CUSTID      = CF.CUSTID
    AND   CF.COUNTRY     = AL.CDVAL
    AND   AL.CDNAME      = 'COUNTRY'
    AND   MST.CODEID      = SB.CODEID
    AND   SB.ISSUERID    = ISS.ISSUERID
    AND   MST.CATYPE='017'
    AND   CA.DELTD       <>'Y'
    AND   CA.CAMASTID   =  MST.CAMASTID
    AND   CA.CAMASTID   LIKE V_CACODE
    AND   AF.ACTYPE     =  AFT.ACTYPE
    AND   AFT.COREBANK  LIKE V_ISCOREBANK
    AND   AF.BANKNAME   LIKE V_CASHPLACE
    Group by SYMBOL,CUSTODYCD, CF.CUSTTYPE
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

