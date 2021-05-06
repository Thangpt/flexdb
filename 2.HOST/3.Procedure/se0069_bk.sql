CREATE OR REPLACE PROCEDURE SE0069_BK (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2
       )
IS

-- RP NAME : Bang ke danh sach nguoi so huu de nghi luu ky chung khoan bi VSD tu choi
-- PERSON : PhucPP
-- DATE : 16/02/2012
-- COMMENTS : Chuyen sang dang bang ke.
-- ---------   ------  -------------------------------------------
   V_SYMBOL  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
BEGIN
-- GET REPORT'S PARAMETERS

   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;


   IF  (PV_SYMBOL <> 'ALL')
   THEN
         V_SYMBOL := PV_SYMBOL;
   ELSE
      V_SYMBOL := '%';
   END IF;

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
    SELECT MST.OBJNAME, BRID, V_SYMBOL SYMBOL_INP, MST.TXDATE, MST.OBJKEY, CF.IDCODE, CF.IDDATE, CF.IDTYPE,
       SB.CODEID, SB.PARVALUE, TL.KL QTTY_R,
      MST.AFACCTNO, MST.BANKCODE, MST.BANKACCT, MST.STATUS, MST.TXAMT, RF.*
    FROM CRBTXREQ MST,CFMAST CF, CRBTRFLOG LG, CRBTRFLOGDTL LGDTL, SBSECURITIES SB,
      (SELECT *
      FROM   (SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
              FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE MST.REQID=DTL.REQID AND MST.TRFCODE='SEREJECTDEPOSIT')
      PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN
      ('LICENSE' as LICENSE,
      'CUSTNAME' as CUSTNAME, 'CUSTODYCD' as CUSTODYCD, 'BOARD' as BOARD, 'SYMBOL' as SYMBOL))
      ORDER BY REQID) RF,
      (SELECT al.txnum,al.txdate,max(substr(al.msgacct,0,10)) AFACCTNO , max(msgamt) KL
            FROM vw_tllog_all al,vw_tllogfld_all fld
            WHERE
                al.txnum=fld.txnum
                and al.txdate=fld.txdate
                and al.tltxcd='2231'
                and al.deltd<>'Y'
            group by al.txnum,al.txdate) TL
    WHERE MST.REQID=RF.REQID
      AND CF.CUSTODYCD = RF.CUSTODYCD_R
      AND MST.REQID=RF.REQID
      AND LG.AUTOID = LGDTL.VERSION
      AND LGDTL.REFREQID = MST.REQID
      AND LG.TRFCODE = 'SEREJECTDEPOSIT'
      AND RF.SYMBOL_R LIKE V_SYMBOL
      AND RF.CUSTODYCD_R LIKE V_CUSTODYCD
      AND RF.SYMBOL_R = SB.SYMBOL
      AND TL.txnum=MST.OBJKEY
      AND TL.txdate = MST.txdate
      AND LG.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')  AND LG.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY') ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

