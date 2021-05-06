CREATE OR REPLACE PROCEDURE se0079 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_VOUCHER     IN       VARCHAR2,
   PLSENT         in       varchar2,
   TXNUM          in       varchar2
       )
IS

-- RP NAME : Bang ke danh sach nguoi so huu de nghi HUY RUT luu ky chung khoan
-- PERSON : PhucPP
-- DATE : 15/02/2012
-- COMMENTS : Chuyen sang dang bang ke.
-- ---------   ------  -------------------------------------------
   V_SYMBOL  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
BEGIN
-- GET REPORT'S PARAMETERS



-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
     SELECT MST.OBJNAME, CASE WHEN RF.SYMBOL_R LIKE '%WFT' THEN REPLACE(RF.SYMBOL_R,'_WFT','') ELSE RF.SYMBOL_R END MA_CK ,
        (SELECT AC.CDCONTENT FROM SBSECURITIES SB, ALLCODE AC WHERE SB.SYMBOL = REPLACE(RF.SYMBOL_R,'_WFT','') AND SB.TRADEPLACE = AC.CDVAL AND AC.CDTYPE= 'SE' AND AC.CDNAME= 'TRADEPLACE') SANGD,
       PV_VOUCHER VOUCHER_NO, PLSENT SENDTO, TXNUM TXNUM, BRID,  MST.TXDATE, MST.OBJKEY, CASE WHEN CF.CUSTODYCD LIKE '%F%'  THEN CF.TRADINGCODE WHEN CF.CUSTODYCD LIKE '%P%'  THEN CF.TRADINGCODE ELSE CF.IDCODE END IDCODE ,
       CASE WHEN CF.CUSTODYCD LIKE '%F%'  THEN CF.TRADINGCODEDT WHEN CF.CUSTODYCD LIKE '%P%'  THEN CF.TRADINGCODEDT ELSE CF.IDDATE END IDDATE, CASE WHEN CF.CUSTODYCD LIKE '%F%'  THEN '2' WHEN CF.CUSTODYCD LIKE '%P%'  THEN '3' WHEN CF.CUSTODYCD LIKE '%C%' AND CF.CUSTTYPE = 'B'  THEN '3' ELSE '1' END IDTYPE,
       SB.CODEID, SB.PARVALUE, SB.SECTYPE, CASE WHEN RF.SYMBOL_R like '%WFT%' THEN sb.symbol ELSE ISS.FULLNAME END TEN_CK,
       case when RF.SYMBOL_R like '%WFT%' then '7' else  '1' end QTTY_TYPE,
      MST.AFACCTNO, MST.BANKCODE, MST.BANKACCT, MST.STATUS, MST.TXAMT, RF.*
    FROM CRBTXREQ MST,CFMAST CF, CRBTRFLOG LG, CRBTRFLOGDTL LGDTL, SBSECURITIES SB,ISSUERS ISS,
      (SELECT *
      FROM   (SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
              FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE  MST.REQID=DTL.REQID AND MST.TRFCODE='SEREJECTWITHDRAW')
      PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN
      ('QTTY' as QTTY, 'LICENSE' as LICENSE,
      'CUSTNAME' as CUSTNAME, 'CUSTODYCD' as CUSTODYCD, 'BOARD' as BOARD, 'SYMBOL' as SYMBOL))
      ORDER BY REQID) RF
    WHERE MST.REQID=RF.REQID
      AND SB.SYMBOL = REPLACE(RF.SYMBOL_R,'_WFT','')
      AND CF.CUSTODYCD = RF.CUSTODYCD_R
      AND LG.VERSION = LGDTL.VERSION
      AND LG.TXDATE = LGDTL.TXDATE
      AND LG.TRFCODE = LGDTL.TRFCODE
      AND LGDTL.REFREQID = MST.REQID
      AND LG.TRFCODE = 'SEREJECTWITHDRAW'
      AND REPLACE(RF.SYMBOL_R,'_WFT','') = ISS.SHORTNAME(+)
      AND lpad(LGDTL.VERSION, 3,'0') = SUBSTR(PV_VOUCHER,15,3)
      AND LGDTL.TXDATE = TO_DATE((SUBSTR(PV_VOUCHER,9,2) || '/' || SUBSTR(PV_VOUCHER,11,2)  || '/' || '20' || SUBSTR(PV_VOUCHER,13,2)),'DD/MM/YYYY')
	  ORDER BY RF.CUSTODYCD_R, QTTY_TYPE
      ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

