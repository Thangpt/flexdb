CREATE OR REPLACE PROCEDURE "CFCHL1" (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   IN_DATE         IN       VARCHAR2,
   ACTYPE       in       varchar2

   )
is
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
--V_CRRDATE date;
   V_STRI_BRID      VARCHAR2 (5);
   V_IDATE      date;
   HO_NEW NUMBER;
   HO_trade NUMBER;
   HO_fetrade NUMBER;
   HO_MR NUMBER;
   HO_int NUMBER;
   CCD_trade NUMBER;
   CCD_fetrade NUMBER;
   CCD_MR NUMBER;
   CCD_int NUMBER;
   HN_NEW NUMBER;
   HN_trade NUMBER;
   HN_fetrade NUMBER;
   HN_MR NUMBER;
   HN_int NUMBER;
   HCM_NEW  NUMBER;
   HCM_trade NUMBER;
   HCM_fetrade NUMBER;
   HCM_MR NUMBER;
   HCM_int NUMBER;
   SG_NEW NUMBER;
   SG_trade NUMBER;
   SG_fetrade NUMBER;
   SG_MR NUMBER;
   SG_int NUMBER;
   CCD_NEW NUMBER;
   HO_RE NUMBER;
   HCM_RE NUMBER;
   SG_RE NUMBER;
   HN_RE NUMBER;
   CCD_RE NUMBER;
   CCD_DEPO NUMBER;
   SG_DEPO NUMBER;
   HO_DEPO NUMBER;
   HN_DEPO NUMBER;
   HCM_DEPO NUMBER;
   v_actype varchar2 (4);
BEGIN
 V_STROPTION := OPT;

 IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

 V_IDATE := to_date (IN_DATE,'DD/MM/RRRR');
 v_actype:=actype;
 --HN
 select  NVL(sum(nvl(odexecamt,0)),0) odexecamt,NVL(sum(nvl(odfeeamt,0)),0) odfeeamt,NVL(sum(nvl(mramt,0)),0)mramt ,NVL(sum(nvl(mrint,0)),0) mrint
 into HN_trade,HN_fetrade, HN_MR,HN_int
from  LOG_SA0015 lo
WHERE AFACCTNO IN(SELECT af.ACCTNO FROM AFMAST af,cfmast cf WHERE cf.custid=af.custid and af.ACTYPE =v_actype AND cf.BRID ='0002')    -- and opndate =to_date(V_IDATE,'dd/mm/rrrr'))
AND LO.Txdate =to_date(V_IDATE,'dd/mm/rrrr') ;
-- Nop tien
select NVL(sum(nvl(namt,0)+ nvl(camt,0)),0) into HN_DEPO
from vw_citran_gen v , afmast af,cfmast cf
where af.acctno =v.acctno
and cf.custid=af.custid
and af.actype =v_actype
and  field='BALANCE'
and txtype='C'
and tltxcd in ( '1131','1141','1198','1120')
and cf.brid ='0002'
--and v.custodycd like v_custodycd
and txdate =to_date(V_IDATE,'dd/mm/rrrr') ;

 -- HCM
 select  NVL(sum(nvl(odexecamt,0)),0) odexecamt,NVL(sum(nvl(odfeeamt,0)),0) odfeeamt,NVL(sum(nvl(mramt,0)),0)mramt ,NVL(sum(nvl(mrint,0)),0) mrint
into HCM_trade,HCM_fetrade, HCM_MR,HCM_int
from  LOG_SA0015 lo
WHERE AFACCTNO IN(SELECT af.ACCTNO FROM AFMAST af,cfmast cf WHERE cf.custid=af.custid and af.ACTYPE =v_actype AND cf.BRID ='0003') --  and opndate =to_date(V_IDATE,'dd/mm/rrrr'))
AND LO.Txdate =to_date(V_IDATE,'dd/mm/rrrr') ;
-- Nop tien
select NVL(sum(nvl(namt,0)+ nvl(camt,0)),0) into HCM_DEPO
from vw_citran_gen v , afmast af, cfmast cf
where af.acctno =v.acctno
and cf.custid=af.custid
and af.actype =v_actype
and  field='BALANCE'
and txtype='C'
and tltxcd in ( '1131','1141','1198','1120')
and cf.brid ='0003'
and txdate =to_date(V_IDATE,'dd/mm/rrrr') ;
 -- SG
 select NVL(sum(nvl(odexecamt,0)),0) odexecamt,NVL(sum(nvl(odfeeamt,0)),0) odfeeamt,NVL(sum(nvl(mramt,0)),0)mramt ,NVL(sum(nvl(mrint,0)),0) mrint
