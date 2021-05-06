CREATE OR REPLACE PROCEDURE cf0016 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   BRGID          IN       VARCHAR2,
   REFNAME        IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   21-NOV-06  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);              -- USED WHEN V_NUMOPTION > 0
   V_STRAFACCTNO     VARCHAR2 (16);
   V_STRBRGID           VARCHAR2 (10);
   V_STRREFNAME         VARCHAR2 (20);

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

  IF (BRGID  <> 'ALL')
   THEN
      V_STRBRGID  := BRGID;
   ELSE
      V_STRBRGID := '%%';
   END IF;

    IF (REFNAME  <> 'ALL')
   THEN
      V_STRREFNAME  := REFNAME;
   ELSE
      V_STRREFNAME := '%%';
   END IF;

   -- END OF GETTING REPORT'S PARAMETERS

   -- GET REPORT'S DATA
  /* IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN*/
    OPEN PV_REFCURSOR
        FOR
        SELECT
         (CASE WHEN length(AUTH1) > 0 AND length(AUTH2) > 0 AND length(AUTH3) > 0 THEN ''--'IV' remove type IV

         --else
            when length(AUTH1) > 0 OR length(AUTH2) > 0 OR length(AUTH3) > 0 then
              trim(AUTH1
              || case when length(AUTH1) > 0 and length(AUTH2) > 0 then ',' else '' end
              || AUTH2
              || case when length(AUTH1||AUTH2) > 0 and length(AUTH3) > 0 then ',' else '' end
              || AUTH3
              )
         when length(auth7) >0 then 'Khac'
          END )
           LINKAUTH,FULLNAME ,CUSTODYCD  ,IDCODE ,ADDRESS ,FULLNAMEAUTH ,LICENSENO ,VALDATE ,EXPDATE,ADDRESSAUT

   FROM(
        SELECT
         (CASE WHEN CF.AUT4='4'or CF.AUT5='5' then 'I' end) AUTH1,
         (CASE WHEN CF.AUT3='3' then 'II' end) AUTH2,
         (CASE WHEN CF.AUT9='9' then 'III' end) AUTH3,
         (CASE WHEN CF.AUT10='10' then 'IV' end)AUTH4,
         (CASE WHEN CF.AUT11='11' then 'V' end) AUTH5,
         (CASE WHEN CF.AUT1='1'and CF.AUT2='2' and CF.AUT3='3' and CF.AUT4='4'
               and CF.AUT5='5' and CF.AUT6='6'and CF.AUT7='7'
               and CF.AUT8='8'and CF.AUT9='9' and CF.AUT10='10'and CF.AUT11='11'
               then 'VI' end) AUTH6,
         (CASE WHEN CF.AUT1='1'or CF.AUT2='2' or CF.AUT6='6' then '12' end) AUTH7,
               CF.FULLNAME ,CF.CUSTODYCD  ,CF.IDCODE ,CF.ADDRESS ,
               CF.FULLNAMEAUTH  FULLNAMEAUTH ,CF.LICENSENO ,CF.VALDATE ,CF.EXPDATE, CF.ADDRESSAUT
        FROM ( SELECT
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,1,1) ='Y' THEN '1'END)AUT1,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,2,1) ='Y' THEN '2'END)AUT2,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,3,1) ='Y' THEN '3'END)AUT3,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,4,1) ='Y' THEN '4'END)AUT4,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,5,1) ='Y' THEN '5'END)AUT5,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,6,1) ='Y' THEN '6'END)AUT6,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,7,1) ='Y' THEN '7'END)AUT7,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,8,1) ='Y' THEN '8'END)AUT8,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,9,1) ='Y' THEN '9'END)AUT9,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,10,1) ='Y' THEN '10'END)AUT10,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,11,1) ='Y' THEN '11'END)AUT11,
             CF.FULLNAME ,AF.ACCTNO ,CF.CUSTODYCD  ,CF.IDCODE ,CF.IDDATE , CF.ADDRESS,
                   CFA.FULLNAME  FULLNAMEAUTH ,CFAM.IDCODE LICENSENO ,CFA.VALDATE ,CFA.EXPDATE,CFAM.ADDRESS ADDRESSAUT
             FROM CFMAST  CF, AFMAST AF , CFAUTH CFA, CFMAST CFAM
             WHERE  CF.CUSTID =AF.CUSTID
             AND AF.ACCTNO = CFA.ACCTNO
             AND CFA.CUSTID = CFAM.CUSTID
             AND SUBSTR(AF.ACCTNO,1,4) LIKE  V_STRBRGID
             AND CFA.VALDATE <=TO_DATE(T_DATE ,'DD/MM/YYYY')
             AND CFA.VALDATE >=TO_DATE(F_DATE ,'DD/MM/YYYY')
             AND AF.custid like V_STRREFNAME
             ORDER BY AF.acctno ,CF.SHORTNAME)CF)
             ;
   /*ELSE
      OPEN PV_REFCURSOR
      FOR

         SELECT
          trim(AUTH1
          || case when length(AUTH1) > 0 and length(AUTH2) > 0 then ',' else '' end
          || AUTH2
          || case when length(AUTH1||AUTH2) > 0 and length(AUTH3) > 0 then ',' else '' end
          || AUTH3
          || case when length(AUTH1||AUTH2||AUTH3) > 0 and length(AUTH4) > 0 then ',' else '' end
          || AUTH4
          || case when length(AUTH1||AUTH2||AUTH3||AUTH4) > 0 and length(AUTH5) > 0 then ',' else '' end
          || AUTH5
          ||case when length(AUTH1||AUTH2||AUTH3||AUTH4||AUTH5) > 0 and length(AUTH6) > 0 then ',' else '' end
          ||AUTH6
          )

           LINKAUTH,FULLNAME ,CUSTODYCD  ,IDCODE ,ADDRESS ,FULLNAMEAUTH ,LICENSENO ,VALDATE ,EXPDATE,ADDRESSAUT

   FROM(
        SELECT
         (CASE WHEN CF.AUT4='4'or CF.AUT5='5' then 'I' end) AUTH1,
         (CASE WHEN CF.AUT3='3' then 'II' end) AUTH2,
         (CASE WHEN CF.AUT9='9' then 'III' end) AUTH3,
         (CASE WHEN CF.AUT10='10' then 'IV' end)AUTH4,
         (CASE WHEN CF.AUT11='11' then 'V' end) AUTH5,
         (CASE WHEN CF.AUT1='1'and CF.AUT2='2' and CF.AUT1='1'and CF.AUT3='3'
               and CF.AUT4='4'and CF.AUT5='5' and CF.AUT6='6'and CF.AUT7='7'
               and CF.AUT8='8'and CF.AUT9='9' and CF.AUT10='10'and CF.AUT11='11'
               then 'VI' end) AUTH6,
         (CASE WHEN CF.AUT1='1'or CF.AUT2='2' or CF.AUT6='6' then '' end) AUTH7,
               CF.FULLNAME ,CF.CUSTODYCD  ,CF.IDCODE ,CF.ADDRESS ,
               CF.FULLNAMEAUTH  FULLNAMEAUTH ,CF.LICENSENO ,CF.VALDATE ,CF.EXPDATE, CF.ADDRESSAUT
        FROM ( SELECT
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,1,1) ='Y' THEN '1'END)AUT1,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,2,1) ='Y' THEN '2'END)AUT2,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,3,1) ='Y' THEN '3'END)AUT3,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,4,1) ='Y' THEN '4'END)AUT4,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,5,1) ='Y' THEN '5'END)AUT5,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,6,1) ='Y' THEN '6'END)AUT6,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,7,1) ='Y' THEN '7'END)AUT7,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,8,1) ='Y' THEN '8'END)AUT8,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,9,1) ='Y' THEN '9'END)AUT9,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,10,1) ='Y' THEN '10'END)AUT10,
             ( CASE WHEN SUBSTR(CFA.LINKAUTH,11,1) ='Y' THEN '11'END)AUT11,
             CF.FULLNAME ,AF.ACCTNO ,CF.CUSTODYCD  ,CF.IDCODE ,CF.IDDATE , CF.ADDRESS,
                   CFA.FULLNAME  FULLNAMEAUTH ,CFA.LICENSENO ,CFA.VALDATE ,CFA.EXPDATE,CFA.ADDRESS ADDRESSAUT
             FROM CFMAST  CF, AFMAST AF , CFAUTH CFA
             WHERE  CF.CUSTID =AF.CUSTID
             AND AF.ACCTNO =CFA.ACCTNO
             AND SUBSTR(AF.ACCTNO,1,4) LIKE  V_STRBRGID
             AND CFA.VALDATE <=TO_DATE(T_DATE ,'DD/MM/YYYY')
             AND CFA.VALDATE >=TO_DATE(F_DATE ,'DD/MM/YYYY')
             AND AF.custid like V_STRREFNAME
             ORDER BY AF.acctno ,CF.SHORTNAME)CF)
                 ;

   END IF;*/
 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

