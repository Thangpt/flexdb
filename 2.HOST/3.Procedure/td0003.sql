CREATE OR REPLACE PROCEDURE td0003 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2,
   LOANTYPE       IN       VARCHAR2,
   CAREBY         IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- Bao cao tinh trang no qua han
-- PERSON           DATE        COMMENTS
-- DUNGNH       24-MAR-2011     CREATED
-- ---------       ------   -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_INDATE         date;
   V_STRAFACCTNO     VARCHAR2 (10);
   V_STRCAREBY      VARCHAR2 (4);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    -- GET REPORT'S PARAMETERS
   IF(upper(CAREBY) <> 'ALL') THEN
        V_STRCAREBY := CAREBY;
   ELSE
        V_STRCAREBY := '%';
   END IF;

   IF(upper(AFACCTNO) <> 'ALL') THEN
        V_STRAFACCTNO := AFACCTNO;
   ELSE
        V_STRAFACCTNO := '%';
   END IF;

   V_INDATE := to_date(I_DATE,'dd/mm/yyyy');


   -- GET REPORT'S DATA
IF(LOANTYPE = '01') THEN

OPEN PV_REFCURSOR
       FOR

SELECT I_DATE IDATE, mst.actype, A3.CDCONTENT DESC_SCHDTYPE, tlgroups.grpname,
    MST.ACCTNO, MST.AFACCTNO, CF.FULLNAME, MST.ORGAMT, MST.FRDATE,
    (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' 
                                AND SBDATE >= MST.TODATE AND HOLIDAY = 'N') TODATE,
    (MST.BALANCE-nvl(TR.namt,0)) BALANCE, nvl(TR2.namt,0)INTPAID,
    FN_TDMASTINTRATIO(MST.ACCTNO,V_INDATE,MST.BALANCE) INTAVLAMT,
    nvl(TR2.namt,0)+
    FN_TDMASTINTRATIO(MST.ACCTNO,V_INDATE,MST.BALANCE) total_INT,
    (MST.ORGAMT-(MST.BALANCE-nvl(TR.namt,0))) WITHDRAWAL
FROM TDMAST MST, AFMAST AF, CFMAST CF, ALLCODE A3, SYSVAR, tlgroups,
    (
        SELECT TR.ACCTNO, SUM(TR.NAMT) NAMT
        FROM
            (
                SELECT DISTINCT TR.ACCTNO, txnum, txdate,
                (CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) NAMT
                FROM (SELECT * FROM TDTRAN UNION ALL SELECT * FROM TDTRANA) TR,
                V_APPMAP_BY_TLTXCD APP
                WHERE TR.NAMT > 0 AND DELTD <> 'Y'
                    AND TR.TXCD = APP.APPTXCD
                    AND APP.FIELD = 'BALANCE'
                    AND APP.APPTYPE = 'TD'
                    AND NVL(TR.BKDATE,TR.TXDATE) >= V_INDATE
            ) TR
        GROUP BY TR.ACCTNO
    ) TR,
    (
        SELECT TR.ACCTNO, SUM(TR.NAMT) NAMT
        FROM
            (
                SELECT DISTINCT TR.ACCTNO, txnum, txdate,
                (CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) NAMT
                FROM (SELECT * FROM TDTRAN UNION ALL SELECT * FROM TDTRANA) TR,
                V_APPMAP_BY_TLTXCD APP
                WHERE TR.NAMT > 0 AND DELTD <> 'Y'
                    AND TR.TXCD = APP.APPTXCD
                    AND APP.FIELD = 'INTPAID'
                    AND APP.APPTYPE = 'TD'
                    AND NVL(TR.BKDATE,TR.TXDATE) >= V_INDATE
            ) TR
        GROUP BY TR.ACCTNO
    ) TR2
