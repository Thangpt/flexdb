CREATE OR REPLACE PROCEDURE cf0062(
    PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
    OPT            IN       VARCHAR2,
    pv_BRID           IN       VARCHAR2,
    FMONTH         IN       VARCHAR2,
    TMONTH         IN       VARCHAR2,
    CAREBY         IN       VARCHAR2,
    I_BRID         IN       VARCHAR2
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
    l_count NUMBER;
    l_avg_vip1 NUMBER;
    l_avg_vip2 NUMBER;
    l_avg_vip3 NUMBER;
    l_avg_vip4 NUMBER;
    l_amt_vip1 NUMBER;
    l_amt_vip2 NUMBER;
    l_amt_vip3 NUMBER;
    l_amt_vip4 NUMBER;
    l_count_vip1 NUMBER;
    l_count_vip2 NUMBER;
    l_count_vip3 NUMBER;
    l_count_vip4 NUMBER;

BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := pv_BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := pv_BRID;
        end if;
    end if;

    V_FDATE := TO_DATE ('01'||FMONTH ,'DD/MM/RRRR');
    V_TDATE := LAST_DAY( TO_DATE ('01'||TMONTH ,'DD/MM/RRRR'));

    SELECT count(*) INTO l_count FROM sbcldr s WHERE s.holiday = 'N' AND s.cldrtype = '000' AND s.sbdate BETWEEN V_FDATE AND V_TDATE;

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
    BEGIN
        SELECT
            sum(CASE WHEN AVGNAV >= 10000000000 THEN AVGNAV ELSE 0 END),
            sum(CASE WHEN AVGNAV < 10000000000 AND AVGNAV >= 5000000000 THEN AVGNAV ELSE 0 END),
            sum(CASE WHEN AVGNAV < 5000000000 AND AVGNAV >= 2000000000 THEN AVGNAV ELSE 0 END),
            sum(CASE WHEN AVGNAV < 2000000000 THEN AVGNAV ELSE 0 END),

            count(CASE WHEN AVGNAV >= 10000000000 THEN custodycd END),
            count(CASE WHEN AVGNAV < 10000000000 AND AVGNAV >= 5000000000 THEN custodycd END),
            count(CASE WHEN AVGNAV < 5000000000 AND AVGNAV >= 2000000000 THEN custodycd END),
            count(CASE WHEN AVGNAV < 2000000000 THEN custodycd END),
            --od
            sum(CASE WHEN AVGNAV >= 10000000000 THEN nvl(od.amt,0) ELSE 0 END),
            sum(CASE WHEN AVGNAV < 10000000000 AND AVGNAV >= 5000000000 THEN nvl(od.amt,0) ELSE 0 END),
            sum(CASE WHEN AVGNAV < 5000000000 AND AVGNAV >= 2000000000 THEN nvl(od.amt,0) ELSE 0 END),
            sum(CASE WHEN AVGNAV < 2000000000 THEN nvl(od.amt,0) ELSE 0 END)
        INTO
            l_avg_vip1, l_avg_vip2, l_avg_vip3, l_avg_vip4,
            l_count_vip1, l_count_vip2, l_count_vip3, l_count_vip4,
            l_amt_vip1, l_amt_vip2, l_amt_vip3, l_amt_vip4
        FROM
        (
            SELECT custodycd, round(sum((realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT))/l_count) AVGNAV,
                   MAX(custid) custid
            FROM
            (
                select cf.custodycd, sum(v.realass) realass,
                       max(T0AMT)T0AMT, max(MRAMT) MRAMT, max(v.balance + v.avladvance) BALANCE,
                       max(v.depofeeamt) DEPOFEEAMT,
                       MAX(cf.custid) custid
                from (SELECT * FROM tbl_mr3007_log WHERE txdate BETWEEN V_FDATE AND V_TDATE) v,
                    cfmast cf                    
                where cf.custodycd = v.custodycd
                      AND cf.careby LIKE V_CAREBY --AND cf.brid LIKE V_STRI_BRID
                      AND cf.brid LIKE V_STRI_BRID
                      AND ((pv_BRID ='0001')OR (pv_BRID <>'0001' AND pv_brid LIKE V_STRI_BRID )
                          )                      
                group by cf.custodycd,v.afacctno 
            )
            WHERE (realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT) > 0
            GROUP BY custodycd
        ) ASS,
        (SELECT af.custid, sum(od.execamt) amt
          FROM vw_odmast_all od, afmast af
          WHERE od.execamt > 0 AND od.txdate BETWEEN V_FDATE AND V_TDATE
          AND od.AFACCTNO=af.acctno
          GROUP BY af.custid 
          ) od
      WHERE ass.custid=od.custid(+)
        ;
/*
            SELECT
            sum(CASE WHEN AVGNAV >= 10000000000 THEN nvl(amt,0) ELSE 0 END),
            sum(CASE WHEN AVGNAV < 10000000000 AND AVGNAV >= 5000000000 THEN nvl(amt,0) ELSE 0 END),
            sum(CASE WHEN AVGNAV < 5000000000 AND AVGNAV >= 2000000000 THEN nvl(amt,0) ELSE 0 END),
            sum(CASE WHEN AVGNAV < 2000000000 THEN nvl(amt,0) ELSE 0 END)

            INTO
                l_amt_vip1, l_amt_vip2, l_amt_vip3, l_amt_vip4
            FROM
            (
            
                SELECT cf.custodycd, sum(od.execamt) amt
                FROM cfmast cf, afmast af, (SELECT * FROM vw_odmast_all od WHERE od.execamt > 0 AND od.txdate BETWEEN V_FDATE AND V_TDATE) od
                WHERE cf.custid = af.custid AND af.acctno = od.afacctno
                    AND cf.careby LIKE V_CAREBY --AND cf.brid LIKE V_STRI_BRID
                GROUP BY cf.custodycd
            ) a,
            (
                SELECT custodycd,
                    round(sum((realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT))/l_count) AVGNAV
                FROM
                (
                    select cf.custodycd, sum(v.realass) realass,
                         T0AMT, MRAMT, v.balance + v.avladvance BALANCE,
                        v.depofeeamt DEPOFEEAMT
                    from (SELECT * FROM tbl_mr3007_log WHERE txdate BETWEEN V_FDATE AND V_TDATE) v,
                        cfmast cf
                    where cf.custodycd = v.custodycd
                        AND cf.careby LIKE V_CAREBY --AND cf.brid LIKE V_STRI_BRID
                    group by cf.custodycd, T0AMT, MRAMT,  BALANCE, DEPOFEEAMT, v.avladvance
                )
                WHERE (realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT) > 0
                AND brid LIKE V_STRI_BRID
                GROUP BY custodycd
            ) b
            WHERE a.custodycd(+) = b.custodycd
            ;*/

    EXCEPTION WHEN OTHERS THEN
     RETURN;
        l_avg_vip1 := 0; l_avg_vip2 := 0; l_avg_vip3 := 0; l_avg_vip4 := 0;
        l_amt_vip1 := 0; l_amt_vip2 := 0; l_amt_vip3 := 0; l_amt_vip4 := 0;
        l_count_vip1 := 0; l_count_vip2 := 0; l_count_vip3 := 0; l_count_vip4 := 0;
    END;

OPEN PV_REFCURSOR FOR
    SELECT a.fullname, a.custodycd, careby, brid, opndate, nvl(amt,0) NAV,
           a. AVGNAV,
        l_avg_vip1 l_avg_vip1, l_avg_vip2 l_avg_vip2, l_avg_vip3 l_avg_vip3, l_avg_vip4 l_avg_vip4,
        l_amt_vip1 l_amt_vip1, l_amt_vip2 l_amt_vip2, l_amt_vip3 l_amt_vip3, l_amt_vip4 l_amt_vip4,
        l_count_vip1 l_count_vip1, l_count_vip2 l_count_vip2, l_count_vip3 l_count_vip3, l_count_vip4 l_count_vip4,
        TO_CHAR(V_FDATE,'MM/RRRR') FMONTH, TO_CHAR(V_TDATE,'MM/RRRR') TMONTH
    FROM
        (SELECT round(sum((realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT))/l_count) AVGNAV,
                max(fullname) fullname,max(grpname) careby, max(brname) brid,
                max(opndate) opndate, custodycd
         FROM 
              (
                  select max(cf.fullname) fullname,
                         max(cf.custodycd) custodycd , max(tl.grpname) grpname, max(br.brname) brname, 
                         max(cf.opndate) opndate, 
                         sum(v.realass) realass,
                         max(T0AMT) T0AMT, 
                         max(MRAMT) MRAMT, max(v.balance + v.avladvance) BALANCE,
                         max(v.depofeeamt) DEPOFEEAMT
                  from (SELECT * FROM tbl_mr3007_log WHERE txdate BETWEEN V_FDATE AND V_TDATE) v,
                      cfmast cf, TLGROUPS tl, brgrp br
                  where cf.custodycd = v.custodycd AND cf.careby = tl.grpid AND cf.brid = br.brid
                      AND cf.careby LIKE V_CAREBY --AND br.brid LIKE V_STRI_BRID
                      AND cf.brid LIKE V_STRI_BRID
                      AND ((pv_BRID ='0001')OR (pv_BRID <>'0001' AND pv_brid LIKE V_STRI_BRID )
                          )  
                  group by v.afacctno
                         
              )WHERE  (realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT) > 0
              GROUP BY custodycd
          )a,
        (
            SELECT cf.custodycd, sum(od.execamt) amt
            FROM cfmast cf, afmast af, (SELECT * FROM vw_odmast_all od WHERE od.execamt > 0 AND od.txdate BETWEEN V_FDATE AND V_TDATE) od
            WHERE cf.custid = af.custid AND af.acctno = od.afacctno
                AND cf.careby LIKE V_CAREBY --AND cf.brid LIKE V_STRI_BRID
            GROUP BY cf.custodycd
        ) b
    WHERE a.custodycd = b.custodycd(+)   
    --GROUP BY fullname, a.custodycd, careby, brid, opndate, amt
    ORDER BY CASE WHEN  a. AVGNAV >= 10000000000 THEN 'A'
                  WHEN a. AVGNAV < 10000000000 AND a. AVGNAV >= 5000000000 THEN 'B'
                  WHEN a. AVGNAV < 5000000000 AND a. AVGNAV >= 2000000000 THEN 'C'
                  ELSE 'D' END, custodycd

;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