into SG_trade,SG_fetrade, SG_MR,SG_int
from  LOG_SA0015 lo
WHERE AFACCTNO IN(SELECT af.ACCTNO FROM AFMAST af,cfmast cf WHERE cf.custid=af.custid and ACTYPE =v_actype AND cf.BRID ='0101') --  and opndate =to_date(V_IDATE,'dd/mm/rrrr'))
AND LO.Txdate =to_date(V_IDATE,'dd/mm/rrrr') ;
-- Nop tien
select NVL(sum(nvl(namt,0)+ nvl(camt,0)),0) into SG_DEPO
from vw_citran_gen v , afmast af,cfmast cf
where af.acctno =v.acctno
and cf.custid=af.custid
and af.actype =v_actype
and  field='BALANCE'
and txtype='C'
and tltxcd in ( '1131','1141','1198','1120')
and cf.brid ='0101'
and txdate =to_date(V_IDATE,'dd/mm/rrrr') ;
-- HO
 select  NVL(sum(nvl(odexecamt,0)),0) odexecamt,NVL(sum(nvl(odfeeamt,0)),0) odfeeamt,NVL(sum(nvl(mramt,0)),0)mramt ,NVL(sum(nvl(mrint,0)),0) mrint
into HO_trade,HO_fetrade, HO_MR,HO_int
from  LOG_SA0015 lo
WHERE AFACCTNO IN(SELECT af.ACCTNO FROM AFMAST af,cfmast cf WHERE cf.custid=af.custid and ACTYPE =v_actype AND cf.BRID ='0008') --  and opndate =to_date(V_IDATE,'dd/mm/rrrr'))
AND LO.Txdate =to_date(V_IDATE,'dd/mm/rrrr') ;
-- Nop tien
select NVL(sum(nvl(namt,0)+ nvl(camt,0)),0) into HO_DEPO
from vw_citran_gen v , afmast af,cfmast cf
where af.acctno =v.acctno
and af.custid=cf.custid
and af.actype =v_actype
and  field='BALANCE'
and txtype='C'
and tltxcd in ( '1131','1141','1198','1120')
and cf.brid ='0008'
and txdate =to_date(V_IDATE,'dd/mm/rrrr') ;

-- CCD
 select NVL(sum(nvl(odexecamt,0)),0) odexecamt,NVL(sum(nvl(odfeeamt,0)),0) odfeeamt,NVL(sum(nvl(mramt,0)),0)mramt ,NVL(sum(nvl(mrint,0)),0) mrint
into CCD_trade,CCD_fetrade, CCD_MR,CCD_int
from  LOG_SA0015 lo
WHERE AFACCTNO IN(SELECT af.ACCTNO FROM AFMAST af,cfmast cf WHERE cf.custid=af.custid and ACTYPE =v_actype AND cf.BRID in ('0001','0006')) --  and opndate =to_date(V_IDATE,'dd/mm/rrrr'))
AND LO.Txdate =to_date(V_IDATE,'dd/mm/rrrr') ;
-- Nop tien
select NVL(sum(nvl(namt,0)+ nvl(camt,0)),0) into CCD_DEPO
from vw_citran_gen v , afmast af,cfmast cf
where af.acctno =v.acctno
and cf.custid=af.custid
and af.actype =v_actype
and  field='BALANCE'
and txtype='C'
and tltxcd in ( '1131','1141','1198','1120')
and cf.brid in ('0001','0006')
and txdate =to_date(V_IDATE,'dd/mm/rrrr') ;

-- New account
select count(*) INTO  SG_NEW
from afmast AF,cfmast cf  where af.custid=cf.custid and af.actype =v_actype and af.custid in (select custid from cfmast where OPNDATE >='02-mar-2020') and cf.brid = '0101' AND AF.OPNDATE =to_date(V_IDATE,'dd/mm/rrrr') ;

