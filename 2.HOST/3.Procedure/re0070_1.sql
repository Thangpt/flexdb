CREATE OR REPLACE PROCEDURE re0070_1 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   CUSTID         IN       VARCHAR2,
   GROUPID         IN       VARCHAR2,
   REROLE         IN       VARCHAR2,
   PV_TLID          in      varchar2
 )
IS

    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_CUSTID varchar2(10);
    V_REROLE varchar2(4);
    V_GROUPID varchar2(10);
    V_CAREBY varchar2(4);
BEGIN

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

    begin
    select cf.careby into V_CAREBY from reuserlnk u, recfdef cd, recflnk c, cfmast cf
    where u.refrecflnkid = c.autoid and u.refrecflnkid = cd.refrecflnkid and cf.custid = c.custid
    and to_date(I_DATE, 'DD/MM/RRRR') between cd.opendate and nvl(cd.closedate -1, cd.expdate) and u.tlid = PV_TLID;
    EXCEPTION
        when OTHERS
        then
            V_CAREBY := 'xxxx';
    end;

    IF GROUPID <> 'ALL' THEN
        V_GROUPID := GROUPID;
    ELSE V_GROUPID := '%';
    END IF;

   ------------------------
   IF (REROLE <> 'ALL')
   THEN
    V_REROLE := REROLE;
   ELSE
    V_REROLE := '%';
   END IF;
   -----------------------

   IF (CUSTID <> 'ALL')
   THEN
        V_CUSTID := CUSTID;
   else
        V_CUSTID := '%';
   end if
   ;

   ------------------------------

OPEN PV_REFCURSOR FOR
select to_date(I_date,'DD/MM/RRRR') ngay_tao,ka.acctno, kc.fullname kh_ten, kc.custodycd kh_custo, mc.fullname mg_ten, re.typename mg_vaitro ,
        nvl(g.fullname,' ') nhom_ten, g.autoid nhom_ma, nvl(SP_FORMAT_REGRP_MAPCODE(grplk.refrecflnkid),' ') nhom_con
from reaflnk mg, afmast ka, cfmast kc, cfmast mc, retype re,
     regrplnk  grplk, regrp g, recflnk rc, recfdef rd
where mg.afacctno = ka.acctno and ka.custid = kc.custid
and rc.autoid = rd.refrecflnkid and rc.custid || rd.reactype = mg.reacctno
and substr(mg.reacctno,1,10) = mc.custid
and re.actype = substr(mg.reacctno,11,4)
and grplk.refrecflnkid = g.autoid
and mg.reacctno = grplk.reacctno
and to_date(I_DATE,'DD/MM/RRRR') between mg.frdate and nvl(mg.clstxdate - 1, mg.todate)
and to_date(I_DATE,'DD/MM/RRRR') between grplk.frdate and nvl(grplk.clstxdate - 1, grplk.todate)
and to_date(I_DATE,'DD/MM/RRRR') between rd.effdate and nvl(rd.closedate -1, rd.expdate)
and ka.careby in ( select grpid from tlgrpusers where tlid = PV_TLID)
AND re.rerole LIKE V_REROLE
and mc.custid like V_CUSTID
AND nvl(SP_FORMAT_REGRP_MAPCODE(grplk.refrecflnkid),' ') LIKE (CASE WHEN V_GROUPID = '%' THEN '%' ELSE SP_FORMAT_REGRP_MAPCODE(V_GROUPID)||'%' END)
order by nvl(SP_FORMAT_REGRP_MAPCODE(grplk.refrecflnkid),' ')
;

EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

