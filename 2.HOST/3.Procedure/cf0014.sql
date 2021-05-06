CREATE OR REPLACE PROCEDURE cf0014 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   CIACCTNO        IN       VARCHAR2,
   REFNAME         IN       VARCHAR2,
   CAREBY           IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- MINHTK   21-NOV-06  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION          VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID            VARCHAR2 (4);              -- USED WHEN V_NUMOPTION > 0
   V_STRCIACCTNO        VARCHAR2 (20);
   V_STRREFNAME         VARCHAR2 (20);
   V_STRCAREBY          VARCHAR2 (20);
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
   IF (CIACCTNO  <> 'ALL')
   THEN
      V_STRCIACCTNO  := CIACCTNO;
   ELSE
      V_STRCIACCTNO := '%%';
   END IF;

    IF (REFNAME  <> 'ALL')
   THEN
      V_STRREFNAME  := REFNAME;
   ELSE
      V_STRREFNAME := '%%';
   END IF;

    IF (CAREBY  <> 'ALL')
   THEN
      V_STRCAREBY  := CAREBY;
   ELSE
      V_STRCAREBY:= '%%';
   END IF;

 -- END OF GETTING REPORT'S PARAMETERS
  OPEN PV_REFCURSOR
     FOR
        SELECT CF.FULLNAME ,AF.ACCTNO ,CF.CUSTODYCD  ,CF.IDCODE ,CF.IDDATE ,
        CFA.FULLNAME  FULLNAMEAUTH ,CFA.LICENSENO ,CFA.VALDATE ,CFA.EXPDATE , CF.refname refname
        FROM CFMAST  CF, AFMAST AF , CFAUTH CFA
        WHERE  CF.CUSTID =AF.CUSTID
        AND AF.ACCTNO =CFA.ACCTNO
        AND AF.ACCTNO  LIKE V_STRCIACCTNO
        and CFA.EXPDATE < to_date ( I_DATE, 'DD/MM/YYYY' )
        AND SUBSTR(AF.acctno,1,4) LIKE  V_STRBRID
        and NVL(Cf.refname,'-') like V_STRREFNAME
        and NVL(cf.careby,'-') like V_STRCAREBY
        ORDER BY cf.shortname  ;

 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

