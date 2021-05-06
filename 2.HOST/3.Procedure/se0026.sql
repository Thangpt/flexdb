CREATE OR REPLACE PROCEDURE se0026 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2
)
IS

-- RP NAME : BAO CAO BANG KE CHUNG KHOAN GIAO DICH LO LE
-- ---------   ------  -------------------------------------------
   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_STRSYMBOL VARCHAR2 (10);

BEGIN
-- GET REPORT'S PARAMETERS


   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;


   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%';
   END IF;

   IF  (UPPER(PV_SYMBOL) <> 'ALL' AND PV_SYMBOL IS NOT NULL)
   THEN
         V_STRSYMBOL := PV_SYMBOL;
   ELSE
      V_STRSYMBOL := '%';
   END IF;

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR

SELECT san, fullname, idcode, iddate, custodycd, codeid, sum(sl_lole) sl_lole, price FROM
(
    SELECT
        (case when sb.tradeplace='002' then '1. HNX'
        when sb.tradeplace='001' then '2. HOSE'
        when sb.tradeplace='005' then '3. UPCOM' else '' end) san,
        nvl(  cf.fullname,'') fullname,
        nvl(cf.idcode ,'')idcode,
        nvl( cf.iddate ,'')iddate,
        nvl(cf.custodycd,'') custodycd,
        nvl(sb.symbol,'') codeid,
        nvl(tl.qtty,'') sl_lole,
        tl.price price
    FROM afmast af, cfmast cf, sbsecurities sb,
    (
        SELECT a.txdate, a.txnum, substr(a.acctno,1,10) afacctno, substr(a.acctno,11,6) codeid, a.acctno, a.qtty, a.price
        FROM seretail a
        WHERE a.log_8815_8816 = '8815'
            AND a.txdate_8815_8816 BETWEEN to_date(F_DATE,'DD/MM/RRRR') AND to_date(T_DATE,'DD/MM/RRRR')
    ) tl
    WHERE tl.afacctno = af.acctno
        AND af.custid = cf.custid
        AND tl.codeid = sb.codeid
        AND sb.tradeplace IN ('001', '002', '005')
        AND Cf.CUSTODYCD LIKE V_CUSTODYCD
        AND tl.afacctno LIKE V_STRAFACCTNO
        AND SB.SYMBOL LIKE V_STRSYMBOL
    ORDER BY cf.custodycd
)
GROUP BY san, fullname, idcode, iddate, custodycd, codeid, price
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

