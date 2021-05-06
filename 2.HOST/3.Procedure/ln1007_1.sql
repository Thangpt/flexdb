CREATE OR REPLACE PROCEDURE ln1007_1 (
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
    --V_SVTYPE            VARCHAR2(5);
    V_IN_DATE           VARCHAR2(15);
    --V_SIGNTYPE          VARCHAR2(10);
    V_BRID              VARCHAR2(4);
    V_CUSTODYCD       VARCHAR2(10);
    V_AFACCTNO         VARCHAR2(10);
    l_INITRLSDATE date;
    v_clearday  NUMBER;             --T2_HoangfND add


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

    SELECT to_number(fn_getsysclearday(TO_DATE (i_date, 'DD/MM/YYYY'))) INTO v_clearday FROM dual; --T2_HoangfND add

 OPEN PV_REFCURSOR FOR

SELECT to_date(V_IN_DATE,'DD/MM/RRRR') TX2, to_date(V_IN_DATE,'DD/MM/RRRR') cleardt, SUM( paidamt) paidamt,max (nvl(amtad,0)) amtad
     ,MAX( ACCTNO) ACCTNO, khachhang khachhang,custodycd custodycd, IDCODE,MAX(contractno)contractno
     ,MAX(bankacctno) bankacctno, MAX(limitamt) limitamt,MAX( txdate ) txdate
FROM (

SELECT ( ad.amt) paidamt, (nvl(adsp.amtad,0)) amtad
     ,( ad.ACCTNO) ACCTNO, ad.khachhang ,ad.custodycd , ad.IDCODE,( bank.contractno)
     ,(bank.bankacctno) bankacctno, (bank.limitamt) limitamt,( bank.txdate ) txdate, AD.BANKCODE
from
  (
   SELECT  nvl(cfb.shortname,'KBSV') bankcode ,(af.acctno) ACCTNO, SUM( ads.amt+ads.feeamt) amt,
    CF.FULLNAME khachhang,cf.custodycd custodycd, CF.IDCODE
   from adsource ads, cfmast cfb,afmast af,cfmast cf
   where ads.custbank = cfb.custid(+)
     AND ads.acctno = af.acctno
    AND af.custid =cf.custid
    AND ADS.cleardt = to_date(V_IN_DATE,'DD/MM/RRRR')
    AND NVL( cfb.CUSTID  ,'KBSV') LIKE V_CUSTBANK
    GROUP BY cf.custid, CF.FULLNAME ,cf.custodycd , CF.IDCODE,af.acctno, cfb.shortname
     ) ad
     ,
     (SELECT  acctno ,max(contractno) contractno, max(bankacctno) bankacctno,( bankcode) bankcode,max(txdate) txdate, max(limitamt)limitamt
      FROM   bankcontractinfo
      WHERE typecont='ADV'
      GROUP BY acctno,bankcode
      )BANK
      ,
     (select nvl(cfb.shortname,'KBSV') bankcode ,(cf.custodycd) custodycd,sum( ads.amt+ads.feeamt) amtad
     from adsource ads, cfmast cfb,afmast af,cfmast cf
     where   ads.custbank = cfb.custid(+)
      AND ads.acctno = af.acctno
      AND af.custid =cf.custid
     AND NVL( cfb.CUSTID  ,'KBSV') LIKE V_CUSTBANK
     --AND  ADS.cleardt <= getduedate ( to_date(I_DATE,'DD/MM/RRRR'), 'B','001',3)
     AND  ADS.cleardt <= getduedate ( to_date(I_DATE,'DD/MM/RRRR'), 'B','001',v_clearday) --T2_HoangND edit
     AND ADS.cleardt > to_date(I_DATE,'DD/MM/RRRR')
     GROUP BY  cfb.shortname,cf.custodycd
     ) adsp
where  ad.CUSTODYCD = adsp.CUSTODYCD(+)
    AND ad.bankcode  = adsp.bankcode(+)
    AND ad.ACCTNO = bank.ACCTNO(+)
    AND ad.bankcode  = bank.bankcode(+)
    and ad.custodycd like V_CUSTODYCD
    and ad.acctno like V_AFACCTNO

--    and substr(ad.acctno,1,4) like V_STRBRID
    AND case when V_STROPTION = 'A' then 1 else instr(V_STRBRID,substr(ad.acctno,1,4)) END  <>0
 )
 GROUP BY     khachhang ,custodycd , IDCODE,  BANKCODE
 ORDER BY CUSTODYCD
;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

