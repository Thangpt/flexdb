CREATE OR REPLACE PROCEDURE cf0020 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2

)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- HUYNQ        CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);              -- USED WHEN V_NUMOPTION > 0

   v_text varchar2(1000);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
-- insert into temp_bug(text) values('CF0001');commit;
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS



   -- END OF GETTING REPORT'S PARAMETERS
   -- GET REPORT'S DATA

      OPEN PV_REFCURSOR
       FOR

                    SELECT AF.OPNDATE,CF.custodycd,CF.idcode,CF.address,
                    CF.fullname,CF.iddate,CF.idplace,CF.CUSTTYPE,CTRY.CDCONTENT COUNTRY,tl.txdate
                    FROM     CFMAST CF, Vw_Tllog_All TL,
                   (SELECT CUSTID, acctno, MIN( OPNDATE) OPNDATE
                    FROM AFMAST
                    GROUP BY CUSTID, acctno  )AF, ALLCODE CTRY
                    WHERE    AF.CUSTID = CF.CUSTID
                         AND      CF.custodycd IS NOT NULL
                         AND      CTRY.CDTYPE='CF'
                         AND      CTRY.CDNAME='COUNTRY'
                         AND      CF.COUNTRY=CTRY.CDVAL
                         and tl.msgacct =af.acctno
                         and tl.tltxcd ='2249'
                         AND      tl.txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
                         AND      tl.txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                         AND      SUBSTR(CF.CUSTID,1,4)  LIKE  V_STRBRID;
--           v_text:='1 ';



 EXCEPTION
   WHEN OTHERS
   THEN
    --insert into temp_bug(text) values('CF0001');commit;
      RETURN;
END;                                                              -- PROCEDURE
/

