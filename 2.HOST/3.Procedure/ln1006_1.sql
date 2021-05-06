CREATE OR REPLACE PROCEDURE ln1006_1 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   p_OPT            IN       VARCHAR2,
   p_BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   p_BANKNAME       IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2
       )
IS

-- RP NAME : Giai Ngan Tien Vay
-- PERSON : LinhLNB
-- DATE : 04/04/2012
-- COMMENTS : Create New
-- ---------   ------  -------------------------------------------
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
    V_LIMITKBSV NUMBER;
    V_KBSVUSED NUMBER;
BEGIN
V_STROPTION := p_OPT;
    V_BRID := p_BRID;

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

    IF p_BANKNAME = 'ALL' OR p_BANKNAME IS NULL THEN
        V_CUSTBANK := '%%';
    ELSE
        V_CUSTBANK := p_BANKNAME;
    END IF;
-- GET REPORT'S DATA

BEGIN
SELECT SUM(lmamtmax) INTO V_LIMITKBSV FROM CFLIMIT
WHERE bankid  LIKE V_CUSTBANK AND lmsubtype ='ADV'


;
EXCEPTION WHEN OTHERS THEN
V_LIMITKBSV:=0;
END ;


BEGIN
SELECT SUM(AMT) INTO V_KBSVUSED FROM adsource
WHERE  nvl( CUSTBANK,'KBSV')  LIKE V_CUSTBANK
     AND  cleardt <= getduedate ( to_date(I_DATE,'DD/MM/RRRR'), 'B','001',2)
     AND cleardt > to_date(I_DATE,'DD/MM/RRRR');
EXCEPTION WHEN OTHERS THEN
V_KBSVUSED:=0;
END ;


OPEN PV_REFCURSOR FOR

SELECT V_LIMITKBSV LIMITKBSV,nvl(V_KBSVUSED,0) KBSVUSED,to_date(I_DATE,'DD/MM/RRRR') I_DATE, cleardt, FULLNAME,IDCODE,custodycd, MAX(contractno) contractno, MAX(bankacctno) bankacctno, MAX(limitamt) limitamt, max (amtu) amtu, SUM(amt) amt
FROM (

SELECT ad.cleardt, AD.BANKCODE, AD.FULLNAME,AD.IDCODE,AD.custodycd,NVL(BANK.contractno,'') contractno, NVL(BANK.bankacctno,'') bankacctno ,NVL(BANK.limitamt,0) limitamt,NVL(adu.amtu,0) amtu,ad.amt
from
   --so tien de nghi thau chi
  (
  SELECT  nvl(cfb.shortname,'KBSV') bankcode ,(af.acctno) ACCTNO, sum(ads.amt+ads.feeamt) amt,ads.cleardt,
    CF.FULLNAME ,cf.custodycd custodycd, CF.IDCODE
   from adsource ads,afmast af,cfmast cf ,cfmast cfb
    where ads.acctno = af.acctno
    AND af.custid = cf.custid
    and ads.custbank = cfb.custid(+)
    AND ADS.txdate = to_date(I_DATE,'DD/MM/RRRR')
    AND ads.deltd<>'Y'
    AND nvl( cfb.custid,'KBSV')  LIKE V_CUSTBANK
    AND cf.custodycd like V_CUSTODYCD
    AND af.acctno like V_AFACCTNO
  --  AND substr(af.acctno,1,4) like V_STRBRID
    AND case when V_STROPTION = 'A' then 1 else instr(V_STRBRID,substr(af.acctno,1,4)) END  <>0
    GROUP BY  CF.FULLNAME ,cf.custodycd , CF.IDCODE,cf.custid,af.acctno, cfb.shortname,ads.cleardt
    ) AD,
    (SELECT  acctno ,max(contractno) contractno, max(bankacctno) bankacctno,( bankcode) bankcode,max(txdate) txdate, max(limitamt)limitamt
      FROM   bankcontractinfo
      WHERE typecont='ADV'
      GROUP BY acctno,bankcode
    )BANK,
--so tien da giai ngan ung truoc
         (
    SELECT cf.custodycd ,nvl(cfb.shortname,'KBSV') bankcode, sum(ads.amt) amtu
    from adsource ads,afmast af, cfmast cfb,cfmast  cf
    where ads.acctno = af.acctno
    and ads.custbank = cfb.custid(+)
     AND  ADS.cleardt <= getduedate ( to_date(I_DATE,'DD/MM/RRRR'), 'B','001',2)
     AND ADS.cleardt > to_date(I_DATE,'DD/MM/RRRR')
     AND ads.deltd<>'Y'
     AND  nvl( cfb.custid,'KBSV') LIKE V_CUSTBANK
     AND af.custid = cf.custid
    GROUP BY cf.custodycd,cfb.shortname
         ) ADU
where ad.acctno = BANK.acctno(+)
AND ad.bankcode = BANK.bankcode(+)
AND ad.custodycd = ADU.custodycd(+)
AND ad.bankcode = ADU.bankcode(+)
)
GROUP BY FULLNAME,IDCODE,custodycd, BANKCODE,cleardt
ORDER BY custodycd
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

