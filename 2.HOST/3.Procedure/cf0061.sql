-- Start of DDL Script for Procedure HOSTMSBST.CF0061
-- Generated 05/12/2018 5:53:06 PM from HOSTMSBST@FLEX_111

CREATE OR REPLACE 
PROCEDURE cf0061 (
    PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
    OPT            IN       VARCHAR2,
    BRID           IN       VARCHAR2,
    FMONTH         IN       VARCHAR2,
    TMONTH         IN       VARCHAR2,
    CAREBY         IN       VARCHAR2,
    I_BRID         IN       VARCHAR2,
    OPNDATE        IN       VARCHAR2
 )
IS
--

    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);      -- USED WHEN V_NUMOPTION > 0

    V_TDATE     DATE;
    V_FDATE   DATE;

    V_CAREBY     VARCHAR2 (40);
    V_STRI_BRID  VARCHAR2 (40);
    l_avg_vip NUMBER;
    l_avg_vip1 NUMBER;
    l_avg_vip2 NUMBER;
    l_avg_vip3 NUMBER;
    l_avg_vip4 NUMBER;
    l_amt_vip NUMBER;
    l_amt_vip1 NUMBER;
    l_amt_vip2 NUMBER;
    l_amt_vip3 NUMBER;
    l_amt_vip4 NUMBER;
    l_count_vip NUMBER;
    l_count_vip1 NUMBER;
    l_count_vip2 NUMBER;
    l_count_vip3 NUMBER;
    l_count_vip4 NUMBER;
    l_month     NUMBER;
BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

    V_FDATE := TO_DATE ('01'||FMONTH ,'DD/MM/RRRR');
    V_TDATE := LAST_DAY( TO_DATE ('01'||TMONTH ,'DD/MM/RRRR'));

    IF (CAREBY <> 'ALL')
    THEN
      V_CAREBY := CAREBY;
    ELSE
      V_CAREBY := '%%';
    END IF;

    IF (I_BRID <> 'ALL')
    THEN
      V_STRI_BRID := I_BRID;
    ELSE
      V_STRI_BRID := '%%';
    END IF;

    IF to_char(V_TDATE,'RRRR') = to_char(V_FDATE,'RRRR') THEN
        l_month := ((to_char(V_TDATE,'MM') - to_char(V_FDATE,'MM'))+1);
    ELSE
        l_month := ((to_char(V_TDATE,'MM')+(12*(to_char(V_TDATE,'RRRR') - to_char(V_FDATE,'RRRR'))) - to_char(V_FDATE,'MM'))+1);
    END IF;

    BEGIN
        IF OPNDATE = 'ALL' THEN
            SELECT
                sum(CASE WHEN avgamt >= 20000000000 THEN avgamt ELSE 0 END),
                sum(CASE WHEN avgamt < 20000000000 AND avgamt >= 10000000000 THEN avgamt ELSE 0 END),
                sum(CASE WHEN avgamt < 10000000000 AND avgamt >= 5000000000 THEN avgamt ELSE 0 END),
                sum(CASE WHEN avgamt < 5000000000 THEN avgamt ELSE 0 END),

                sum(CASE WHEN avgamt >= 20000000000 THEN amt ELSE 0 END),
                sum(CASE WHEN avgamt < 20000000000 AND avgamt >= 10000000000 THEN amt ELSE 0 END),
                sum(CASE WHEN avgamt < 10000000000 AND avgamt >= 5000000000 THEN amt ELSE 0 END),
                sum(CASE WHEN avgamt < 5000000000 THEN amt ELSE 0 END),

                count(CASE WHEN avgamt >= 20000000000 THEN custodycd END),
                count(CASE WHEN avgamt < 20000000000 AND avgamt >= 10000000000 THEN custodycd END),
                count(CASE WHEN avgamt < 10000000000 AND avgamt >= 5000000000 THEN custodycd END),
                count(CASE WHEN avgamt < 5000000000 THEN custodycd END)
            INTO
                l_avg_vip1, l_avg_vip2, l_avg_vip3, l_avg_vip4,
                l_amt_vip1, l_amt_vip2, l_amt_vip3, l_amt_vip4,
                l_count_vip1, l_count_vip2, l_count_vip3, l_count_vip4
            FROM
            (
                SELECT cf.fullname, cf.custodycd, cf.brid, cf.careby, cf.opndate,
                sum(od.execamt) amt, round(sum(od.execamt)/l_month) avgamt
                FROM cfmast cf, afmast af, (SELECT * FROM vw_odmast_all od WHERE od.execamt > 0 AND od.txdate BETWEEN V_FDATE AND V_TDATE) od
                WHERE cf.custid = af.custid AND af.acctno = od.afacctno
                    AND cf.careby LIKE V_CAREBY AND cf.brid LIKE V_STRI_BRID
                GROUP BY cf.fullname, cf.custodycd, cf.brid, cf.careby, cf.opndate
            );
        ELSE
            SELECT
                sum(CASE WHEN avgamt >= 20000000000 THEN avgamt ELSE 0 END),
                sum(CASE WHEN avgamt < 20000000000 AND avgamt >= 10000000000 THEN avgamt ELSE 0 END),
                sum(CASE WHEN avgamt < 10000000000 AND avgamt >= 5000000000 THEN avgamt ELSE 0 END),
                sum(CASE WHEN avgamt < 5000000000 THEN avgamt ELSE 0 END),

                sum(CASE WHEN avgamt >= 20000000000 THEN amt ELSE 0 END),
                sum(CASE WHEN avgamt < 20000000000 AND avgamt >= 10000000000 THEN amt ELSE 0 END),
                sum(CASE WHEN avgamt < 10000000000 AND avgamt >= 5000000000 THEN amt ELSE 0 END),
                sum(CASE WHEN avgamt < 5000000000 THEN amt ELSE 0 END),

                count(CASE WHEN avgamt >= 20000000000 THEN custodycd END),
                count(CASE WHEN avgamt < 20000000000 AND avgamt >= 10000000000 THEN custodycd END),
                count(CASE WHEN avgamt < 10000000000 AND avgamt >= 5000000000 THEN custodycd END),
                count(CASE WHEN avgamt < 5000000000 THEN custodycd END)
            INTO
                l_avg_vip1, l_avg_vip2, l_avg_vip3, l_avg_vip4,
                l_amt_vip1, l_amt_vip2, l_amt_vip3, l_amt_vip4,
                l_count_vip1, l_count_vip2, l_count_vip3, l_count_vip4
            FROM
            (
                SELECT cf.fullname, cf.custodycd, cf.brid, cf.careby, cf.opndate,
                sum(od.execamt) amt, round(sum(od.execamt)/l_month) avgamt
                FROM cfmast cf, afmast af, (SELECT * FROM vw_odmast_all od WHERE od.execamt > 0 AND od.txdate BETWEEN V_FDATE AND V_TDATE) od
                WHERE cf.custid = af.custid AND af.acctno = od.afacctno
                    AND cf.opndate BETWEEN V_FDATE AND V_TDATE
                    AND cf.careby LIKE V_CAREBY AND cf.brid LIKE V_STRI_BRID
                GROUP BY cf.fullname, cf.custodycd, cf.brid, cf.careby, cf.opndate
            );
        END IF;
        SELECT
            sum(avgamt), sum(amt), count(custodycd)
        INTO
            l_avg_vip, l_amt_vip, l_count_vip
        FROM
        (
            SELECT cf.fullname, cf.custodycd, cf.brid, cf.careby, cf.opndate,
            sum(od.execamt) amt, round(sum(od.execamt)/l_month) avgamt
            FROM cfmast cf, afmast af, (SELECT * FROM vw_odmast_all od WHERE od.execamt > 0 AND od.txdate BETWEEN V_FDATE AND V_TDATE) od
            WHERE cf.custid = af.custid AND af.acctno = od.afacctno
                AND cf.opndate BETWEEN V_FDATE AND V_TDATE
                AND cf.careby LIKE V_CAREBY AND cf.brid LIKE V_STRI_BRID
            GROUP BY cf.fullname, cf.custodycd, cf.brid, cf.careby, cf.opndate
        );
    EXCEPTION WHEN OTHERS THEN
     RETURN;
        l_avg_vip := 0; l_amt_vip := 0; l_count_vip := 0;
        l_avg_vip1 := 0; l_avg_vip2 := 0; l_avg_vip3 := 0; l_avg_vip4 := 0;
        l_amt_vip1 := 0; l_amt_vip2 := 0; l_amt_vip3 := 0; l_amt_vip4 := 0;
        l_count_vip1 := 0; l_count_vip2 := 0; l_count_vip3 := 0; l_count_vip4 := 0;
    END;

