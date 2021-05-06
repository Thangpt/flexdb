CREATE OR REPLACE PROCEDURE td0021 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2,
   ACTYPE         IN       VARCHAR2,
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

   V_INDATE         date;
   --V_CURRDATE1      VARCHAR2 (10);
   --V_CURRDATE       DATE;
   V_STRAFACCTNO     VARCHAR2 (10);
   V_STRCAREBY      VARCHAR2 (4);
   V_STRACTYPE      VARCHAR2 (10);

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

   IF(upper(AFACCTNO) <> 'ALL') THEN
        V_STRAFACCTNO := AFACCTNO;
   ELSE
        V_STRAFACCTNO := '%';
   END IF;

   if(upper(ACTYPE) <> 'ALL') then
        V_STRACTYPE :=  ACTYPE;
   else
        V_STRACTYPE := '%';
   end if;

   V_INDATE := to_date(I_DATE,'dd/mm/yyyy');

   -- GET REPORT'S DATA
IF(LOANTYPE = '01') THEN

OPEN PV_REFCURSOR
       FOR

SELECT V_INDATE IDATE, mst.actype, A3.CDCONTENT DESC_SCHDTYPE, tlgroups.grpname,
    MST.ACCTNO, MST.AFACCTNO, CF.FULLNAME,
    td.ORGAMT, td.FRDATE, (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                AND SBDATE >= td.TODATE AND HOLIDAY = 'N') TODATE,
    (MST.BALANCE-nvl(TR.namt,0)) BALANCE,
    (mst.intpaid - nvl(TR2.namt,0)) INTPAID,
    FN_TDMASTINTRATIO2(MST.ACCTNO,V_INDATE,(MST.BALANCE-nvl(TR.namt,0)))  INTAVLAMT,
    ((mst.intpaid - nvl(TR2.namt,0)) +
                         FN_TDMASTINTRATIO2(MST.ACCTNO,V_INDATE,(MST.BALANCE-nvl(TR.namt,0))))
                total_INT,
    (td.ORGAMT-(MST.BALANCE-nvl(TR.namt,0))) WITHDRAWAL
FROM (
         SELECT * FROM TDMAST WHERE OPNDATE <= V_INDATE  AND (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE
AND HOLIDAY = 'N') >= V_INDATE AND DELTD <>'Y' and AFACCTNO LIKE V_STRAFACCTNO
      ) MST, AFMAST AF, CFMAST CF, ALLCODE A3, SYSVAR, tlgroups,
      (
             SELECT * FROM
             (
                 select orgamt,deltd,afacctno , acctno , (case when autornd = 'Y' then frdate else opndate end) opndate , frdate , todate,ACTYPE
                    from tdmast where afacctno LIKE V_STRAFACCTNO AND DELTD <>'Y'
                 union
                 select orgamt,deltd,afacctno , acctno , frdate opndate , frdate , todate,ACTYPE
                    from tdmasthist where afacctno LIKE V_STRAFACCTNO AND DELTD <>'Y'
             ) WHERE OPNDATE <= V_INDATE AND (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE
AND HOLIDAY = 'N') >= V_INDATE
         ) td ,
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
            AND NVL(TR.BKDATE,TR.TXDATE) > V_INDATE
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
            AND NVL(TR.BKDATE,TR.TXDATE) > V_INDATE
        GROUP BY TR.ACCTNO
    ) TR2
WHERE MST.AFACCTNO=AF.ACCTNO
    AND AF.CUSTID=CF.CUSTID
    AND MST.DELTD <> 'Y'
    and cf.careby = tlgroups.grpid
    AND A3.CDTYPE='TD'
    AND A3.CDNAME='SCHDTYPE'
    AND MST.SCHDTYPE=A3.CDVAL
    AND SYSVAR.VARNAME= 'CURRDATE'
    AND MST.ACCTNO = TR.ACCTNO(+)
    AND MST.ACCTNO = TR2.ACCTNO(+)
    and af.acctno like V_STRAFACCTNO
    AND (MST.BALANCE-nvl(TR.namt,0)) > 0
    AND MST.OPNDATE <= V_INDATE
    and mst.acctno = td.acctno(+)
    AND MST.ACTYPE LIKE V_STRACTYPE
    AND TD.ACTYPE LIKE V_STRACTYPE
    order by MST.ACCTNO,MST.AFACCTNO,td.FRDATE;

