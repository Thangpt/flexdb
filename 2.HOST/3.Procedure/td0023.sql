CREATE OR REPLACE PROCEDURE td0023(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_CUSTODYCD    IN       VARCHAR2,
   --I_DATE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2,
   PV_TDACCTNO     IN       VARCHAR2,
   LOANTYPE       IN       VARCHAR2
   --CAREBY         IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- Bao cao tinh trang no qua han
-- PERSON           DATE        COMMENTS
-- DUNGNH       24-MAR-2011     CREATED
-- ---------       ------   -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   --V_INDATE         date;
   V_CURRDATE1      VARCHAR2 (10);
   V_CURRDATE       DATE;
   V_STRAFACCTNO     VARCHAR2 (10);
   V_STRCAREBY      VARCHAR2 (4);
   v_strCustodyCD VARCHAR2(10);
   v_strTDAcctno  VARCHAR2(20);
   v_strLoanTYPE VARCHAR2(100);

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
    /*
   IF(upper(CAREBY) <> 'ALL') THEN
        V_STRCAREBY := CAREBY;
   ELSE
        V_STRCAREBY := '%';
   END IF;
   */

   IF(upper(AFACCTNO) <> 'ALL') THEN
        V_STRAFACCTNO := AFACCTNO;
   ELSE
        V_STRAFACCTNO := '%';
   END IF;

   IF(upper(PV_CUSTODYCD) <> 'ALL') THEN
        v_strCustodyCD := upper(PV_CUSTODYCD);
   ELSE
        v_strCustodyCD := '%';
   END IF;

   IF(upper(PV_TDACCTNO) <> 'ALL') THEN
        v_strTDAcctno := PV_TDACCTNO;
   ELSE
        v_strTDAcctno := '%';
   END IF;


   --V_INDATE := to_date(I_DATE,'dd/mm/yyyy');
   BEGIN
     select varvalue into V_CURRDATE1 from sysvar where varname = 'CURRDATE';
     V_CURRDATE := TO_DATE(V_CURRDATE1,'DD/MM/YYYY');
    END;
   IF (LOANTYPE='01') THEN
     v_strLoanTYPE:='Tính d?n ngày l?c báo cáo';
   ELSE
      v_strLoanTYPE:='Tính d?n ngày h?t k? h?n g?i';
   END IF;

   -- GET REPORT'S DATA
IF(LOANTYPE = '01') THEN

OPEN PV_REFCURSOR
       FOR


SELECT V_CURRDATE IDATE, mst.actype, A3.CDCONTENT DESC_SCHDTYPE, tlgroups.grpname,
    MST.ACCTNO, MST.AFACCTNO, CF.FULLNAME,
    MST.ORGAMT, MST.FRDATE, (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                AND SBDATE >= MST.TODATE AND HOLIDAY = 'N') TODATE,
    (MST.BALANCE-nvl(TR.namt,0)) BALANCE, (mst.intpaid - nvl(TR2.namt,0)) INTPAID,
    FN_TDMASTINTRATIO(MST.ACCTNO,V_CURRDATE,(MST.BALANCE-nvl(TR.namt,0))) INTAVLAMT,
    (mst.intpaid - nvl(TR2.namt,0)) +
    FN_TDMASTINTRATIO(MST.ACCTNO,V_CURRDATE,(MST.BALANCE-nvl(TR.namt,0))) total_INT,
    (MST.ORGAMT-(MST.BALANCE-nvl(TR.namt,0))) WITHDRAWAL,
    cf.custodycd,v_strLoanTYPE LOANTYPE
FROM ( select * from TDMAST WHERE OPNDATE <= V_CURRDATE  AND
        (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE AND HOLIDAY = 'N') >= V_CURRDATE AND DELTD <>'Y') MST,
        AFMAST AF, CFMAST CF, ALLCODE A3, SYSVAR, tlgroups,
    (
        SELECT TR.ACCTNO,
            sum(CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) NAMT
        FROM (SELECT * FROM TDTRAN UNION ALL SELECT * FROM TDTRANA) TR,
            (select * from tllog union all select * from tllogall) tl,
            V_APPMAP_BY_TLTXCD APP
        WHERE TR.NAMT > 0 AND tr.DELTD <> 'Y'
            and tr.txnum = tl.txnum
            and tr.txdate = tl.txdate
            and tl.tltxcd = app.tltxcd
            AND TR.TXCD = APP.APPTXCD
            AND APP.FIELD = 'BALANCE'
            AND APP.APPTYPE = 'TD'
            AND NVL(TR.BKDATE,TR.TXDATE) > V_CURRDATE
        GROUP BY TR.ACCTNO
    ) TR,
    (
        SELECT TR.ACCTNO,
            sum(CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) NAMT
        FROM (SELECT * FROM TDTRAN UNION ALL SELECT * FROM TDTRANA) TR,
            (select * from tllog union all select * from tllogall) tl,
            V_APPMAP_BY_TLTXCD APP
        WHERE TR.NAMT > 0 AND tr.DELTD <> 'Y'
            and tr.txnum = tl.txnum
            and tr.txdate = tl.txdate
            and tl.tltxcd = app.tltxcd
            AND TR.TXCD = APP.APPTXCD
            AND APP.FIELD = 'INTPAID'
            AND APP.APPTYPE = 'TD'
            AND NVL(TR.BKDATE,TR.TXDATE) > V_CURRDATE
        GROUP BY TR.ACCTNO
    ) TR2
WHERE MST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND MST.DELTD = 'N'
    and cf.careby = tlgroups.grpid
    AND A3.CDTYPE='TD' AND A3.CDNAME='SCHDTYPE' AND MST.SCHDTYPE=A3.CDVAL
    AND SYSVAR.VARNAME= 'CURRDATE'
    AND MST.ACCTNO = TR.ACCTNO(+)
    AND MST.ACCTNO = TR2.ACCTNO(+)
    --AND CF.CAREBY like V_STRCAREBY
    and af.acctno like V_STRAFACCTNO
    AND cf.custodycd LIKE v_strCustodyCD
    AND mst.acctno LIKE  v_strTDAcctno
    AND MST.STATUS IN ('N','A')
    AND (MST.BALANCE-nvl(TR.namt,0)) > 0
    order by MST.ACCTNO, MST.AFACCTNO;

ELSE

OPEN PV_REFCURSOR
       FOR

SELECT V_CURRDATE IDATE, mst.actype, A3.CDCONTENT DESC_SCHDTYPE, tlgroups.grpname,
    MST.ACCTNO, MST.AFACCTNO, CF.FULLNAME,
    MST.ORGAMT, MST.FRDATE, (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                AND SBDATE >= MST.TODATE AND HOLIDAY = 'N') TODATE,
    (MST.BALANCE-nvl(TR.namt,0)) BALANCE, (mst.intpaid - nvl(TR2.namt,0)) INTPAID,
    FN_TDMASTINTRATIO(MST.ACCTNO,MST.TODATE,(MST.BALANCE-nvl(TR.namt,0))) INTAVLAMT,
    (mst.intpaid - nvl(TR2.namt,0)) +
    FN_TDMASTINTRATIO(MST.ACCTNO,MST.TODATE,(MST.BALANCE-nvl(TR.namt,0))) total_INT,
    (MST.ORGAMT-(MST.BALANCE-nvl(TR.namt,0))) WITHDRAWAL,
    cf.custodycd,v_strLoanTYPE LOANTYPE
FROM ( select * from TDMAST WHERE OPNDATE <= V_CURRDATE  AND
        (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE AND HOLIDAY = 'N') >= V_CURRDATE AND DELTD <>'Y') MST,
        AFMAST AF, CFMAST CF, ALLCODE A3, SYSVAR, tlgroups,
    (
        SELECT TR.ACCTNO,
            sum(CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) NAMT
        FROM (SELECT * FROM TDTRAN UNION ALL SELECT * FROM TDTRANA) TR,
            (select * from tllog union all select * from tllogall) tl,
            V_APPMAP_BY_TLTXCD APP
        WHERE TR.NAMT > 0 AND tr.DELTD <> 'Y'
            and tr.txnum = tl.txnum
            and tr.txdate = tl.txdate
            and tl.tltxcd = app.tltxcd
            AND TR.TXCD = APP.APPTXCD
            AND APP.FIELD = 'BALANCE'
            AND APP.APPTYPE = 'TD'
            AND NVL(TR.BKDATE,TR.TXDATE) > V_CURRDATE
        GROUP BY TR.ACCTNO
    ) TR,
    (
        SELECT TR.ACCTNO,
            sum(CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) NAMT
        FROM (SELECT * FROM TDTRAN UNION ALL SELECT * FROM TDTRANA) TR,
            (select * from tllog union all select * from tllogall) tl,
            V_APPMAP_BY_TLTXCD APP
        WHERE TR.NAMT > 0 AND tr.DELTD <> 'Y'
            and tr.txnum = tl.txnum
            and tr.txdate = tl.txdate
            and tl.tltxcd = app.tltxcd
            AND TR.TXCD = APP.APPTXCD
            AND APP.FIELD = 'INTPAID'
            AND APP.APPTYPE = 'TD'
            AND NVL(TR.BKDATE,TR.TXDATE) > V_CURRDATE
        GROUP BY TR.ACCTNO
    ) TR2
WHERE MST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND MST.DELTD = 'N'
    and cf.careby = tlgroups.grpid
    AND A3.CDTYPE='TD' AND A3.CDNAME='SCHDTYPE' AND MST.SCHDTYPE=A3.CDVAL
    AND SYSVAR.VARNAME= 'CURRDATE'
    AND MST.ACCTNO = TR.ACCTNO(+)
    AND MST.ACCTNO = TR2.ACCTNO(+)
    AND MST.STATUS IN ('N','A')
    --AND CF.CAREBY like V_STRCAREBY
    and af.acctno like V_STRAFACCTNO
    AND cf.custodycd LIKE v_strCustodyCD
    AND mst.acctno LIKE  v_strTDAcctno
    AND (MST.BALANCE-nvl(TR.namt,0)) > 0
    order by MST.ACCTNO, MST.AFACCTNO;

END IF
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

