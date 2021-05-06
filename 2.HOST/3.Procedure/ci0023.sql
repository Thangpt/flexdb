CREATE OR REPLACE PROCEDURE ci0023 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
)
IS

-- PURPOSE:
-- BANG KE SO DU UNG TRUOC TIEN BAN THEO TUNG TAI KHOAN KH
-- MODIFICATION HISTORY
-- PERSON               DATE                COMMENTS
-- ---------------      ----------          ----------------------
-- QUOCTA               13/01/2012          TAO THEO YC BVS
-- ---------------      ----------          ----------------------

   V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID           VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_INT_DATE          DATE;
   V_CUSTODYCD         VARCHAR2(100);
   V_AFACCTNO          VARCHAR2(100);

   V_CRRDATE           DATE;

BEGIN

    V_STROPTION := OPT;

    IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
    THEN
         V_STRBRID := BRID;
    ELSE
         V_STRBRID := '%%';
    END IF;

-- GET REPORT'S PARAMETERS

    IF (PV_CUSTODYCD <> 'ALL' OR PV_CUSTODYCD <> '' OR PV_CUSTODYCD <> NULL)
    THEN
         V_CUSTODYCD    :=    PV_CUSTODYCD;
    ELSE
         V_CUSTODYCD    :=    '%';
    END IF;

    IF (PV_AFACCTNO <> 'ALL' OR PV_AFACCTNO <> '' OR PV_AFACCTNO <> NULL)
    THEN
         V_AFACCTNO     :=    PV_AFACCTNO;
    ELSE
         V_AFACCTNO     :=    '%';
    END IF;

    V_INT_DATE          :=    TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    SELECT TO_DATE(SY.VARVALUE, SYSTEMNUMS.C_DATE_FORMAT) INTO V_CRRDATE
    FROM SYSVAR SY WHERE SY.VARNAME = 'CURRDATE' AND SY.GRNAME = 'SYSTEM';

-- Main report
OPEN PV_REFCURSOR FOR

    SELECT V_INT_DATE DATE_TRANS, AF.ACCTNO, CF.FULLNAME, CF.CUSTODYCD, (NVL(ADS.AMT, 0) + NVL(ADS.FEEAMT, 0))
    -(case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 0
                   then (ads.amt + ads.feeamt) else 0 end )
     AMT,
           AD.ODDATE, ADS.TXDATE,
           (CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '1' THEN (ads.amt + ads.feeamt) ELSE 0 END) T0,
           (CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '2' THEN (ads.amt + ads.feeamt) ELSE 0 END) T1,
           (CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '3' THEN (ads.amt + ads.feeamt) ELSE 0 END) T2,
           (CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '4' THEN (ads.amt + ads.feeamt) ELSE 0 END) T3,
           (CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '5' THEN (ads.amt + ads.feeamt) ELSE 0 END) T4,
           (NVL(ADS.FEEAMT, 0)) FEEAMT

        ,  (case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 0
                   then AD.cleardt
                   end ) T0date
        , (case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 0
                   then (ads.amt + ads.feeamt) else 0 end ) T0amt

        , (case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 1
                   then AD.cleardt
                   end ) T1date
        , (case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 1
                   then (ads.amt + ads.feeamt) else 0 end ) T1amt

        , (case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 2
                   then AD.cleardt  end ) T2date
        , (case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 2
                   then (ads.amt + ads.feeamt) else 0 end ) T2amt

        , (case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 3
                   then AD.cleardt  end ) T3date
        , (case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 3
                   then (ads.amt + ads.feeamt) else 0 end ) T3amt

        , (case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 4
                   then AD.cleardt  end ) T4date
        , (case when (select count(*) from sbcldr where sbdate between V_INT_DATE and TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000') -  1 = 4
                   then (ads.amt + ads.feeamt) else 0 end ) T4amt
    FROM  adsource ADS,  VW_ADSCHD_ALL AD, CFMAST CF, AFMAST AF
    WHERE  CF.CUSTID      =    AF.CUSTID
    AND ADS.AUTOID = AD.AUTOID
    AND    AF.ACCTNO      =    ADS.ACCTNO
    AND    (ADS.AMT > 0   OR   ADS.PAIDDATE = V_CRRDATE)
    AND    AD.ODDATE     <=   V_INT_DATE
    AND    CF.CUSTODYCD   LIKE V_CUSTODYCD
    AND    AF.ACCTNO      LIKE V_AFACCTNO
    and (CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '1' THEN (ads.amt + ads.feeamt) ELSE 0 END) +
           (CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '2' THEN (ads.amt + ads.feeamt) ELSE 0 END) +
           (CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '3' THEN (ads.amt + ads.feeamt) ELSE 0 END) +
           (CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '4' THEN (ads.amt + ads.feeamt) ELSE 0 END) +
           (CASE WHEN ((SELECT COUNT(*) FROM SBCLDR WHERE sbdate BETWEEN V_INT_DATE AND TO_DATE(ads.cleardt, SYSTEMNUMS.C_DATE_FORMAT) AND holiday = 'N' AND cldrtype = '000')) = '5' THEN (ads.amt + ads.feeamt) ELSE 0 END)
        <> 0
;
EXCEPTION
   WHEN OTHERS THEN
      RETURN;
END;
/