WHERE MST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND MST.DELTD = 'N'
    and cf.careby = tlgroups.grpid
    AND A3.CDTYPE='TD' AND A3.CDNAME='SCHDTYPE' AND MST.SCHDTYPE=A3.CDVAL
    AND SYSVAR.VARNAME= 'CURRDATE'
    AND MST.ACCTNO = TR.ACCTNO(+)
    AND MST.ACCTNO = TR2.ACCTNO(+)
    AND CF.CAREBY like V_STRCAREBY
    and af.acctno like V_STRAFACCTNO
    AND MST.STATUS IN ('N','A')
    AND (MST.BALANCE-nvl(TR.namt,0)) > 0;

ELSE

OPEN PV_REFCURSOR
       FOR

SELECT I_DATE IDATE, mst.actype, A3.CDCONTENT DESC_SCHDTYPE, tlgroups.grpname,
    MST.ACCTNO, MST.AFACCTNO, CF.FULLNAME, MST.ORGAMT, MST.FRDATE,
    (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' 
                                AND SBDATE >= MST.TODATE AND HOLIDAY = 'N') TODATE,
    (MST.BALANCE-nvl(TR.namt,0)) BALANCE, nvl(TR2.namt,0)INTPAID,
    FN_TDMASTINTRATIO(MST.ACCTNO,(SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' 
                                AND SBDATE >= MST.TODATE AND HOLIDAY = 'N'),MST.BALANCE) INTAVLAMT,
    nvl(TR2.namt,0)+
    FN_TDMASTINTRATIO(MST.ACCTNO,(SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' 
                                AND SBDATE >= MST.TODATE AND HOLIDAY = 'N'),MST.BALANCE) total_INT,
    (MST.ORGAMT-(MST.BALANCE-nvl(TR.namt,0))) WITHDRAWAL
FROM TDMAST MST, AFMAST AF, CFMAST CF, ALLCODE A3, SYSVAR, tlgroups,
    (
        SELECT TR.ACCTNO, SUM(TR.NAMT) NAMT
        FROM
            (
                SELECT DISTINCT TR.ACCTNO, txnum, txdate,
                (CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) NAMT
                FROM (SELECT * FROM TDTRAN UNION ALL SELECT * FROM TDTRANA) TR,
                V_APPMAP_BY_TLTXCD APP
                WHERE TR.NAMT > 0 AND DELTD <> 'Y'
                    AND TR.TXCD = APP.APPTXCD
                    AND APP.FIELD = 'BALANCE'
                    AND APP.APPTYPE = 'TD'
                    AND NVL(TR.BKDATE,TR.TXDATE) >= V_INDATE
            ) TR
        GROUP BY TR.ACCTNO
    ) TR,
    (
        SELECT TR.ACCTNO, SUM(TR.NAMT) NAMT
        FROM
            (
                SELECT DISTINCT TR.ACCTNO, txnum, txdate,
                (CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) NAMT
                FROM (SELECT * FROM TDTRAN UNION ALL SELECT * FROM TDTRANA) TR,
                V_APPMAP_BY_TLTXCD APP
                WHERE TR.NAMT > 0 AND DELTD <> 'Y'
                    AND TR.TXCD = APP.APPTXCD
                    AND APP.FIELD = 'INTPAID'
                    AND APP.APPTYPE = 'TD'
                    AND NVL(TR.BKDATE,TR.TXDATE) >= V_INDATE
            ) TR
        GROUP BY TR.ACCTNO
    ) TR2
WHERE MST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND MST.DELTD = 'N'
    and cf.careby = tlgroups.grpid
    AND A3.CDTYPE='TD' AND A3.CDNAME='SCHDTYPE' AND MST.SCHDTYPE=A3.CDVAL
    AND SYSVAR.VARNAME= 'CURRDATE'
    AND MST.ACCTNO = TR.ACCTNO(+)
    AND MST.ACCTNO = TR2.ACCTNO(+)
    AND MST.STATUS IN ('N','A')
    AND CF.CAREBY like V_STRCAREBY
    and af.acctno like V_STRAFACCTNO
    AND (MST.BALANCE-nvl(TR.namt,0)) > 0;

END IF;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

