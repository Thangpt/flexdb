CREATE OR REPLACE PROCEDURE ci0022 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   p_BANKNAME       IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2
)
IS

-- PURPOSE:
-- BANG KE SO DU UNG TRUOC TIEN BAN TOAN CONG TY
-- MODIFICATION HISTORY
-- PERSON               DATE                COMMENTS
-- ---------------      ----------          ----------------------
-- QUOCTA               13/01/2012          TAO THEO YC BVS
-- ---------------      ----------          ----------------------

    V_STROPT     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID    VARCHAR2 (40);                   -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);
   V_INT_DATE          DATE;
   V_RRTYPE            VARCHAR2(100);
   V_CUSTODYCD         VARCHAR2(100);

   V_CRRDATE           DATE;
    V_CUSTBANK          varchar2(10);

BEGIN

     V_STROPT := UPPER(OPT);
    V_INBRID := BRID;

    IF(V_STROPT = 'A') THEN
        V_STRBRID := '%';
    ELSE
        IF(V_STROPT = 'B') THEN
            SELECT BR.MAPID INTO V_STRBRID FROM BRGRP BR WHERE  BR.BRID = V_INBRID;
        ELSE
            V_STRBRID := BRID;
        END IF;
    END IF;

    IF p_BANKNAME = 'ALL' OR p_BANKNAME IS NULL THEN
        V_CUSTBANK := '%%';
    ELSE
        V_CUSTBANK := p_BANKNAME;
    END IF;

-- GET REPORT'S PARAMETERS

    IF (PV_CUSTODYCD <> 'ALL' OR PV_CUSTODYCD <> '' OR PV_CUSTODYCD <> NULL)
    THEN
         V_CUSTODYCD    :=    PV_CUSTODYCD;
    ELSE
         V_CUSTODYCD    :=    '%';
    END IF;


    V_INT_DATE          :=    TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    SELECT TO_DATE(SY.VARVALUE, SYSTEMNUMS.C_DATE_FORMAT) INTO V_CRRDATE
    FROM SYSVAR SY WHERE SY.VARNAME = 'CURRDATE' AND SY.GRNAME = 'SYSTEM';

-- Main report
OPEN PV_REFCURSOR FOR
    SELECT V_INT_DATE DATE_TRANS, nvl(cfb.shortname,'KBSV')  RRTYPE_NAME, AF.ACCTNO, CF.FULLNAME, CF.CUSTODYCD, SUM(NVL(ADS.AMT, 0) + NVL(ADS.FEEAMT, 0)- (case when V_INT_DATE >= ads.cleardt then ads.amt +ADS.FEEAMT  else 0 end)) AMT,
           SUM(CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '1' THEN (ads.amt + ads.feeamt) ELSE 0 END) T0,
           SUM(CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '2' THEN (ads.amt + ads.feeamt) ELSE 0 END) T1,
           SUM(CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '3' THEN (ads.amt + ads.feeamt) ELSE 0 END) T2,
           SUM(CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '4' THEN (ads.amt + ads.feeamt) ELSE 0 END) T3,
           SUM(CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '5' THEN (ads.amt + ads.feeamt) ELSE 0 END) T4,

           max(case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 0
                   then ad.cleardt
                   end ) T0date
        , sum(case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 0
                   then (ads.amt + ads.feeamt) else 0 end ) T0amt

        , max(case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 1
                   then ad.cleardt
                   end ) T1date
        , sum(case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 1
                   then (ads.amt + ads.feeamt) else 0 end ) T1amt

        , max(case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 2
                   then ad.cleardt  end ) T2date
        , sum(case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 2
                   then (ads.amt + ads.feeamt) else 0 end ) T2amt

        , max(case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 3
                   then ad.cleardt  end ) T3date
        , sum(case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 3
                   then (ads.amt + ads.feeamt) else 0 end ) T3amt

        , max(case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 4
                   then ad.cleardt  end ) T4date
        , sum(case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 4
                   then (ads.amt + ads.feeamt) else 0 end ) T4amt

        ,   SUM(NVL(ADS.FEEAMT, 0)-(case when V_INT_DATE >= ads.cleardt then ADS.FEEAMT  else 0 end)) FEEAMT
    FROM   adsource  ADS, vw_adschd_all ad, CFMAST CF, AFMAST AF, ALLCODE A1, cfmast cfb
    WHERE  CF.CUSTID      =    AF.CUSTID
    and ads.custbank=cfb.custid (+)
    AND ads.autoid = ad.autoid
    AND    AF.ACCTNO      =    ADS.ACCTNO
    AND    (ADS.AMT > 0   OR   ADS.PAIDDATE = V_CRRDATE)
    AND    ADS.txdate     <=   V_INT_DATE
    AND    A1.CDNAME      =    'RRTYPE'
    AND    A1.CDTYPE      =    'LN'
    AND    A1.CDVAL       =    ADS.RRTYPE
    AND (CF.BRID LIKE V_STRBRID OR INSTR(V_STRBRID,CF.BRID) <> 0)
--    AND    ADS.RRTYPE     LIKE V_RRTYPE
    AND  nvl( ADS.custbank,'KBSV') LIKE V_CUSTBANK
    AND    CF.CUSTODYCD   LIKE V_CUSTODYCD
    GROUP  BY  CF.CUSTODYCD, AF.ACCTNO, CF.FULLNAME,nvl(cfb.shortname,'KBSV')
    HAVING SUM(NVL(ADS.AMT, 0) + NVL(ADS.FEEAMT, 0)- (case when V_INT_DATE >= ads.cleardt then ads.amt +ADS.FEEAMT else 0 end)) <> 0


;
EXCEPTION
   WHEN OTHERS THEN
      RETURN;
END;
/

