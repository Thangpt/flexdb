CREATE OR REPLACE PROCEDURE ca1018 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
  F_DATE         IN       VARCHAR2,
  T_DATE         IN       VARCHAR2,
  TLTXCD         IN       VARCHAR2,
  CAMASTID       IN     VARCHAR2,
  PV_CUSTODYCD      IN    VARCHAR2,
  COREBANK    IN          VARCHAR2,
  CUSTATCOM    IN          VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (16);        -- USED WHEN V_NUMOPTION > 0
   V_STRTLTXCD              VARCHAR2 (6);
   V_STRMAKER            VARCHAR2 (20);
   V_STRCHECKER             VARCHAR2 (20);
   V_STRCUSTOCYCD           VARCHAR2 (20);
   V_STRCAMASTID              VARCHAR2 (30);
   V_STRCUSTATCOM           VARCHAR2 (30);
   v_brid               VARCHAR2(4);
V_STRCOREBANK      VARCHAR2(4);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
-- INSERT INTO TEMP_BUG(TEXT) VALUES('CF0001');COMMIT;
   V_STROPTION := upper(OPT);
      v_brid := brid;


  IF  V_STROPTION = 'A' and v_brid = '0001' then
    V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        select br.mapid into V_STRBRID from brgrp br where br.brid = v_brid;
    else V_STROPTION := v_brid;
END IF;

   IF (TLTXCD <> 'ALL')
   THEN
      V_STRTLTXCD := TLTXCD;
   ELSE
      V_STRTLTXCD := '%%';
   END IF;

      IF (CAMASTID <> 'ALL')
   THEN
      V_STRCAMASTID := CAMASTID;
   ELSE
      V_STRCAMASTID := '%%';
   END IF;

   IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_STRCUSTOCYCD := PV_CUSTODYCD;
   ELSE
      V_STRCUSTOCYCD := '%%';
   END IF;

IF (COREBANK <> 'ALL')
   THEN
      V_STRCOREBANK := COREBANK;
   ELSE
      V_STRCOREBANK := '%%';
   END IF;

IF (CUSTATCOM <> 'ALL')
   THEN
      V_STRCUSTATCOM := CUSTATCOM;
   ELSE
      V_STRCUSTATCOM := '%%';
   END IF;

OPEN PV_REFCURSOR
  FOR

