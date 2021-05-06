CREATE OR REPLACE PROCEDURE re0061 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   RECUSTID         IN       VARCHAR2,
   REGROUPID      IN      varchar2,
   AFSTATUS          in  varchar2,
   AFACTIVE         in      varchar2
 )
IS
--
-- created by Chaunh at 06/03/2013
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);

   V_DATE       date;
   V_RECUSTID   varchar2(10);
   V_REGROUPID  varchar2(10);
   V_AFSTATUS   varchar2(4);
   V_AFACTIVE   varchar2(4);


BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   IF (V_STROPTION = 'A') THEN
      V_STRBRID := '%';
   ELSE if (V_STROPTION = 'B') then
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
   END IF;

   V_DATE := to_date(I_DATE,'DD/MM/RRRR');

   if RECUSTID = 'ALL' then V_RECUSTID := '%';
   else V_RECUSTID := RECUSTID;
   end if;

   if REGROUPID = 'ALL' then V_REGROUPID := '%';
   else V_REGROUPID := REGROUPID;
   end if;

   if AFSTATUS = 'ALL' then V_AFSTATUS := '%';
   else V_AFSTATUS := AFSTATUS;
   end if;

   if AFACTIVE = 'ALL' then V_AFACTIVE := '%';
   else V_AFACTIVE := AFACTIVE;
   end if;

OPEN PV_REFCURSOR
  FOR
 select cf.custodycd, af.acctno, cf.fullname, cf.mobile, cf.email, nvl(re.mrkname,' ') mrkname
       , af.opndate, nvl(af.clsdate, tl.txdate) clsdate, V_DATE ngay_tra_cuu
       , case when tl.txdate is not null  then (select cdcontent from allcode where cdname = 'STATUS' and cdtype = 'CF' and cdval = 'C' ) else a.cdcontent end status
       , case when se.afacctno is not null or ci.acctno is not null or od.afacctno is not null then 'Y' else 'N' end active
from cfmast cf, afmast af
    , (select max (txdate) txdate, msgacct from vw_tllog_all where txdate <= V_DATE and tltxcd = '2249' and deltd <> 'Y' and txstatus = 1 group by msgacct)  tl
    , (select distinct afacctno from vw_setran_gen where  txdate <= V_DATE)  se
    , (select distinct acctno from vw_citran_gen where  txdate <= V_DATE)  ci
    , (select distinct afacctno from vw_odmast_all where  txdate <= V_DATE) od
    , allcode a
    , (  select g.autoid, g.fullname,g.custid g_custid, r.afacctno, r.reacctno, substr(r.reacctno,1,10) recustid, cf.fullname mrkname
            from reaflnk r, retype rt, regrplnk gl, regrp g, recfdef cd, recflnk cl, cfmast cf
            where r.status = 'A' and substr(r.reacctno,11,4) = rt.actype and rt.rerole in ('BM','RM')
            and gl.reacctno = r.reacctno and g.autoid = gl.refrecflnkid and gl.status = 'A' and cf.custid = cl.custid
            and cd.refrecflnkid = cl.autoid and gl.reacctno = cl.custid || cd.reactype and cd.status = 'A'
        ) re
where af.custid = cf.custid and af.acctno = tl.msgacct(+)
and af.acctno = se.afacctno (+)
and af.acctno = ci.acctno (+)
and af.acctno = od.afacctno (+)
and af.acctno = re.afacctno (+)
and a.cdname = 'STATUS' and a.cdtype = 'CF' and a.cdval = af.status
and af.opndate <= V_DATE
and nvl(re.recustid,'xxxxx') like V_RECUSTID
and nvl(re.autoid,'999999') like V_REGROUPID
and case when se.afacctno is not null or ci.acctno is not null or od.afacctno is not null then 'Y' else 'N' end like V_AFACTIVE
and case when tl.txdate is not null  then 'C' else af.status end like V_AFSTATUS
;



EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/

