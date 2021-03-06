CREATE OR REPLACE PROCEDURE MR1001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_VOUCHER     IN       VARCHAR2
       )
IS

-- RP NAME : Bang ke giai ngan MR
-- PERSON : PhucPP
-- DATE : 14/03/2012
-- COMMENTS : Create New
-- ---------   ------  -------------------------------------------
   V_SYMBOL  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
BEGIN
-- GET REPORT'S PARAMETERS



-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR

 SELECT MST.OBJNAME, FN_CRB_GETVOUCHERNO(LG.TRFCODE, LG.TXDATE, LG.VERSION) VOUCHERNO, BRID,  MST.TXDATE, MST.OBJKEY, CF.IDCODE, CF.IDDATE, CF.IDTYPE,CF.IDPLACE,
      MST.AFACCTNO, MST.BANKCODE, MST.BANKACCT, MST.STATUS, MST.TXAMT, RF.*
    FROM CRBTXREQ MST,CFMAST CF, CRBTRFLOG LG, CRBTRFLOGDTL LGDTL,
      (SELECT *
      FROM   (SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
              FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE  MST.REQID=DTL.REQID )
      PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN
      ('CUSTODYCD' as CUSTODYCD, 'FULLNAME' as FULLNAME,  'LMAMT' as LMAMT,
      'AVLLMAMT' as AVLLMAMT, 'AMOUNT' as AMOUNT, 'BANK_OUTSTANDING' as BANK_OUTSTANDING, 'TADF' as TADF,
      'INTRATE' as INTRATE,'OVERDUEDATE' as OVERDUEDATE,'HESOK' as HESOK, 'DESC' as NOTES))
      ORDER BY REQID) RF
    WHERE MST.REQID=RF.REQID
      AND CF.CUSTODYCD = RF.CUSTODYCD_R
      AND LG.VERSION = LGDTL.VERSION
      AND LG.TXDATE = LGDTL.TXDATE
      AND LG.TRFCODE = LGDTL.TRFCODE
      AND LGDTL.REFREQID = MST.REQID
      AND LG.TRFCODE = 'LOANDRAWNDOWN'
      AND lpad(LGDTL.VERSION, 3,'0') = SUBSTR(PV_VOUCHER,15,3)
      AND LGDTL.TXDATE = TO_DATE((SUBSTR(PV_VOUCHER,9,2) || '/' || SUBSTR(PV_VOUCHER,11,2)  || '/' || '20' || SUBSTR(PV_VOUCHER,13,2)),'DD/MM/YYYY')
      ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

