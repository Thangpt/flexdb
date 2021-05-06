CREATE OR REPLACE PROCEDURE se0043 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PLSENT         IN       VARCHAR2
)
IS

-- RP NAME : YEU CAU CHUYEN KHOAN CHUNG KHOAN TAT TOAN TAI KHOAN
-- PERSON --------------DATE---------------------COMMENTS
-- THANHNM            17/07/2012                 CREATE
-- SE00310: report main
-- ---------   ------  -------------------------------------------
   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_CURRDATE DATE;
   V_STRFULLNAME  VARCHAR2(200);
   V_STR_TVLK_CODE  VARCHAR2(10);
   V_STR_TVLK_NAME  VARCHAR2(200);
   V_STR_CUSTODYCD_NHAN  VARCHAR2(10);
   V_STR_NAME_NHAN   varchar(100);
   CUR            PKG_REPORT.REF_CURSOR;

BEGIN
-- GET REPORT'S PARAMETERS
    V_CUSTODYCD := UPPER( PV_CUSTODYCD);
    V_STR_TVLK_NAME :=' ';
    V_STR_TVLK_CODE :=' ';
    V_STRFULLNAME :=' ';


    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE
     FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM';

   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
         V_STRAFACCTNO := '%';
   END IF;

  SELECT FULLNAME INTO V_STRFULLNAME FROM CFMAST WHERE custodycd = V_CUSTODYCD;

 --LAY THONG TIN CHINH
 OPEN CUR
 FOR
       SELECT NVL(DP.FULLNAME,' '), NVL(DT.BANK,' ') ,NVL(DT.RECEIVCUSTODYCD,' '), NVL(DT.RECEIVNAME,' ')
    FROM DEPOSIT_MEMBER DP, (
    SELECT MAX(outward)   BANK,
           MAX(recustodycd )  RECEIVCUSTODYCD,
           max(recustname)  RECEIVNAME
       FROM sesendout se, afmast af, cfmast cf
    WHERE  DELTD='N' and af.custid = cf.custid and substr(se.acctno,1,10) = af.acctno
       AND cf.custodycd = V_CUSTODYCD
       and af.acctno like V_STRAFACCTNO
       AND TXDATE >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
       AND TXDATE <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
        ) DT
    WHERE   DP.DEPOSITID  = DT.BANK;

LOOP
  FETCH CUR
       INTO V_STR_TVLK_NAME ,V_STR_TVLK_CODE,V_STR_CUSTODYCD_NHAN,V_STR_NAME_NHAN ;
       EXIT WHEN CUR%NOTFOUND;
  END LOOP;
CLOSE CUR;


