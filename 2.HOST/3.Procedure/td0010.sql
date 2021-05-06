CREATE OR REPLACE PROCEDURE td0010 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD       IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2,
   PV_TDACCTNO      IN       VARCHAR2

   )
IS

   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_FRDATE         DATE;
   V_TODATE         DATE;
   V_STRCUSTODYCD    VARCHAR2 (10);
   V_STRAFACCTNO    VARCHAR2 (10);
   V_STRTDSRC    VARCHAR2 (1);
   V_STRTDACCTNO VARCHAR2 (20);

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


   IF(upper(PV_CUSTODYCD) <> 'ALL') THEN
        V_STRCUSTODYCD := trim(upper(PV_CUSTODYCD));
   ELSE
        V_STRCUSTODYCD := '%';
   END IF;

   IF(upper(PV_AFACCTNO) <> 'ALL') THEN
        V_STRAFACCTNO := trim(PV_AFACCTNO);
   ELSE
        V_STRAFACCTNO := '%';
   END IF;

   IF(upper(PV_TDACCTNO) <> 'ALL') THEN
        V_STRTDACCTNO := trim(PV_TDACCTNO);
   ELSE
        V_STRTDACCTNO := '%';
   END IF;



   V_FRDATE := to_date(F_DATE,'dd/mm/RRRR');
   V_TODATE := to_date(T_DATE,'dd/mm/RRRR');


   -- GET REPORT'S DATA

OPEN PV_REFCURSOR
       FOR
SELECT a.* , BRID v_brid FROM (
        SELECT td.acctno, TDP.TYPENAME, TD.TXDATE, TD.AFACCTNO, TDP.TDTERM || ' ' || A2.cdcontent TD_TERM,
        A1.cdcontent,
        CF.FULLNAME, CF.CUSTODYCD,  '1670' TLTXCD, TDP.ACTYPE, TD.ORGamt, td.description,
        (CASE WHEN td.opndate <> td.frdate THEN 1 ELSE 0 END) ISRENEW
        FROM TDMAST TD, TDTYPE TDP, AFMAST AF, CFMAST CF, ALLCODE A1, ALLCODE A2
        WHERE TD.ACTYPE = TDP.ACTYPE AND TD.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
        AND A1.CDNAME= 'TDSRC'  AND A1.CDVAL=TDP.TDSRC
        AND A2.CDNAME = 'TERMCD' AND A2.CDVAL=TDP.TERMCD
        AND A1.CDTYPE = 'TD' AND A2.CDTYPE = 'TD'
        AND cf.custodycd LIKE V_STRCUSTODYCD
        AND td.afacctno LIKE V_STRAFACCTNO
        AND TD.ACCTNO LIKE V_STRTDACCTNO
        and td.DELTD <>'Y'
        AND td.opndate>=V_FRDATE AND td.opndate<=V_TODATE
        ORDER BY  TD.TXDATE, CF.CUSTODYCD, td.acctno) a
        ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

