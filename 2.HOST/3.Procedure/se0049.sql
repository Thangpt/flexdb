CREATE OR REPLACE PROCEDURE SE0049 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2
 )
IS

-- RP NAME : BANG KE CHUNG KHOAN CAM CO 21A/LK
-- COMMENTS : CREATE NEW
-- ---------   ------  -------------------------------------------
   V_CUSTODYCD VARCHAR2 (15);


BEGIN
-- GET REPORT'S PARAMETERS

   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;


-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR

Select (case
          when sb.tradeplace='002' then ' HNX'
          when sb.tradeplace='001' then ' HOSE'
          when sb.tradeplace='005' then ' UPCOM'
          when sb.tradeplace='007' then ' TRÁI PHI?U CHUYÊN BI?T'
          when sb.tradeplace='004' then ' TRÁI PHI?U NGO?I T?'
          when sb.tradeplace='008' then ' TÍN PHI?U'
          when sb.tradeplace='009' then ' ÐCCNY'
               else '' end) san,
          Cf.fullname ,
          cf.custodycd So_TK_luuKY,
          cf.IDcode IDcode,
          Cf.iddate Ngay_cap,
          cf.idplace Noi_Cap,
          cf.address Dia_Chi,
          cf.fax Fax,
          cf.phone So_DT,
          se.acctno Afacctno ,
          se.txdate Ngay_cam_co,
          FN_GET_COMPANYCD||'P000001' Ben_nhan_Camco ,
         (CASE WHEN instr(sb.symbol1,'_WFT') <> 0 then '7' else '1' end) Codeid ,
         sb.symbol Ma_CK,
         (nvl(sb.Parvalue,0)) Menh_Gia ,
         (nvl(se.msgamt,0)) msgamt

 from (
         SELECT   txdate,
                 SUBSTR (acctno, 0, 10) acctno,
                 SUBSTR (acctno, 11, 6) codeid,
                 namt msgamt
         FROM   setran
         WHERE       tltxcd = '2232'
                 AND txcd = '0043'
                 AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
                 AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
         UNION ALL
          SELECT   txdate,
                   SUBSTR (acctno, 0, 10) acctno,
                   SUBSTR (acctno, 11, 6) codeid,
                   namt msgamt
            FROM   setrana
           WHERE       tltxcd = '2232'
                   AND txcd = '0043'
                   AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
                   AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
         ) SE ,
         (select nVL(SB1.Parvalue,SB.Parvalue) Parvalue,  NVL(SB1.TRADEPLACE,SB.TRADEPLACE) TRADEPLACE, NVL(SB.SECTYPE,SB1.SECTYPE) SECTYPE ,SB.CODEID,
                 nvl(sb1.symbol,sb.symbol) symbol, nvl(sb1.CODEID,sb.CODEID) REFCODEID, sb.symbol symbol1
          from sbsecurities sb, sbsecurities sb1
          where nvl(sb.refcodeid,' ') = sb1.codeid(+)
          ) sb, afmast af, cfmast cf

         where se.codeid = sb.codeid
         AND se.acctno = af.acctno
         AND af.custid = cf.custid
         AND sb.tradeplace IN ('001', '002', '005','004','008','009')
         AND Cf.CUSTODYCD  LIKE V_CUSTODYCD

      ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

