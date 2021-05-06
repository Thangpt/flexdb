CREATE OR REPLACE PROCEDURE se0066 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD    IN       VARCHAR2
   --PV_VOUCHER     IN       VARCHAR2
       )
IS

-- RP NAME : Bang ke giao dich chung khoan lo le
-- PERSON : PhucPP
-- DATE : 15/02/2012
-- COMMENTS : Chuyen sang dang bang ke.
-- ---------   ------  -------------------------------------------
     V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);


   V_CUSTODYCD VARCHAR2 (15);
   V_CURRENTDATE    date    ;
   V_ADVDUTYTAX number;

BEGIN
-- GET REPORT'S PARAMETERS
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
    IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;

   select to_date(varvalue,'DD/MM/RRRR') into V_CURRENTDATE from sysvar where varname = 'CURRDATE';
   select varvalue into V_ADVDUTYTAX from sysvar where varname = 'ADVSELLDUTY';

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
 SELECT se.sdate txdate, cf.fullname, af.acctno, cf.custodycd, sb.symbol, a.cdcontent tradeplace,
        iss.fullname securitiesname, msgamt qtty, se.price, si.basicprice, se.taxamt, round(se.price*se.qtty*V_ADVDUTYTAX/100) tax,
       cf2.custodycd descustodycd

FROM seretail se, vw_tllog_all tl,
cfmast cf, afmast af, sbsecurities sb, issuers iss,  afmast af2, cfmast cf2, allcode a,
(select V_CURRENTDATE histdate, codeid, symbol, txdate, basicprice, avgprice, ceilingprice, floorprice from securities_info
union all
select histdate, codeid, symbol, txdate, basicprice, avgprice, ceilingprice, floorprice from securities_info_hist ) si
WHERE substr(se.acctno,1,10) = af.acctno AND af.custid = cf.custid
AND substr(se.acctno,11,6) = sb.codeid AND sb.issuerid = iss.issuerid
and sb.codeid = si.codeid
AND se.status <> 'R'
AND tl.txdate = se.txdate AND tl.txnum = se.txnum
and cf2.custid = af2.custid and af2.acctno = substr(desacctno,1,10)
and a.cdname = 'TRADEPLACE' and a.cdtype = 'OD' and a.cdval = sb.tradeplace
and si.histdate = se.txdate
AND se.txdate <= to_date(T_DATE,'DD/MM/RRRR')
AND se.txdate >= to_date(F_DATE,'DD/MM/RRRR')
and cf.custodycd like V_CUSTODYCD
AND (substr(cf.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(cf.custid,1,4))<> 0)
ORDER BY cf.custodycd

/* -- BANG KE --PHUCPP
      SELECT MST.OBJNAME, MST.TXDATE, MST.OBJKEY, FN_CRB_GETVOUCHERNO(LG.TRFCODE, LG.TXDATE, LG.VERSION) VOUCHERNO,
      MST.AFACCTNO, MST.BANKCODE, MST.BANKACCT, MST.STATUS, MST.TXAMT, RF.*
      FROM CRBTXREQ MST, CRBTRFLOG LG, CRBTRFLOGDTL LGDTL,
      (SELECT *
      FROM   (SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
              FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE MST.REQID=DTL.REQID AND MST.TRFCODE = 'SEODDLOT')
      PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN
      ('QTTY' as QTTY, 'LICENSE' as LICENSE, 'IDDATE' as IDDATE,
      'CUSTNAME' as CUSTNAME, 'CUSTODYCD' as CUSTODYCD, 'BOARD' as BOARD, 'SYMBOL' as SYMBOL))
      ORDER BY REQID) RF
      WHERE MST.REQID=RF.REQID
      AND LG.VERSION = LGDTL.VERSION
      AND LG.TXDATE = LGDTL.TXDATE
      AND LG.TRFCODE = LGDTL.TRFCODE
      AND LGDTL.REFREQID = MST.REQID
      AND LG.TRFCODE = 'SEODDLOT'
      AND lpad(LGDTL.VERSION, 3,'0') = SUBSTR(PV_VOUCHER,15,3)
      AND LGDTL.TXDATE = TO_DATE((SUBSTR(PV_VOUCHER,9,2) || '/' || SUBSTR(PV_VOUCHER,11,2)  || '/' || '20' || SUBSTR(PV_VOUCHER,13,2)),'DD/MM/YYYY')
*/
      ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

