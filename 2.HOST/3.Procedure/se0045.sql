CREATE OR REPLACE PROCEDURE SE0045 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
  -- PLSENT         IN       VARCHAR2

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
   V_STR_FULLNMAME  VARCHAR2(200);
   V_STR_TVLK_NAME  VARCHAR2(200);
   V_STR_CUSTODYCD_NHAN  VARCHAR2(10);
   V_RECEIVE_FULLNAME VARCHAR2(100);
   CUR            PKG_REPORT.REF_CURSOR;
   --v_tltxcd varchar2(10);
   v_conditionfld varchar2(100);
BEGIN
-- GET REPORT'S PARAMETERS
    V_CUSTODYCD := UPPER( PV_CUSTODYCD);
    V_STR_TVLK_NAME :=' ';
    V_STR_TVLK_CODE :=' ';
    V_STRFULLNAME :=' ';
    V_STR_FULLNMAME:='';
    V_RECEIVE_FULLNAME:='';

    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE
     FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM';

   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
         V_STRAFACCTNO := '%';
   END IF;

  SELECT FULLNAME INTO V_STRFULLNAME FROM CFMAST WHERE custodycd = V_CUSTODYCD;

         OPEN CUR
         FOR
               SELECT NVL(DP.FULLNAME,' '), NVL(DT.BANK,' ') ,NVL(DT.RECEIVCUSTODYCD,' '), NVL(DT.RECEIVE_FULNAME,'')--, NVL(DT)
            FROM DEPOSIT_MEMBER DP, (
            SELECT MAX(CASE WHEN TLF.FLDCD = '05' THEN  TLF.CVALUE ELSE ' ' END)   BANK,
                   MAX(CASE WHEN TLF.FLDCD = '23' THEN  TLF.CVALUE ELSE ' ' END )  RECEIVCUSTODYCD,
                   max(CASE WHEN TLF.FLDCD = '24' THEN  TLF.CVALUE ELSE ' ' END) RECEIVE_FULNAME
               FROM VW_SETRAN_GEN  SE, VW_TLLOGFLD_ALL TLF, CFMAST CF
            WHERE SE.TLTXCD in('2244') AND SE.DELTD='N'
                  AND SE.CUSTODYCD = V_CUSTODYCD
                  AND TLF.FLDCD IN ('05','23','24')
                  AND SE.TXNUM = TLF.TXNUM AND  SE.TXDATE =TLF.TXDATE
                  AND SE.TXDATE >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
                  AND SE.TXDATE <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
                ) DT
            WHERE   DP.DEPOSITID  = DT.BANK ;
        LOOP
          FETCH CUR
               INTO V_STR_TVLK_NAME ,V_STR_TVLK_CODE,V_STR_CUSTODYCD_NHAN, V_RECEIVE_FULLNAME;
               EXIT WHEN CUR%NOTFOUND;
          END LOOP;
        CLOSE CUR;


-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR

         SELECT distinct  DT.CUSTODYCD,V_STR_TVLK_NAME   TVLK_NAME, V_STR_TVLK_CODE  TVLK_CODE,
                V_STR_CUSTODYCD_NHAN  CUSTODYCD_NHAN, V_STRFULLNAME FULLNAME, V_RECEIVE_FULLNAME RECEIVE_FULNAME,
                cf.idcode , cf.idplace, cf.address, cf.mobile, cf.iddate
        FROM
        SBSECURITIES SB,
        (
        SELECT CUSTODYCD,TRADEPLACE,CODEID
        FROM (    SELECT  se.TXDATE, se.TXNUM, CUSTODYCD,AFACCTNO,TXCD,
                            SE.SECTYPE, SB.TRADEPLACE,
                             SE.REF,
                            SE.BUSDATE, NVL(SB.REFCODEID, SB.CODEID) CODEID
                            --CK CHO GIAO DICH TDCN
                            --CASE WHEN SE.TRADEPLACE ='006' THEN '7' ELSE '1' END SE_TYPE
                    FROM    VW_SETRAN_GEN SE, SBSECURITIES SB
                    WHERE   TLTXCD IN ( '2244','2255')  AND se.DELTD = 'N'
                           AND  TXCD  IN ('0040','0011' ,'0045')
                           AND NAMT<>0
                           AND SE.CODEID= SB.CODEID
                           AND se.TXDATE >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
                           AND se.TXDATE <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
                    UNION ALL

                    SELECT  se.TXDATE, se.TXNUM, CUSTODYCD,AFACCTNO,TXCD,
                            SB.SECTYPE, SB.TRADEPLACE,
                            SE.REF,
                            SE.BUSDATE, NVL(SB.REFCODEID, SB.CODEID) CODEID
                            --CK CHO GIAO DICH HCCN
                            --CASE WHEN SE.TRADEPLACE ='006' THEN '8' ELSE '2' END SE_TYPE
                    FROM    VW_SETRAN_GEN SE,  SBSECURITIES SB
                    WHERE   TLTXCD IN  ( '2244','2255')  AND se.DELTD = 'N'
                           AND  TXCD IN  ('0044' ,'0043')
                           AND SE.CODEID= SB.CODEID
                           AND NAMT<>0
                           AND se.TXDATE >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
                           AND se.TXDATE <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
                           )
                          WHERE  AFACCTNO LIKE V_STRAFACCTNO GROUP BY CUSTODYCD,TRADEPLACE,CODEID--,SE_TYPE
                          ) DT, DEPOSIT_MEMBER DEP, cfmast CF

        WHERE SB.CODEID= DT.CODEID AND cf.custodycd=dt.custodycd and DT.CUSTODYCD LIKE PV_CUSTODYCD

         ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