-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR

        SELECT DT.*,NVL(B.REPORT_QTTY,0) CA_AMT
        FROM(
        SELECT SB.PARVALUE , SB.SYMBOL,
        ---=IF(B24=1,"01212.",IF(B24=2,"01222.","01272"))
         ('012' || decode( DT.SE_TYPE ,'1', '1','2','2','7') || decode(substr(DT.CUSTODYCD,4,1),'C', '2.','F','3.','2.') || V_STR_TVLK_CODE ) TK_NO,
         ('012' || decode( DT.SE_TYPE ,'1', '1','2','2','7') || decode(substr(DT.CUSTODYCD,4,1),'C', '2.','F','3.','2.') || '091' ) TK_CO,
          DT.CUSTODYCD,

          (CASE WHEN SB.MARKETTYPE = '001' AND SB.SECTYPE  IN ('003','006','222','333','444')
                THEN '4. TRAI PHIEU CHUYEN BIET'
                ELSE
                    (CASE WHEN SB.TRADEPLACE='002' THEN '1. HNX'
                          WHEN SB.TRADEPLACE='001' THEN '2. HOSE'
                          WHEN SB.TRADEPLACE='005' THEN '3. UPCOM'
                          ELSE '3. UPCOM' END) END ) SAN_GD,
        DT.NAMT, DT.SE_TYPE, V_STR_TVLK_NAME   TVLK_NAME, V_STR_TVLK_CODE  TVLK_CODE,
        V_STR_CUSTODYCD_NHAN  CUSTODYCD_NHAN, V_STRFULLNAME FULLNAME ,PLSENT  PL_SENT
        , V_STR_NAME_NHAN NAME_NHAN
        ,CF.IDCODE, CF.IDDATE, CF.IDPLACE, NVL(CF.MOBILE,CF.PHONE) MOBILE, CF.ADDRESS
        FROM
        SBSECURITIES SB,
        (
        SELECT CUSTODYCD,TRADEPLACE,SUM(NAMT) NAMT,CODEID,SE_TYPE
        FROM (    SELECT  TXDATE, TXNUM, CUSTODYCD,AFACCTNO,TXCD,
                            SE.SECTYPE, SB.TRADEPLACE,
                             DECODE(TLTXCD,'2254', - SE.NAMT, SE.NAMT) NAMT,
                             SE.REF,
                            SE.BUSDATE, NVL(SB.REFCODEID, SB.CODEID) CODEID,
                            --CK CHO GIAO DICH TDCN
                            CASE WHEN SE.TRADEPLACE ='006' THEN '7' ELSE '1' END SE_TYPE
                    FROM    VW_SETRAN_GEN SE, SBSECURITIES SB
                           WHERE   TLTXCD IN ( '2244','2254')  AND DELTD = 'N'
                           AND  TXCD  IN ('0011' ,'0012')
                           AND NAMT<>0
                           AND SE.CODEID= SB.CODEID
                           AND TXDATE >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
                           AND TXDATE <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
                    UNION ALL

                    SELECT  TXDATE, TXNUM, CUSTODYCD,AFACCTNO,TXCD,
                            SB.SECTYPE, SB.TRADEPLACE,
                             DECODE(TLTXCD,'2254', - SE.NAMT, SE.NAMT) NAMT,
                            SE.REF,
                            SE.BUSDATE, NVL(SB.REFCODEID, SB.CODEID) CODEID,
                            --CK CHO GIAO DICH HCCN
                            CASE WHEN SE.TRADEPLACE ='006' THEN '8' ELSE '2' END SE_TYPE
                    FROM    VW_SETRAN_GEN SE,  SBSECURITIES SB
                           WHERE   TLTXCD IN  ( '2244','2254')  AND DELTD = 'N'
                           AND  TXCD IN  ('0044' ,'0043')
                            AND SE.CODEID= SB.CODEID
                           AND NAMT<>0
                           AND TXDATE >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
                           AND TXDATE <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
                           ) WHERE  AFACCTNO LIKE V_STRAFACCTNO GROUP BY CUSTODYCD,TRADEPLACE,CODEID,SE_TYPE
        ) DT, CFMAST CF

        WHERE SB.CODEID= DT.CODEID AND CF.CUSTODYCD = DT.CUSTODYCD AND DT.CUSTODYCD LIKE PV_CUSTODYCD AND DT.NAMT >0) DT,
        ( SELECT MAX(CF.CUSTODYCD) CUSTODYCD,
        SUM(CAS.TRADE)  REPORT_QTTY
  FROM CASCHD  CAS, CAMAST CA, CFMAST CF,
        AFMAST AF
        WHERE   CF.CUSTODYCD = V_CUSTODYCD AND CF.CUSTID = AF.CUSTID
        AND CAS.AFACCTNO = AF.ACCTNO AND CA.CAMASTID = CAS.CAMASTID
        AND AF.ACCTNO LIKE V_STRAFACCTNO
        AND INSTR ((CASE WHEN CA.CATYPE = '014' THEN 'O/A/S' ELSE 'O' END ),CAS.STATUS)>0) B

        WHERE DT.CUSTODYCD = B.CUSTODYCD(+)
         ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

