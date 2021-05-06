CREATE OR REPLACE PROCEDURE ln0077 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   I_DATE           IN      VARCHAR2,
   CUSTBANK         IN      VARCHAR2,
   --SERVICETYPE      IN       VARCHAR2,

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

    V_IN_DATE :=  I_DATE;


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
/*
    IF SERVICETYPE = 'ALL' OR SERVICETYPE IS NULL THEN
        V_SVTYPE := '%%';
    ELSE
        V_SVTYPE := SERVICETYPE;
    END IF;*/

    --select nvl(min(rlsdate),to_date(V_IN_DATE,'DD/MM/RRRR')+1) into l_INITRLSDATE from rlsrptlog_eod;
    V_IN_DATE := TO_DATE (I_DATE, 'DD/MM/YYYY');
    OPEN PV_REFCURSOR FOR
          SELECT  CF.fullname, A.cdcontent, CF.address, CF.dateofbirth, A0.cdcontent, CF.idcode, CF.custodycd,
        MAX(adtype.advrate) advrate, MAX(BANK.limitamt) HANMUC, MAX(BANK.txdate) NGAYCAP
        FROM AFMAST AF, CFMAST CF,  ALLCODE A, ALLCODE A0,AFTYPE, ADTYPE,  CFMAST CFB, bankcontractinfo BANK
        WHERE AF.custid = CF.custid
            AND AF.acctno = BANK.acctno
            and A.cdname = 'SEX' AND A.cdval = CF.SEX
            and a0.cdname = 'PROVINCE' and a0.cdval = cf.province
            AND AF.actype= AFTYPE.ACTYPE
            AND AFTYPE.adtype = ADTYPE.actype
            and cfb.shortname = BANK.bankcode
            and NVL( cfb.custid ,'KBSV') like V_CUSTBANK
            AND CF.custodycd LIKE V_CUSTODYCD
            AND AF.acctno LIKE V_AFACCTNO
            and substr(AF.acctno,1,4) like V_BRID
            and bank.txdate = V_IN_DATE
        GROUP BY CF.fullname, A.cdcontent, CF.address, CF.dateofbirth, A0.cdcontent, CF.idcode, CF.custodycd,BANK.bankcode
            ;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

