CREATE OR REPLACE PROCEDURE ca1012 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   CACODE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2
  )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO QUYEN MUA
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- LOCPT       20141208
-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);
    V_STRCACODE    VARCHAR2 (20);
    V_STRAFACCTNO   VARCHAR2 (20);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   IF (CACODE <> 'ALL')
   THEN
      V_STRCACODE := CACODE;
   ELSE
      V_STRCACODE := '%%';
   END IF;

      IF (AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO := AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;




OPEN PV_REFCURSOR
   FOR
    SELECT  AF.ACCTNO, CF.CUSTODYCD, AFT.TYPENAME, CF.FULLNAME, NVL(CF.MOBILESMS,CF.MOBILE) MOBILESMS,
            CASE WHEN CF.IDTYPE='009' THEN CF.TRADINGCODE ELSE CF.IDCODE END IDCODE, SC.BALANCE QTTY,
            SB.Exerciseratio   CARATE,
            CA.EXPRICE, CA.ACTIONDATE,
            (case
             when af.isfct= 'N' or (CASE WHEN sc.pitratemethod='##' THEN ca.pitratemethod ELSE sc.pitratemethod END) <> 'SC'  then
              sc.AMT
             else
             (sc.AMT -
              LEAST(round(CA.pitrate * SC.BALANCE * CA.EXPRICE / (to_number(SUBSTR(SB.EXERCISERATIO,0,INSTR(SB.EXERCISERATIO,'/') - 1)) / to_number( SUBSTR(SB.EXERCISERATIO,INSTR(SB.EXERCISERATIO,'/')+1,LENGTH(SB.EXERCISERATIO))))/100), SC.AMT)
             )
           end) AMT,
             A1.CDCONTENT CASTATUS, A2.CDCONTENT AFSTATUS,
            A3.CDCONTENT SCHDVAT, CA.REPORTDATE, SB.SYMBOL,
            ( CASE WHEN (CASE WHEN sc.pitratemethod='##' THEN ca.pitratemethod ELSE sc.pitratemethod END) ='SC' and af.isfct= 'Y' 
             THEN 1 ELSE 0 END) *
            LEAST(round(CA.pitrate * SC.BALANCE * CA.EXPRICE / (to_number(SUBSTR(SB.EXERCISERATIO,0,INSTR(SB.EXERCISERATIO,'/') - 1)) / to_number( SUBSTR(SB.EXERCISERATIO,INSTR(SB.EXERCISERATIO,'/')+1,LENGTH(SB.EXERCISERATIO))))/100), SC.AMT) TAXAMT
    FROM VW_CAMAST_ALL CA, VW_CASCHD_ALL SC, CFMAST CF, AFMAST AF, AFTYPE AFT, SBSECURITIES SB,
        (SELECT * FROM ALLCODE WHERE CDNAME='CASTATUS' AND CDTYPE='CA') A1,
        (SELECT * FROM ALLCODE WHERE CDNAME='STATUS' AND CDTYPE='CF') A2,
        (SELECT * FROM ALLCODE WHERE CDNAME='PITRATEMETHOD' AND CDTYPE='CA') A3
    WHERE CA.CAMASTID=SC.CAMASTID
    AND CF.CUSTID=AF.CUSTID
    AND SC.AFACCTNO=AF.ACCTNO
    AND AF.ACTYPE=AFT.ACTYPE
    AND CA.STATUS=A1.CDVAL
    AND AF.STATUS=A2.CDVAL
    AND SC.CODEID=SB.CODEID
    AND CA.PITRATEMETHOD = A3.CDVAL
    AND CA.CATYPE='028'
    AND SC.DELTD <> 'Y'
    AND CA.CAMASTID=V_STRCACODE
    AND AF.ACCTNO like V_STRAFACCTNO ;


EXCEPTION
   WHEN OTHERS
   THEN
   -- plog.error ('CA1012: ' || SQLERRM || dbms_utility.format_error_backtrace);
      RETURN;
END;  -- PROCEDURE
/
