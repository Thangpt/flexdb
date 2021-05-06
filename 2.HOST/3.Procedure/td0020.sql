CREATE OR REPLACE PROCEDURE td0020 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2,
   ACTYPE         IN       VARCHAR2,
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
   V_STRAFACCTNO    VARCHAR2 (10);
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

   V_STRCAREBY :=  CAREBY;

   IF(upper(AFACCTNO) <> 'ALL') THEN
        V_STRAFACCTNO := AFACCTNO;
   ELSE
        V_STRAFACCTNO := '%';
   END IF;

   V_INDATE := to_date(I_DATE,'dd/MM/yyyy');

   if(upper(ACTYPE) <> 'ALL') then
        V_STRACTYPE :=  ACTYPE;
   else
        V_STRACTYPE := '%';
   end if;

   -- GET REPORT'S DATA

IF(LOANTYPE = '01') THEN

OPEN PV_REFCURSOR  FOR

  SELECT V_INDATE IDATE, MST.ACTYPE, MST.ACCTNO,CF.FULLNAME, MST.AFACCTNO, td.ORGAMT, td.FRDATE,
         (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= td.TODATE AND HOLIDAY = 'N') TODATE,
         (MST.BALANCE-NVL(TR.NAMT,0)) NAMT,
         --(
            --case when (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= td.TODATE AND HOLIDAY = 'N') = V_INDATE then 0
                 --else
                       FN_TDMASTINTRATIO2(MST.ACCTNO,V_INDATE,(MST.BALANCE-NVL(TR.NAMT,0)))
             --end
         --)
         INTAVLAMT,
         (mst.intpaid - nvl(TR2.namt,0)) INTPAID
  FROM
         (
            SELECT * FROM TDMAST WHERE OPNDATE <= V_INDATE  AND
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE
    AND HOLIDAY = 'N') >= V_INDATE AND DELTD <>'Y' and AFACCTNO LIKE V_STRAFACCTNO
         ) MST , AFMAST AF, CFMAST CF,
         (
             SELECT * FROM
             (
                 select orgamt,deltd,afacctno , acctno , (case when autornd = 'Y' then frdate else opndate end) opndate , frdate , todate , ACTYPE
                    from tdmast where afacctno LIKE V_STRAFACCTNO AND DELTD <>'Y'
                 union
                 select orgamt,deltd,afacctno , acctno , frdate opndate , frdate , todate , ACTYPE
                    from tdmasthist where afacctno LIKE V_STRAFACCTNO AND DELTD <>'Y'
             ) WHERE OPNDATE <= V_INDATE AND (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE
        AND HOLIDAY = 'N') >= V_INDATE
         ) td ,
         (
            SELECT DISTINCT TLGRPUSERS.GRPID
            FROM TLPROFILES, TLGRPUSERS
            WHERE TLPROFILES.TLID LIKE decode(V_STRCAREBY,'0001','%',V_STRCAREBY)
            AND TLPROFILES.BRID = TLGRPUSERS.BRID
            AND TLPROFILES.TLID = TLGRPUSERS.TLID
         ) CARE,
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

    WHERE MST.ACCTNO = TR.ACCTNO(+)
    AND MST.ACCTNO = TR2.ACCTNO(+)
    and mst.acctno = td.acctno(+)
    AND TD.OPNDATE <= V_INDATE
    AND (MST.BALANCE-NVL(TR.NAMT,0)) > 0
    AND MST.AFACCTNO = AF.ACCTNO
    AND AF.CUSTID = CF.CUSTID
    --AND MST.STATUS IN ('N','A')
    AND MST.DELTD <> 'Y'
    AND CF.CAREBY = CARE.GRPID
    AND MST.AFACCTNO LIKE V_STRAFACCTNO
    AND MST.ACTYPE LIKE V_STRACTYPE
    AND TD.ACTYPE LIKE V_STRACTYPE
    order by MST.ACCTNO,MST.AFACCTNO,td.FRDATE;


ELSE

OPEN PV_REFCURSOR  FOR

    SELECT  V_INDATE IDATE, MST.ACTYPE, MST.ACCTNO,CF.FULLNAME, MST.AFACCTNO, td.ORGAMT, td.FRDATE,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= td.TODATE AND HOLIDAY = 'N') TODATE,
            (MST.BALANCE-NVL(TR.NAMT,0)) NAMT,
            --(
               -- case when (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= td.TODATE AND HOLIDAY = 'N') = V_INDATE then 0
                -- else
                   FN_TDMASTINTRATIO2(MST.ACCTNO,(SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= td.TODATE
                            AND HOLIDAY = 'N'),(MST.BALANCE-NVL(TR.NAMT,0)))
                --end )
                INTAVLAMT,
            (mst.intpaid - nvl(TR2.namt,0)) INTPAID
    FROM   (
             SELECT * FROM TDMAST WHERE OPNDATE <= V_INDATE  AND
             (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE
AND HOLIDAY = 'N') >= V_INDATE AND DELTD <>'Y' and AFACCTNO LIKE V_STRAFACCTNO
           ) MST, AFMAST AF, CFMAST CF,
           (
              SELECT * FROM
              (
                   select orgamt,deltd,afacctno , acctno , (case when autornd = 'Y' then frdate else opndate end) opndate , frdate , todate,ACTYPE
                   from tdmast where afacctno LIKE V_STRAFACCTNO AND DELTD <>'Y'
                   union
                   select orgamt,deltd,afacctno , acctno , frdate opndate , frdate , todate , ACTYPE
                   from tdmasthist where afacctno LIKE V_STRAFACCTNO AND DELTD <>'Y'
              ) WHERE OPNDATE <= V_INDATE AND (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE
AND HOLIDAY = 'N') >= V_INDATE
           ) td,
           (
               SELECT DISTINCT TLGRPUSERS.GRPID  FROM TLPROFILES, TLGRPUSERS
               WHERE TLPROFILES.TLID LIKE decode(V_STRCAREBY,'0001','%',V_STRCAREBY)
               AND TLPROFILES.BRID = TLGRPUSERS.BRID
               AND TLPROFILES.TLID = TLGRPUSERS.TLID
           ) CARE,
           (
                SELECT TR.ACCTNO,
                       SUM(CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) NAMT
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
    WHERE MST.ACCTNO = TR.ACCTNO(+)
    AND MST.ACCTNO = TR2.ACCTNO(+)
    AND MST.OPNDATE <= V_INDATE
    and mst.acctno = td.acctno(+)
    --AND MST.STATUS IN ('N','A')
    AND MST.DELTD <> 'Y'
    AND (MST.BALANCE-NVL(TR.NAMT,0)) > 0
    AND MST.AFACCTNO = AF.ACCTNO
    AND AF.CUSTID = CF.CUSTID
    AND CF.CAREBY = CARE.GRPID
    AND MST.AFACCTNO LIKE V_STRAFACCTNO
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

