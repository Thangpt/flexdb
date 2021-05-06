CREATE OR REPLACE PROCEDURE SE0036 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   TRADEPLACE     IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2

       )
IS

-- RP NAME : Danh sach nguoi so huu de nghi luu ky chung khoan 11B/LK
-- PERSON : QUYET.KIEU
-- DATE : 28/04/2011
-- COMMENTS : CREATE NEW
-- ---------   ------  -------------------------------------------
   V_SYMBOL  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_TRADEPLACE VARCHAR2 (15);
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

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
 Select TB.* ,BRID branchID from
(
SELECT
         nvl(A2.cdcontent ,'') san,
         nvl(  cf.fullname,'') fullname,
         nvl(cf.custodycd,'') custodycd,
         nvl(cf.idcode ,'')idcode,
         nvl( cf.iddate ,'')iddate,
           (Case when A1.cdval='001' then '1'
              when A1.cdval='005' then '3'
           else '4' end
        ) IDTYPE ,
         nvl(sb.symbol,'') codeid,
         nvl(iss.fullname,'') CK_Name,
         Sum(nvl(tl.msgamt,'')) So_luong,
         nvl(sb.PARVALUE,'') Menh_gia,
         nvl(PV_SYMBOL,'') PV_SYMBOL,
         V_TRADEPLACE V_TRADEPLACE ,
         V_CUSTODYCD V_CUSTODYCD,
         V_SYMBOL V_SYMBOL



  FROM   (

SELECT   txdate,
         SUBSTR (acctno, 0, 10) acctno,
         SUBSTR (acctno, 11, 6) codeid,
         namt msgamt
  FROM   setran
 WHERE       tltxcd = '2293'
         AND txcd = '0045'
         AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
         AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
UNION ALL
SELECT   txdate,
         SUBSTR (acctno, 0, 10) acctno,
         SUBSTR (acctno, 11, 6) codeid,
         namt msgamt
  FROM   setrana
 WHERE       tltxcd = '2293'
         AND txcd = '0045'
         AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
         AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
 ) tl,

         afmast af,
         cfmast cf,
         sbsecurities sb,
         issuers iss,
         ALLCODE A1,
         ALLCODE A2
 WHERE       tl.acctno = af.acctno
         AND af.custid = cf.custid
         AND tl.codeid = sb.codeid
         AND sb.tradeplace IN ('001', '002', '005')
         -----------------
         AND A1.CDTYPE = 'CF' AND A1.CDNAME = 'IDTYPE'
         AND A1.CDVAL = CF.IDTYPE
         AND iss.issuerid = sb.issuerid
         AND A2.CDTYPE = 'SE' AND A2.CDNAME = 'TRADEPLACE'
         AND A2.CDVAL = sb.tradeplace
         AND sb.tradeplace = A2.cdval
         AND Cf.CUSTODYCD LIKE V_CUSTODYCD
         AND sb.symbol    LIKE V_SYMBOL
         AND sb.tradeplace like V_TRADEPLACE
         --AND sb.tradeplace = PV_TRADEPLACE
        group by
        A2.cdcontent ,
        cf.fullname,
        cf.custodycd,
        cf.idcode,
        cf.iddate,
        A1.cdval,
        sb.symbol,
        iss.fullname,
        sb.PARVALUE,
        PV_SYMBOL
 ) TB
      ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

