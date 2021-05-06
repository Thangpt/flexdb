CREATE OR REPLACE PROCEDURE ln0005 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_TLID        IN       VARCHAR2,
   PV_ACTYPE      IN       VARCHAR2,
   I_CUSTODYCD    IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BANG KE PHAT VAY BAO LANH.
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH   17-MAY-10  CREATED
-- HUONG.TTD 27-OCT-10 UPDATED (them ma giao dich)
-- ---------   ------  -------------------------------------------

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_STRI_CUSTODYCD     VARCHAR2 (20);
   V_STRI_AFACCTNO      VARCHAR2 (20);
   V_STRBRGID           VARCHAR2 (10);
   V_STRI_ACTYPE        VARCHAR2(20);
   V_STRI_TLID          VARCHAR2(20);

   V_FROMDATE     DATE;
   V_TODATE       DATE;

BEGIN
   V_STROPTION := OPT;

   IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' THEN
      V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
   ELSE
      V_STRBRID := BRID;
   END IF;

   IF(I_CUSTODYCD <> 'ALL') THEN
     V_STRI_CUSTODYCD := I_CUSTODYCD;
   ELSE
     V_STRI_CUSTODYCD := '%';
   END IF;

   IF(PV_AFACCTNO <> 'ALL') THEN
     V_STRI_AFACCTNO := PV_AFACCTNO;
   ELSE
     V_STRI_AFACCTNO := '%';
   END IF;

   IF(PV_ACTYPE <> 'ALL') THEN
      V_STRI_ACTYPE := PV_ACTYPE;
   ELSE
      V_STRI_ACTYPE := '%';
   END IF;

   IF(PV_TLID <> 'ALL') THEN
      V_STRI_TLID := PV_TLID;
   ELSE
      V_STRI_TLID := '%';
   END IF;

   V_FROMDATE  :=    TO_DATE(F_DATE,'DD/MM/YYYY');
   V_TODATE    :=    TO_DATE(T_DATE,'DD/MM/YYYY');

OPEN PV_REFCURSOR
FOR
SELECT SCHD.AUTOID, SCHD.ALLOCATEDDATE, CF.CUSTODYCD, SCHD.ACCTNO , CF.FULLNAME, AFT.ACTYPE,
    TL.TLFULLNAME, SCHD.TLID, SCHD.ALLOCATEDLIMIT, SCHD.RETRIEVEDLIMIT, --- MAX(RET.TXDATE),
    SUM(CASE WHEN RET.TXDATE = SCHD.ALLOCATEDDATE THEN nvl(RET.RETRIEVEDAMT,0) ELSE 0 END) RETRIEVED_T0,
    SUM(CASE WHEN RET.TXDATE between getduedate(SCHD.ALLOCATEDDATE,'B','001',1)
        and getduedate(SCHD.ALLOCATEDDATE,'B','001',2) THEN nvl(RET.RETRIEVEDAMT,0) ELSE 0 END) RETRIEVED_T1_T2,
    SUM(CASE WHEN RET.TXDATE > getduedate(SCHD.ALLOCATEDDATE,'B','001',2) THEN
        nvl(RET.RETRIEVEDAMT,0) ELSE 0 END) RETRIEVED_AFT_T2,
    SUM(SCHD.ALLOCATEDLIMIT - SCHD.RETRIEVEDLIMIT) ALLOCATEDLIMIT_LEFT
FROM TLPROFILES TL, CFMAST CF, AFMAST AF, AFTYPE AFT,
  (select txdate, autoid, sum(retrievedamt) retrievedamt from RETRIEVEDT0LOG group by txdate, autoid ) RET,
  (
      SELECT * FROM T0LIMITSCHDHIST
      union all
      SELECT * FROM T0LIMITSCHD
  ) SCHD
WHERE CF.CUSTID = AF.CUSTID
    AND AF.ACCTNO = SCHD.ACCTNO
    AND SCHD.TLID = TL.TLID
    AND AF.ACTYPE = AFT.ACTYPE
    AND SCHD.AUTOID = RET.AUTOID(+)
    AND SCHD.TLID LIKE V_STRI_TLID
    AND AF.ACTYPE LIKE V_STRI_ACTYPE
    AND CF.CUSTODYCD LIKE V_STRI_CUSTODYCD
    AND SCHD.ACCTNO LIKE V_STRI_AFACCTNO
    AND SCHD.ALLOCATEDDATE BETWEEN V_FROMDATE AND V_TODATE
GROUP BY SCHD.AUTOID, SCHD.ALLOCATEDDATE, CF.CUSTODYCD, SCHD.ACCTNO , CF.FULLNAME, AFT.ACTYPE,
    TL.TLFULLNAME, SCHD.TLID, SCHD.ALLOCATEDLIMIT, SCHD.RETRIEVEDLIMIT
ORDER BY SCHD.ALLOCATEDDATE
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