select count(*) INTO  HN_NEW
from afmast AF,cfmast cf where af.custid=cf.custid and af.actype =v_actype and af.custid in (select custid from cfmast where OPNDATE >='02-mar-2020') and cf.brid ='0002' AND AF.OPNDATE =to_date(V_IDATE,'dd/mm/rrrr') ;

select count(*) INTO  HCM_NEW
from afmast AF,cfmast cf where af.custid=cf.custid and af.actype =v_actype and af.custid in (select custid from cfmast where OPNDATE >='02-mar-2020') and cf.brid ='0003' AND AF.OPNDATE =to_date(V_IDATE,'dd/mm/rrrr') ;

select count(*) INTO  CCD_NEW
from afmast AF,cfmast cf where af.custid=cf.custid and af.actype =v_actype and af.custid in (select custid from cfmast where OPNDATE >='02-mar-2020') and cf.brid in ('0001','0006') AND AF.OPNDATE =to_date(V_IDATE,'dd/mm/rrrr') ;

select count(*) INTO  HO_NEW
from afmast AF,cfmast cf where af.custid=cf.custid and af.actype =v_actype and af.custid in (select custid from cfmast where OPNDATE >='02-mar-2020') and cf.brid ='0008' AND AF.OPNDATE =to_date(V_IDATE,'dd/mm/rrrr') ;
-- Reactive account
select count(*) INTO  SG_RE
from afmast AF,cfmast cf where af.custid=cf.custid and af.actype =v_actype and cf.custid in (select custid from cfmast where OPNDATE <'02-mar-2020') and cf.brid ='0101' AND AF.OPNDATE =to_date(V_IDATE,'dd/mm/rrrr') ;

select count(*) INTO  HN_RE
from afmast AF,cfmast cf where af.custid=cf.custid and af.actype =v_actype and af.custid in (select custid from cfmast where OPNDATE <'02-mar-2020') and cf.brid ='0002' AND AF.OPNDATE =to_date(V_IDATE,'dd/mm/rrrr') ;

select count(*) INTO  HCM_RE
from afmast AF,cfmast cf where af.custid=cf.custid and af.actype =v_actype and af.custid in (select custid from cfmast where OPNDATE <'02-mar-2020') and cf.brid ='0003' AND AF.OPNDATE =to_date(V_IDATE,'dd/mm/rrrr') ;

select count(*) INTO  CCD_RE
from afmast AF,cfmast cf where af.custid=cf.custid and af.actype =v_actype and af.custid in (select custid from cfmast where OPNDATE <'02-mar-2020') and cf.brid in ('0001','0006') AND AF.OPNDATE =to_date(V_IDATE,'dd/mm/rrrr') ;

select count(*) INTO  HO_RE
from afmast AF,cfmast cf where af.custid=cf.custid and af.actype =v_actype and af.custid in (select custid from cfmast where OPNDATE <'02-mar-2020') and cf.brid ='0008' AND AF.OPNDATE =to_date(V_IDATE,'dd/mm/rrrr') ;

OPEN PV_REFCURSOR FOR
SELECT to_date(to_date(V_IDATE,'dd/mm/rrrr') ,'dd/mm/rrrr') V_IDATE  ,HO_NEW HO_NEW , HO_trade HO_trade,HO_fetrade HO_fetrade, HO_MR HO_MR,HO_int HO_int
,HN_NEW  HN_NEW, HN_trade HN_trade,HN_fetrade HN_fetrade,HN_MR HN_MR, HN_int HN_int,
HCM_NEW HCM_NEW , HCM_trade HCM_trade,HCM_fetrade HCM_fetrade, HCM_MR HCM_MR,HCM_int HCM_int
,SG_NEW SG_NEW, SG_trade SG_trade,SG_fetrade SG_fetrade, SG_MR SG_MR,SG_int SG_int,
CCD_NEW CCD_NEW,CCD_trade CCD_trade,CCD_fetrade CCD_fetrade, CCD_MR CCD_MR,CCD_int CCD_int,
 HO_RE HO_RE, HCM_RE HCM_RE , SG_RE SG_RE , HN_RE  HN_RE, CCD_RE CCD_RE,nvl(HO_DEPO,0) HO_DEPO, nvl(SG_DEPO,0) SG_DEPO, nvl(HCM_DEPO,0) HCM_DEPO,nvl(CCD_DEPO,0) CCD_DEPO,nvl(HN_DEPO,0) HN_DEPO
FROM DUAL;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
