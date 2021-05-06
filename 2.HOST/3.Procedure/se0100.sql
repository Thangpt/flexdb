CREATE OR REPLACE PROCEDURE se0100 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                      IN       VARCHAR2,
   BRID                     IN       VARCHAR2,
   F_DATE                   IN       VARCHAR2,
   T_DATE                   IN       VARCHAR2,
   PV_CUSTODYCD             IN       VARCHAR2,
   PV_AFACCTNO              IN       VARCHAR2,
   PV_SYMBOL                IN       VARCHAR2
   )
IS
-- ---------   ------  -------------------------------------------
   V_STROPTION         VARCHAR2 (5);                -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID           VARCHAR2 (40);               -- USED WHEN V_NUMOPTION > 0
   V_INBRID            VARCHAR2 (4);

   V_FDATE             DATE;
   V_TDATE             DATE;
   V_CUSTODYCD         VARCHAR2(100);
   V_AFACCTNO          VARCHAR2(100);
   V_SYMBOL            VARCHAR2(100);

BEGIN

-- GET REPORT'S PARAMETERS

    V_STROPTION := upper(OPT);
    V_INBRID := BRID;

    IF (V_STROPTION = 'A') THEN
         V_STRBRID := '%';
    ELSE if (V_STROPTION = 'B') then
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    END IF;

    IF (PV_CUSTODYCD <> 'ALL' OR PV_CUSTODYCD <> '')
    THEN
         V_CUSTODYCD := PV_CUSTODYCD;
    ELSE
         V_CUSTODYCD := '%';
    END IF;

    IF (PV_AFACCTNO <> 'ALL' OR PV_AFACCTNO <> '')
    THEN
         V_AFACCTNO := PV_AFACCTNO;
    ELSE
         V_AFACCTNO := '%';
    END IF;

    IF (PV_SYMBOL <> 'ALL' OR PV_SYMBOL <> '')
    THEN
         V_SYMBOL := PV_SYMBOL;
    ELSE
         V_SYMBOL := '%';
    END IF;

    V_FDATE              :=    TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_TDATE              :=    TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

OPEN PV_REFCURSOR FOR

SELECT cf.custodycd, af.acctno, cf.fullname, cos.txdate, sb.symbol, cos.prevcostprice*nvl(cos1.prevqtty,0) prevdcramt, cos.dcramt,
    nvl(cos1.prevqtty,0) prevdcrqtty, cos.dcrqtty, cos.ddroutqtty, cos.costprice, PV_AFACCTNO PV_AFACCTNO, PV_CUSTODYCD PV_CUSTODYCD,
    CASE WHEN PV_CUSTODYCD = 'ALL' THEN 'ALL' ELSE cf.fullname END PV_FULLNAME
FROM secostprice cos, cfmast cf, afmast af, sbsecurities sb, semast se,
    (
        SELECT prv.txdate, cos.acctno, cos.prevqtty
        FROM secostprice cos,
            (
                SELECT se1.txdate txdate, max(se2.txdate) txdate1, se1.acctno
                FROM (SELECT se1.* FROM secostprice se1 WHERE se1.txdate BETWEEN V_FDATE AND V_TDATE ORDER BY acctno, txdate) se1,
                    (SELECT se2.* FROM secostprice se2 WHERE se2.txdate BETWEEN V_FDATE AND V_TDATE ORDER BY acctno, txdate) se2
                WHERE se1.txdate > se2.txdate AND se1.acctno = se2.acctno
                GROUP BY se1.txdate, se1.acctno
                ORDER BY se1.acctno, se1.txdate
            ) prv
        WHERE cos.txdate = prv.txdate1 AND cos.acctno = prv.acctno AND cos.txdate BETWEEN V_FDATE AND V_TDATE
    ) cos1
WHERE cf.custid = af.custid AND se.acctno = cos.acctno
    AND cos.acctno = cos1.acctno(+) AND cos.txdate = cos1.txdate(+)
    AND SUBSTR(se.acctno,1,10) = af.acctno
    AND SUBSTR(se.acctno,11,6) = sb.codeid
    AND cos.txdate BETWEEN V_FDATE AND V_TDATE
    AND cf.custodycd = V_CUSTODYCD
    AND af.acctno LIKE V_AFACCTNO
    AND sb.symbol LIKE V_SYMBOL
ORDER BY cf.custodycd, af.acctno, cf.fullname, sb.symbol, cos.txdate

;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

