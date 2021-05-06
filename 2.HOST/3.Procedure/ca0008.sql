CREATE OR REPLACE PROCEDURE ca0008 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CACODE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
   )
IS
--
-- PURPOSE: THONG BAO V/V SO HUU QUYEN MUA CK
-- PERSON      DATE    COMMENTS
-- TRUONGLD   27-03-10  CREATE
-- MODIFY QUYET.KIEU 08-03-2011
-- MODIFY hien.vu    24-05-2011
-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
    V_INBRID            VARCHAR2 (4);
    V_STRAFACCTNO     VARCHAR2 (20);
    V_STRCUSTODYCD     VARCHAR2 (20);
    V_STRCACODE     VARCHAR2 (20);
BEGIN
   V_STROPTION := UPPER(OPT);
    V_INBRID := BRID;

    IF (V_STROPTION = 'A') THEN
         V_STRBRID := '%';
    ELSE IF (V_STROPTION = 'B') THEN
            SELECT BRGRP.MAPID INTO V_STRBRID FROM BRGRP WHERE BRGRP.BRID = V_INBRID;
        ELSE
            V_STRBRID := V_INBRID;
        END IF;
    END IF;                                         ---hoangnd loc theo pham vi

    IF (PV_AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;

     IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_STRCUSTODYCD := PV_CUSTODYCD;
   ELSE
      V_STRCUSTODYCD := '%%';
   END IF;


        IF (CACODE <> 'ALL')
   THEN
      V_STRCACODE := CACODE;
   ELSE
      V_STRCACODE := '%%';
   END IF;



   --GET REPORT'S PARAMETERS

OPEN PV_REFCURSOR FOR
    SELECT  CF.CUSTID, CF.CUSTODYCD, AF.ACCTNO, CF.FULLNAME , CF.ADDRESS, CF.phone ,nvl(mobile,phone) Mobile_phone,
            (case when cf.country = '234' then cf.idcode else cf.tradingcode end) IDCODE,
             (case when cf.country = '234' then cf.IDDATE else cf.tradingcodedt end) IDDATE, CF.IDPLACE,
             CA.REPORTDATE, CA.ACTIONDATE,CA.EXRATE, CA.RIGHTOFFRATE, CA.FRDATETRANSFER, CA.TODATETRANSFER,
             /*(substr(CA.EXRATE,instr(CA.EXRATE,'/') + 1,length(CA.EXRATE))) as Y,
             (substr(CA.EXRATE,0,instr(CA.EXRATE,'/') - 1)) as X,*/
             (substr(CA.RIGHTOFFRATE,instr(CA.RIGHTOFFRATE,'/') + 1,length(CA.RIGHTOFFRATE))) as Y,
             (substr(CA.RIGHTOFFRATE,0,instr(CA.RIGHTOFFRATE,'/') - 1)) as X,
             sum(SCH.TRADE) BALANCE
             --SCH.TRADE,to_number(substr(CA.EXRATE,instr(CA.EXRATE,'/') + 1,length(CA.EXRATE))), to_number(substr(CA.EXRATE,0,instr(CA.EXRATE,'/') - 1))
             -- ,trunc((SCH.TRADE*(substr(CA.EXRATE,instr(CA.EXRATE,'/') + 1,length(CA.EXRATE)))/(substr(CA.EXRATE,0,instr(CA.EXRATE,'/') - 1)))) QTTY
             ,sum(SCH.balance + SCH.pbalance) QTTY,
             sum(SCH.pqtty + SCH.qtty) QTTY1,
             CA.EXPRICE, CA.BEGINDATE,CA.DUEDATE, SEC.*, TOSEC.*
      FROM CFMAST CF, AFMAST AF, CAMAST CA, CASCHD SCH,
           (
               SELECT SB.CODEID, SB.ISSUERID, A1.cdcontent SECTYPE ,ISS.SHORTNAME IISSHORTNAME, ISS.FULLNAME ISSFULLNAME
               FROM SBSECURITIES SB, ISSUERS ISS,ALLCODE A1
               WHERE SB.ISSUERID = ISS.ISSUERID
               and SB.SECTYPE = A1.cdval and A1.cdname = 'SECTYPE'
               --ORDER BY SB.CODEIDd
            )SEC,
            (
               SELECT SB.CODEID TOCODEID, SB.ISSUERID TOISSUERID, A1.cdcontent TOSECTYPE ,ISS.SHORTNAME TOIISSHORTNAME, ISS.FULLNAME TOISSFULLNAME
               FROM SBSECURITIES SB, ISSUERS ISS,ALLCODE A1
               WHERE SB.ISSUERID = ISS.ISSUERID
               and SB.SECTYPE = A1.cdval and A1.cdname = 'SECTYPE'
               --ORDER BY SB.CODEIDd
            )toSEC
      WHERE CF.CUSTID = AF.CUSTID AND AF.STATUS IN ('A')
            AND SCH.AFACCTNO = AF.ACCTNO
            AND SCH.CAMASTID = CA.CAMASTID
            AND SCH.CODEID = CA.CODEID
            AND CA.CODEID = SEC.CODEID
            AND nvl(CA.TOCODEID,CA.CODEID) = TOSEC.TOCODEID
            AND SCH.DELTD <> 'Y'
            and catype='014'
            AND CF.CUSTODYCD like  V_STRCUSTODYCD
            AND AF.ACCTNO like  V_STRAFACCTNO
            AND CA.CAMASTID like  V_STRCACODE
            AND (AF.BRID LIKE V_STRBRID OR INSTR(V_STRBRID,AF.BRID) <> 0)     -- hoangnd loc theo pham vi
      GROUP BY CF.CUSTID, CF.CUSTODYCD, AF.ACCTNO, CF.FULLNAME , CF.ADDRESS, CF.phone ,nvl(mobile,phone) ,
            (case when cf.country = '234' then cf.idcode else cf.tradingcode end) ,
             (case when cf.country = '234' then cf.IDDATE else cf.tradingcodedt end) , CF.IDPLACE,
             CA.REPORTDATE, CA.ACTIONDATE,CA.EXRATE, CA.RIGHTOFFRATE, CA.FRDATETRANSFER, CA.TODATETRANSFER,
             (substr(CA.RIGHTOFFRATE,instr(CA.RIGHTOFFRATE,'/') + 1,length(CA.RIGHTOFFRATE))) ,
             (substr(CA.RIGHTOFFRATE,0,instr(CA.RIGHTOFFRATE,'/') - 1)) ,
             CA.EXPRICE, CA.BEGINDATE,CA.DUEDATE,
             SEC.CODEID, SEC.ISSUERID, SEC.SECTYPE ,SEC.IISSHORTNAME , SEC.ISSFULLNAME,
             toSEC.TOCODEID , toSEC.TOISSUERID , toSEC.TOSECTYPE ,toSEC.TOIISSHORTNAME , toSEC.TOISSFULLNAME
      ORDER BY CF.CUSTID

 ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

