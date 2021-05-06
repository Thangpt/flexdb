CREATE OR REPLACE PROCEDURE se0063 (
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
SELECT 1 sectype, tl.msgamt qtty,
        cf_ban.fullname s_fullname, cf_ban.custodycd s_acctno,
        CASE WHEN cf_ban.country  <> '234' THEN cf_ban.tradingcode
             ELSE cf_ban.idcode END s_idcode,
        CASE WHEN cf_ban.country  <> '234' THEN cf_ban.tradingcodedt
             ELSE cf_ban.iddate END s_iddate,
        CASE WHEN cf_ban.idtype = '001' THEN 1
             WHEN cf_ban.idtype = '002' THEN 2
             WHEN cf_ban.idtype = '005' THEN 3
             ELSE 4 END s_idtype,
        cf_mua.fullname b_fullname, cf_mua.custodycd b_acctno,
         CASE WHEN cf_mua.country  <> '234' THEN cf_ban.tradingcode
             ELSE cf_mua.idcode END b_idcode,
         CASE WHEN cf_mua.country  <> '234' THEN cf_ban.tradingcodedt
             ELSE cf_mua.iddate END b_iddate,
         CASE WHEN cf_mua.idtype = '001' THEN 1
             WHEN cf_mua.idtype = '002' THEN 2
             WHEN cf_mua.idtype = '005' THEN 3
             ELSE 4 END b_idtype,
         '005' ma_tvlk_nhan_ck, sb.symbol
FROM vw_tllog_all tl, cfmast cf_ban, cfmast cf_mua, afmast af_ban, afmast af_mua, sbsecurities sb,
     vw_tllogfld_all fld--seretail
WHERE tl.tltxcd = '8815' AND tl.deltd <> 'Y' AND fld.txnum = tl.txnum AND fld.txdate = tl.txdate AND fldcd = '08'
AND substr(tl.msgacct,1,10) = af_ban.acctno AND substr(fld.cvalue, 1,10) = af_mua.acctno
AND cf_mua.custid = af_mua.custid AND cf_ban.custid = af_ban.custid AND substr(tl.msgacct,11,6) = sb.codeid
AND tl.txdate <= to_date(T_DATE,'DD/MM/RRRR')
AND tl.txdate >= to_date(F_DATE,'DD/MM/RRRR')
AND sb.symbol LIKE V_STRSYMBOL
AND cf_ban.custodycd LIKE V_CUSTODYCD
AND af_ban.acctno LIKE V_STRAFACCTNO
;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