ELSE

OPEN PV_REFCURSOR
       FOR

SELECT V_INDATE IDATE, mst.actype, A3.CDCONTENT DESC_SCHDTYPE, tlgroups.grpname,
    MST.ACCTNO, MST.AFACCTNO, CF.FULLNAME,
    td.ORGAMT, td.FRDATE, (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                AND SBDATE >= td.TODATE AND HOLIDAY = 'N') TODATE,
    (MST.BALANCE-nvl(TR.namt,0)) BALANCE,
    (mst.intpaid - nvl(TR2.namt,0)) INTPAID,
                 FN_TDMASTINTRATIO2(MST.ACCTNO,td.TODATE,(MST.BALANCE-nvl(TR.namt,0)))
            INTAVLAMT,
    ((mst.intpaid - nvl(TR2.namt,0)) +
               FN_TDMASTINTRATIO2(MST.ACCTNO,td.TODATE,(MST.BALANCE-nvl(TR.namt,0))))
             total_INT,
    (td.ORGAMT-(MST.BALANCE-nvl(TR.namt,0))) WITHDRAWAL
FROM (
        SELECT * FROM TDMAST WHERE OPNDATE <= V_INDATE  AND (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE
AND HOLIDAY = 'N') >= V_INDATE AND DELTD <>'Y' and AFACCTNO LIKE V_STRAFACCTNO
     ) MST, AFMAST AF, CFMAST CF, ALLCODE A3, SYSVAR, tlgroups,
     (
              SELECT * FROM
              (
                   select orgamt,deltd,afacctno , acctno , (case when autornd = 'Y' then frdate else opndate end) opndate , frdate , todate,ACTYPE
                   from tdmast where afacctno LIKE V_STRAFACCTNO AND DELTD <>'Y'
                   union
                   select orgamt,deltd,afacctno , acctno , frdate opndate , frdate , todate,ACTYPE
                   from tdmasthist where afacctno LIKE V_STRAFACCTNO AND DELTD <>'Y'
              ) WHERE OPNDATE <= V_INDATE AND (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE
AND HOLIDAY = 'N') >= V_INDATE
     ) td,
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
            AND NVL(TR.BKDATE,TR.TXDATE) > V_INDATE
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
            AND NVL(TR.BKDATE,TR.TXDATE) > V_INDATE
        GROUP BY TR.ACCTNO
    ) TR2
WHERE MST.AFACCTNO=AF.ACCTNO
    AND AF.CUSTID=CF.CUSTID
    AND MST.DELTD <> 'Y'
    and cf.careby = tlgroups.grpid
    AND A3.CDTYPE='TD'
    AND A3.CDNAME='SCHDTYPE'
    AND MST.SCHDTYPE=A3.CDVAL
    AND SYSVAR.VARNAME= 'CURRDATE'
    AND MST.ACCTNO = TR.ACCTNO(+)
    AND MST.ACCTNO = TR2.ACCTNO(+)
    and af.acctno like V_STRAFACCTNO
    AND (MST.BALANCE-nvl(TR.namt,0)) > 0
    AND MST.OPNDATE <= V_INDATE
    and mst.acctno = td.acctno(+)
    AND MST.ACTYPE LIKE V_STRACTYPE
    AND TD.ACTYPE LIKE V_STRACTYPE
    order by MST.ACCTNO,MST.AFACCTNO,td.FRDATE;

END IF;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

