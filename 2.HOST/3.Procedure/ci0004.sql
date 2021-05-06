CREATE OR REPLACE PROCEDURE ci0004 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                      IN       VARCHAR2,
   BRID                     IN       VARCHAR2,
   F_DATE                   IN       VARCHAR2,
   T_DATE                   IN       VARCHAR2,
   PV_CUSTODYCD             IN       VARCHAR2,
   PV_AFACCTNO              IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- BAO CAO SO DU PHONG TOA TIEN
-- PERSON   DATE  COMMENTS
-- QUOCTA  10-01-2012  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID           VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID            VARCHAR2 (4);
   V_FDATE             DATE;
   V_TDATE             DATE;
   V_CUSTODYCD         VARCHAR2(100);
   V_AFACCTNO          VARCHAR2(100);

   V_CRRDATE           DATE;

BEGIN

    V_STROPTION := OPT;
    V_INBRID := BRID;

    IF  V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' then
        select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
    else
        V_STRBRID := V_INBRID;
    END IF;


-- GET REPORT'S PARAMETERS
    IF (PV_CUSTODYCD <> 'ALL' OR PV_CUSTODYCD <> '')
    THEN
         V_CUSTODYCD    :=    PV_CUSTODYCD;
    ELSE
         V_CUSTODYCD    :=    '%';
    END IF;

    IF (PV_AFACCTNO <> 'ALL' OR PV_AFACCTNO <> '')
    THEN
         V_AFACCTNO    :=    PV_AFACCTNO;
    ELSE
         V_AFACCTNO    :=    '%';
    END IF;

    V_FDATE              :=    TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_TDATE              :=    TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    SELECT TO_DATE(SY.VARVALUE, SYSTEMNUMS.C_DATE_FORMAT) INTO V_CRRDATE
    FROM SYSVAR SY WHERE SY.VARNAME = 'CURRDATE' AND SY.GRNAME = 'SYSTEM';

OPEN PV_REFCURSOR
FOR

SELECT * FROM
      (SELECT CF.CUSTID, CF.CUSTODYCD, CF.FULLNAME, CF.ACCTNO AFACCTNO, (CIBAL.EMKAMT - NVL(CI_MOVE_FR_CRR.CI_EMKAMT_FR_CRR, 0)) EMKAMT_BEGIN_BAL,
             NVL(CI_MOVE_FR_TD.CI_EMKAMT_LOCK, 0) CI_EMKAMT_LOCK, NVL(CI_MOVE_FR_TD.CI_EMKAMT_UNLOCK, 0) CI_EMKAMT_UNLOCK,
             (CIBAL.EMKAMT - NVL(CI_MOVE_FR_CRR.CI_EMKAMT_FR_CRR, 0)) + (NVL(CI_MOVE_FR_TD.CI_EMKAMT_LOCK, 0)) - (NVL(CI_MOVE_FR_TD.CI_EMKAMT_UNLOCK, 0)) EMKAMT_END_BAL
      FROM (SELECT CF.CUSTID, CF.CUSTODYCD, AF.ACCTNO, CF.FULLNAME FROM CFMAST CF, AFMAST AF
            WHERE CF.CUSTID = AF.CUSTID AND CF.CUSTODYCD IS NOT NULL
                and (af.brid like V_STRBRID or instr(V_STRBRID,af.brid) <> 0)
            ) CF
      INNER JOIN
      (
          -- TONG SO DU PHONG TOA HIEN TAI (TACH RIENG TUNG TK CUA TUNG KH)
          SELECT  CF.CUSTID, CF.CUSTODYCD, AF.ACCTNO AFACCTNO, NVL(CI.EMKAMT, 0) EMKAMT
          FROM    CFMAST CF, AFMAST AF, CIMAST CI
          WHERE   CF.CUSTID      =    AF.CUSTID
          AND     AF.ACCTNO      =    CI.AFACCTNO
          AND     CF.CUSTODYCD   LIKE V_CUSTODYCD
          AND     AF.ACCTNO      LIKE V_AFACCTNO
      ) CIBAL ON  CF.CUSTID = CIBAL.CUSTID AND CF.ACCTNO = CIBAL.AFACCTNO

      LEFT JOIN
      (
          -- TONG CAC PHAT SINH EMKAMT TU FROM_DATE DEN NGAY HIEN TAI
          SELECT  TR.custid, TR.acctno AFACCTNO,
                  SUM(CASE WHEN TR.txtype = 'D' THEN -TR.namt ELSE TR.namt END) CI_EMKAMT_FR_CRR
          FROM         VW_CITRAN_GEN TR
          WHERE        TR.busdate          BETWEEN V_FDATE AND V_CRRDATE
          AND          TR.custodycd        LIKE V_CUSTODYCD
          AND          TR.acctno           LIKE V_AFACCTNO
          AND          TR.field            = 'EMKAMT'
          GROUP BY     TR.custid, TR.acctno
      ) CI_MOVE_FR_CRR ON CF.CUSTID = CI_MOVE_FR_CRR.CUSTID AND CF.ACCTNO = CI_MOVE_FR_CRR.AFACCTNO

      LEFT JOIN
      (
          -- TONG CAC PHAT SINH EMKAMT TU FROM_DATE DEN TO_DATE
          SELECT  TR.custid, TR.acctno AFACCTNO,
                  SUM(CASE WHEN TR.txtype = 'C' THEN TR.namt ELSE 0 END) CI_EMKAMT_LOCK,
                  SUM(CASE WHEN TR.txtype = 'D' THEN TR.namt ELSE 0 END) CI_EMKAMT_UNLOCK
          FROM         VW_CITRAN_GEN TR
          WHERE        TR.busdate          BETWEEN V_FDATE AND V_TDATE
          AND          TR.custodycd        LIKE V_CUSTODYCD
          AND          TR.acctno           LIKE V_AFACCTNO
          AND          TR.field            = 'EMKAMT'
          GROUP BY     TR.custid, TR.acctno
      ) CI_MOVE_FR_TD ON CF.CUSTID = CI_MOVE_FR_TD.CUSTID AND CF.ACCTNO = CI_MOVE_FR_TD.AFACCTNO
      WHERE   CF.CUSTODYCD   LIKE   V_CUSTODYCD
      AND     CF.ACCTNO      LIKE   V_AFACCTNO
      ----AND    substr( CF.CUSTID, 1,4) LIKE V_STRBRID
      )
WHERE   EMKAMT_BEGIN_BAL <> 0 OR CI_EMKAMT_LOCK <> 0 OR CI_EMKAMT_UNLOCK <> 0 OR EMKAMT_END_BAL <> 0
ORDER   BY CUSTID, AFACCTNO

;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