SELECT * FROM (

select ci.tltxcd , ci.txnum, ci.txdate,ca.camastid , ci.acctno, ci.custodycd,ci.custid,
        CASE WHEN ci.tltxcd IN ('3350') AND ci.txcd = '0014' THEN sb2.symbol ELSE  sb.symbol END symbol,
sum(decode(txcd,'0014',namt,0)) amt,sum(decode(txcd,'0016',namt,0)) vat, 0  qtty,ci.txdesc,af.corebank,cf.CUSTATCOM
from   vw_CItran_gen ci, afmast af,camast ca, sbsecurities sb,cfmast cf, sbsecurities sb2, caschd chd
where   ci.tltxcd in('3350','3352','3354')
and ci.txcd IN('0014','0016') and ci.acctno =af.acctno
and ci.ref = to_char(chd.autoid) AND chd.camastid= ca.camastid and sb.codeid = ca.codeid
and af.custid = cf.custid
AND sb2.codeid = nvl(ca.tocodeid,ca.codeid)
group by  ci.tltxcd , ci.txnum, ci.txdate,ca.camastid, ci.acctno, ci.custodycd,sb.symbol,
ci.custid,ci.txdesc,af.corebank,cf.custatcom,ci.txcd, sb2.symbol
union ALL

select se.tltxcd , se.txnum, se.txdate,ca.camastid , se.acctno, se.custodycd,se.custid,
        se.symbol,
0 amt,0 vat, se.namt  qtty,se.txdesc,af.corebank,cf.custatcom
from   vw_setran_gen se, camast ca, afmast af,cfmast cf, caschd chd
where se.tltxcd ='3351'and se.afacctno = af.acctno and se.txcd ='0012'
and se.REF = to_char(chd.autoid) AND chd.camastid  = ca.camastid and af.custid =cf.custid

/*
UNION ALL
select tl.tltxcd ,tl.txnum, tl.txdate,ca.camastid , af.acctno,se.custodycd,se.custid, se.symbol,
0 amt,0 vat,se.namt  qtty,tl.txdesc,af.corebank,cf.custatcom
from  vw_tllog_all tl, vw_setran_gen se, afmast af, camast ca,cfmast cf
where tl.txnum = se.txnum and tl.txdate =se.txdate and tl.tltxcd ='3356'
and se.afacctno = af.acctno  and se.TXCD  in ( '0045')
and TL.MSGACCT = ca.camastid  and af.custid =cf.custid
*/

union all
select tl.tltxcd ,tl.txnum, tl.txdate,ca.camastid , af.acctno,se.custodycd,se.custid, se.symbol,
0 amt,0 vat,se.namt  qtty,tl.txdesc,af.corebank,cf.custatcom
from  vw_tllog_all tl,
(Select acctno,se.symbol, custodycd,custid , afacctno ,Sum(namt) namt , txnum , txdate from vw_setran_gen se
 where tltxcd ='3356' and  TXCD  in ('0045','0043')
group by acctno,se.symbol,custodycd,custid, afacctno, txnum , txdate
)se, afmast af, camast ca,cfmast cf
where tl.txnum = se.txnum and tl.txdate =se.txdate and tl.tltxcd ='3356'
and se.afacctno = af.acctno
and TL.MSGACCT = ca.camastid
and af.custid =cf.custid

union all

SELECT tl.tltxcd , tl.txnum, tl.txdate,ca.camastid , af.acctno, se.custodycd,se.custid,
       CASE WHEN tl.tltxcd IN ('3394','3384','3324','3386','3326') THEN sb2.symbol ELSE  sb.symbol END symbol,
case when tl.tltxcd in ('3326', '3324') then 0
    when tl.tltxcd = '3386' then se.namt * ca.exprice
    WHEN tl.tltxcd in ('3384','3394') THEN nvl(ci.namt, 0 ) ELSE  --add Chaunh
tl.msgamt end amt, 0 vat , se.namt qtty,tl.txdesc,af.corebank,cf.custatcom
from  vw_tllog_all tl, vw_setran_gen se, afmast af, camast ca,sbsecurities sb ,
        cfmast cf, sbsecurities sb2,
        (SELECT * FROM vw_citran_gen WHERE tltxcd in ('3384','3394')) ci, caschd chd  --add Chaunh
where tl.txnum = se.txnum and tl.txdate =se.txdate and tl.tltxcd IN ('3384','3394','3324','3386','3326')
and se.afacctno = af.acctno   and se.FIELD ='RECEIVING' and ca.codeid = sb.codeid
AND nvl(ca.tocodeid,ca.codeid) = sb2.codeid
AND tl.txnum = ci.txnum (+) AND tl.txdate = ci.txdate (+)  --add Chaunh
and se.ref = to_char(chd.autoid) AND chd.camastid = ca.camastid and af.custid =cf.custid

)DTL
WHERE DTL.txdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
AND DTL.txdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
AND   (SUBSTR(dtl.CUSTID,1,4) like  V_STRBRID or instr(V_STRBRID,SUBSTR(dtl.CUSTID,1,4)) <> 0)
and DTL.tltxcd like V_STRTLTXCD
and DTL.CUSTODYCD like V_STRCUSTOCYCD
and DTL.camastid like  V_STRCAMASTID
and dtl.corebank like V_STRCOREBANK
and DTL.CUSTATCOM like V_STRCUSTATCOM
ORDER BY tltxcd,TXDATE,TXNUM
;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
-- End of DDL Script for Procedure HOST.CA1018
/

