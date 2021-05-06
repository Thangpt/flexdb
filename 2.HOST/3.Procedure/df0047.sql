CREATE OR REPLACE PROCEDURE DF0047 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_VOUCHER     IN       VARCHAR2
       )
IS

-- RP NAME : Bao cao phu luc danh sach CK giai ngan theo bang ke
-- PERSON : PhucPP
-- DATE : 09/03/2012
-- COMMENTS : Create New
-- ---------   ------  -------------------------------------------
   V_SYMBOL  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
BEGIN
-- GET REPORT'S PARAMETERS



-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
 SELECT SEDTL.GROUPID, SEDTL.DFACCTNO, SEDTL.SYMBOL, SEDTL.QTTY, SEDTL.MKTPRICE, SEDTL.RATIO, SEDTL.PRICE, SEDTL.MKTAMT, SEDTL.AMT,
  MST.OBJNAME, BRID BRID,  MST.TXDATE, MST.OBJKEY, FN_CRB_GETVOUCHERNO(LG.TRFCODE, LG.TXDATE, LG.VERSION) VOUCHERNO,
      MST.AFACCTNO, MST.BANKCODE, MST.BANKACCT, MST.STATUS, MST.TXAMT, RF.*
    FROM CRBTXREQ MST,CRBTRFLOG LG, CRBTRFLOGDTL LGDTL, CRBDRAWNDOWNDTL SEDTL,
      (SELECT *
      FROM   (SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
              FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE MST.REQID=DTL.REQID AND MST.TRFCODE='DFDRAWNDOWN')
      PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN
      ('QTTY' as QTTY, 'LICENSE' as LICENSE,
      'CUSTNAME' as CUSTNAME, 'CUSTODYCD' as CUSTODYCD, 'BOARD' as BOARD, 'SYMBOL' as SYMBOL))
      ORDER BY REQID) RF
    WHERE MST.REQID=RF.REQID
      AND LG.VERSION = LGDTL.VERSION
      AND LG.TXDATE = LGDTL.TXDATE
      AND LG.TRFCODE = LGDTL.TRFCODE
      AND LGDTL.REFREQID = MST.REQID
      AND LG.TRFCODE = 'DFDRAWNDOWN'
      AND MST.OBJKEY = SEDTL.OBJKEY
      AND LG.TRFCODE = SEDTL.TRFCODE
      AND MST.TXDATE = SEDTL.TXDATE
      AND lpad(LGDTL.VERSION, 3,'0') = SUBSTR(PV_VOUCHER,15,3)
      AND LGDTL.TXDATE = TO_DATE((SUBSTR(PV_VOUCHER,9,2) || '/' || SUBSTR(PV_VOUCHER,11,2)  || '/' || '20' || SUBSTR(PV_VOUCHER,13,2)),'DD/MM/YYYY')
      ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

