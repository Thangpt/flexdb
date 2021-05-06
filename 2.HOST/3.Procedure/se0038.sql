CREATE OR REPLACE PROCEDURE se0038 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   TRADEPLACE     IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PLSENT         IN       VARCHAR2
)
IS

-- RP NAME : Danh sach nguoi so huu de nghi luu ky chung khoan 11B/LK
-- PERSON              DATE            COMMENTS
-- QUYET.KIEU          05/04/2011      CREATE
-- VUNGUYENVAN         30/07/2015      EDIT
-- ---------   ------  -------------------------------------------
   V_SYMBOL  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_TRADEPLACE VARCHAR2 (15);
   V_STRPLSENT VARCHAR2 (100);
BEGIN
-- GET REPORT'S PARAMETERS


   IF  (TRADEPLACE <> 'ALL')
   THEN
         V_TRADEPLACE := TRADEPLACE;
   ELSE
        V_TRADEPLACE := '%';
   END IF;


   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;


   IF  (PV_SYMBOL <> 'ALL')
   THEN
         V_SYMBOL := PV_SYMBOL;
   ELSE
      V_SYMBOL := '%';
   END IF;
    V_STRPLSENT := PLSENT;

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
SELECT V_STRPLSENT PLSENT, (
          case  when sb.tradeplace='002' then ' HNX'
                when sb.tradeplace='001' then ' HOSE'
                when sb.tradeplace='005' then ' UPCOM'
                when sb.tradeplace='007' then ' TRÁI PHI?U CHUYÊN BI?T'
                when sb.tradeplace='004' then ' TRÁI PHI?U NGO?I T?'
                when sb.tradeplace='008' then ' TÍN PHI?U'
                when sb.tradeplace='009' then ' ÐCCNY' else '' end) san,
          se.Codeid ,
          REPLACE(sb.symbol,'_WFT','') symbol,
          nvl(sb.Parvalue,0) Parvalue ,
          sum(nvl(se.msgamt,0)) msgamt,
          (  sum(nvl(se.msgamt,0)) * nvl(sb.Parvalue,0)) Gia_tri,
          (case when substr(cf.custodycd,4,1)='F' then '01213.091'
                when substr(cf.custodycd,4,1)='P' then '01231.091'
                else '01212.091' end) ACCTNO,
          (case when substr(cf.custodycd,4,1)='F' then '01213.091'
                when substr(cf.custodycd,4,1)='P' then '01211.091'
                else '01212.091' end) TK_GHICO
 FROM (
        SELECT   txdate,
             SUBSTR (acctno, 0, 10) acctno,
             SUBSTR (acctno, 11, 6) codeid,
             namt msgamt
        FROM   vw_setran_all
        WHERE       tltxcd = '2233'
             AND txcd = '0043'
             AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
             AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')

         ) SE ,
         (
           SELECT nVL(SB1.Parvalue,SB.Parvalue) Parvalue,  NVL(SB1.TRADEPLACE,SB.TRADEPLACE) TRADEPLACE,
                  NVL(SB.SECTYPE,SB1.SECTYPE) SECTYPE ,SB.CODEID,
                  nvl(sb1.symbol,sb.symbol) symbol, nvl(sb1.CODEID,sb.CODEID) REFCODEID
           FROM sbsecurities sb, sbsecurities sb1
           WHERE nvl(sb.refcodeid,' ') = sb1.codeid(+)
           ) sb, afmast af,  cfmast cf


  WHERE se.codeid = sb.codeid
         AND se.acctno = af.acctno
         AND af.custid = cf.custid
         AND sb.tradeplace IN ('001', '002', '005','004','007','008','009')
         AND Cf.CUSTODYCD  LIKE V_CUSTODYCD
         AND sb.symbol     LIKE V_SYMBOL
         AND sb.tradeplace like V_TRADEPLACE

 GROUP BY
            sb.tradeplace , se.Codeid , REPLACE(sb.symbol,'_WFT','') ,
            sb.Parvalue, substr(cf.custodycd,4,1)
      ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

