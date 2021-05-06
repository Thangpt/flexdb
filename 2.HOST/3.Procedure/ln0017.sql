CREATE OR REPLACE PROCEDURE ln0017 (
     PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   I_DATE           IN      VARCHAR2,
   CUSTBANK         IN      VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2
       )
IS

--
-- PURPOSE: BAO CAO THANH TOAN TIEN VAY
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS
-- THENN        05-APR-2012 CREATED
-- ---------    ------      -------------------------------------------

    V_STROPTION         VARCHAR2  (5);
    V_STRBRID           VARCHAR2(100);
    V_CUSTBANK          varchar2(10);
    V_IN_DATE           VARCHAR2(15);
    V_BRID              VARCHAR2(4);
    V_CUSTODYCD       VARCHAR2(10);
    V_AFACCTNO         VARCHAR2(10);

BEGIN
    -- GET REPORT'S PARAMETERS
    V_STROPTION := OPT;
    V_BRID := BRID;

    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%%';
    ELSIF V_STROPTION = 'B' AND V_BRID <> 'ALL' AND V_BRID IS NOT NULL THEN
        SELECT MAPID INTO V_STRBRID FROM BRGRP WHERE BRID = V_BRID;
    ELSIF V_STROPTION = 'S' AND V_BRID <> 'ALL' AND V_BRID IS NOT NULL THEN
        V_STRBRID := V_BRID;
    ELSE
        V_STRBRID := V_BRID;
    END IF;

    V_IN_DATE := I_DATE;


    IF PV_CUSTODYCD = 'ALL' OR PV_CUSTODYCD IS NULL THEN
       V_CUSTODYCD := '%%';
    ELSE
        V_CUSTODYCD := UPPER( PV_CUSTODYCD);
    END IF;

    IF PV_AFACCTNO = 'ALL' OR PV_AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := UPPER( PV_AFACCTNO);
    END IF;

    IF CUSTBANK = 'ALL' OR CUSTBANK IS NULL THEN
        V_CUSTBANK := '%%';
    ELSE
        V_CUSTBANK := CUSTBANK;
    END IF;

-- GET REPORT'S DATA

OPEN PV_REFCURSOR FOR

SELECT fullname, idcode,custodycd, MAX( NVL(BANK.bankacctno,'')) bankacctno,sum(amt) amt  FROM
(    SELECT cf.fullname, cf.idcode,cf.custodycd, SUM (amt +ads.feeamt) amt,nvl(cfb.shortname,'KBSV') bankcode,af.acctno
    FROM adsource ads, afmast af, cfmast cf,  cfmast cfb
    WHERE ads.acctno = af.acctno
        AND af.custid = cf.custid
        AND ADS.txdate = to_date(V_IN_DATE,'DD/MM/RRRR')
        and CF.custodycd like V_CUSTODYCD
        and AF.acctno like V_AFACCTNO
        and  ads.custbank = cfb.custid(+)
        and NVL( cfb.custid ,'KBSV') like V_CUSTBANK
        and substr(AF.acctno,1,4) like V_BRID
   GROUP BY cf.fullname, cf.idcode,af.acctno,cfb.shortname,cf.custodycd) ad ,
      (SELECT  acctno ,max(contractno) contractno, max(bankacctno) bankacctno,( bankcode) bankcode,max(txdate) txdate, max(limitamt)limitamt
      FROM   bankcontractinfo
      WHERE typecont='ADV'
      GROUP BY acctno,bankcode
      )BANK
 WHERE ad.acctno =BANK.acctno(+)
   and ad.bankcode =BANK.bankcode(+)
GROUP BY fullname, idcode,ad.bankcode,custodycd
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