IF OPNDATE = 'ALL' THEN
OPEN PV_REFCURSOR FOR
    SELECT cf.fullname, cf.custodycd, br.brname brid, tl.grpname careby, cf.opndate,
    sum(od.execamt) amt, round(sum(od.execamt)/l_month) avgamt,
        l_avg_vip l_avg_vip, l_amt_vip l_amt_vip, l_count_vip l_count_vip,
        l_avg_vip1 l_avg_vip1, l_avg_vip2 l_avg_vip2, l_avg_vip3 l_avg_vip3, l_avg_vip4 l_avg_vip4,
        l_amt_vip1 l_amt_vip1, l_amt_vip2 l_amt_vip2, l_amt_vip3 l_amt_vip3, l_amt_vip4 l_amt_vip4,
        l_count_vip1 l_count_vip1, l_count_vip2 l_count_vip2, l_count_vip3 l_count_vip3, l_count_vip4 l_count_vip4,
        TO_CHAR(V_FDATE,'MM/RRRR') FMONTH, TO_CHAR(V_TDATE,'MM/RRRR') TMONTH
    FROM cfmast cf, afmast af, (SELECT * FROM vw_odmast_all od WHERE od.execamt > 0 AND od.txdate BETWEEN V_FDATE AND V_TDATE) od, brgrp br, tlgroups tl
    WHERE cf.custid = af.custid AND af.acctno = od.afacctno AND cf.brid = br.brid(+) AND cf.careby = tl.grpid(+)
        AND cf.careby LIKE V_CAREBY AND cf.brid LIKE V_STRI_BRID
    GROUP BY cf.fullname, cf.custodycd, br.brname, tl.grpname, cf.opndate
    ORDER BY CASE WHEN sum(od.execamt)/l_month >= 20000000000 THEN 'A'
                WHEN sum(od.execamt)/l_month < 20000000000 AND sum(od.execamt)/l_month >= 10000000000 THEN 'B'
                WHEN sum(od.execamt)/l_month < 10000000000 AND sum(od.execamt)/l_month >= 5000000000 THEN 'C'
                ELSE 'D' END, cf.custodycd

;
ELSE
OPEN PV_REFCURSOR FOR
    SELECT cf.fullname, cf.custodycd, br.brname brid, tl.grpname careby, cf.opndate,
    sum(od.execamt) amt, round(sum(od.execamt)/l_month) avgamt,
        l_avg_vip l_avg_vip, l_amt_vip l_amt_vip, l_count_vip l_count_vip,
        l_avg_vip1 l_avg_vip1, l_avg_vip2 l_avg_vip2, l_avg_vip3 l_avg_vip3, l_avg_vip4 l_avg_vip4,
        l_amt_vip1 l_amt_vip1, l_amt_vip2 l_amt_vip2, l_amt_vip3 l_amt_vip3, l_amt_vip4 l_amt_vip4,
        l_count_vip1 l_count_vip1, l_count_vip2 l_count_vip2, l_count_vip3 l_count_vip3, l_count_vip4 l_count_vip4,
        TO_CHAR(V_FDATE,'MM/RRRR') FMONTH, TO_CHAR(V_TDATE,'MM/RRRR') TMONTH
    FROM cfmast cf, afmast af, (SELECT * FROM vw_odmast_all od WHERE od.execamt > 0 AND od.txdate BETWEEN V_FDATE AND V_TDATE) od, brgrp br, tlgroups tl
    WHERE cf.custid = af.custid AND af.acctno = od.afacctno AND cf.brid = br.brid(+) AND cf.careby = tl.grpid(+)
        AND cf.opndate BETWEEN V_FDATE AND V_TDATE
        AND cf.careby LIKE V_CAREBY AND cf.brid LIKE V_STRI_BRID
    GROUP BY cf.fullname, cf.custodycd, br.brname, tl.grpname, cf.opndate
    ORDER BY CASE WHEN sum(od.execamt)/l_month >= 20000000000 THEN 'A'
                WHEN sum(od.execamt)/l_month < 20000000000 AND sum(od.execamt)/l_month >= 10000000000 THEN 'B'
                WHEN sum(od.execamt)/l_month < 10000000000 AND sum(od.execamt)/l_month >= 5000000000 THEN 'C'
                ELSE 'D' END, cf.custodycd

;
END IF;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/



-- End of DDL Script for Procedure HOSTMSBST.CF0061
