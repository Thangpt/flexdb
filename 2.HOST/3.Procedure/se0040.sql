CREATE OR REPLACE PROCEDURE se0040 (
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

-- RP NAME : BANG KE CHUNG KHOAN GIAI TOA CAM CO 21B/LK
-- PERSON : QUYET.KIEU -- DATE :   07/05/2011 -- COMMENTS : CREATE NEW
-- PERSON : VU.NGUYEN  ---DATE :   30/07/2015 -- COMMENTS : EDIT
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
SELECT V_STRPLSENT PLSENT, '1' sectype ,  (case
          when sb.tradeplace='002' then '1. HNX'
          when sb.tradeplace='001' then '2. HOSE'
          when sb.tradeplace='005' then '3. UPCOM'
          WHEN SB.TRADEPLACE='007' THEN '4. TRÁI PHI?U CHUYÊN BI?T'
          WHEN SB.TRADEPLACE='004' THEN '5. TRÁI PHI?U NGO?I T?'
          WHEN SB.TRADEPLACE='008' THEN '6. TÍN PHI?U'
          WHEN SB.TRADEPLACE='009' THEN '7. ÐCCNY'
            else '' end) san,
          Cf.fullname ,
          cf.custodycd So_TK_luuKY,
          cf.IDcode IDcode,
          Cf.iddate Ngay_cap,
          se.acctno Afacctno ,
          se.txdate Ngay_cam_co,
          FN_GET_COMPANYCD||'P000001' Ben_nhan_Camco ,
         se.Codeid ,
         sb.symbol Ma_CK,
          nvl(sb.Parvalue,0) Menh_Gia ,

          nvl(se.msgamt,0) msgamt

 FROM (
        SELECT   txdate,
                 SUBSTR (acctno, 0, 10) acctno,
                 SUBSTR (acctno, 11, 6) codeid,
                 namt msgamt
          FROM   setran
         WHERE       tltxcd = '2233'
                 AND txcd = '0043'
                 AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
                 AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
        UNION ALL
        SELECT   txdate,
                 SUBSTR (acctno, 0, 10) acctno,
                 SUBSTR (acctno, 11, 6) codeid,
                 namt msgamt
          FROM   setrana
         WHERE       tltxcd = '2233'
                 AND txcd = '0043'
                 AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
                 AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
         ) SE ,
         sbsecurities sb, afmast af,cfmast cf
 WHERE   se.codeid = sb.codeid
         AND se.acctno = af.acctno
         AND af.custid = cf.custid
         AND sb.tradeplace IN ('001', '002', '005','004','007','008','009')
         AND Cf.CUSTODYCD  LIKE V_CUSTODYCD
         AND sb.symbol     LIKE V_SYMBOL
         AND sb.tradeplace like V_TRADEPLACE
      ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

