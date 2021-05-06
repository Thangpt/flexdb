CREATE OR REPLACE PROCEDURE sa0010 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE           in     varchar2
)
IS

   l_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   l_STRBRID          VARCHAR2 (4);

   v_fromdate           date;
   v_todate             date;


-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   l_STROPTION := pv_OPT;

   IF (l_STROPTION <> 'A') AND (pv_BRID <> 'ALL')
   THEN
      l_STRBRID := pv_BRID;
   ELSE
      l_STRBRID := '%%';
   END IF;

   v_fromdate := to_date(F_DATE, 'DD/MM/RRRR');
   v_todate := to_date(T_DATE, 'DD/MM/RRRR');


-- GET REPORT'S DATA
    OPEN PV_REFCURSOR for

    select a.* , 'BRK' brktype from
(
    select g.fullname grpname, c.autoid id, cf.fullname brkname
        , sum(od.execamt) execamt
        , sum(case when od.tlid = nvl(u.tlid,'xxxxx') then od.execamt else 0 end ) amtTLID
        , sum(case when od.via = 'F' then od.execamt else 0 end ) MS_Floor
        , sum(case when od.via = 'T' then od.execamt else 0 end ) MS_Call
        , sum(case when od.via = 'O' then od.execamt else 0 end ) MS_Trade
        , sum(case when od.via = 'M' then od.execamt else 0 end ) MS_Mobile
        , sum(case when od.via = 'H' then od.execamt else 0 end ) MS_Home
    from regrplnk gl, regrp g, reaflnk a, vw_odmast_all od, recflnk c, recfdef cd, retype rt, reuserlnk u, cfmast cf
    where /*gl.reacctno = '00019424281006' and*/ gl.refrecflnkid = g.autoid and a.reacctno = gl.reacctno
    and od.afacctno = a.afacctno and c.autoid = cd.refrecflnkid and a.reacctno = c.custid || cd.reactype and cf.custid = c.custid
    and cd.reactype = rt.actype and rt.rerole in ('BM','RM') and c.autoid = u.refrecflnkid (+)
    and od.txdate between v_fromdate and v_todate
    and od.txdate between a.frdate and nvl(a.clstxdate -1, a.todate)
    and od.txdate between cd.effdate and nvl(cd.closedate - 1, cd.expdate)
    and od.txdate between gl.frdate and nvl(gl.clstxdate -1, gl.todate)
    group by g.fullname, c.autoid, cf.fullname
    order by sum(od.execamt) desc
) a where rownum < 11

union all
select b.* , 'DSF' brktype from
(
    select ' ' grpname, c.autoid id, cf.fullname brkName
        , sum(od.execamt) execamt
        , sum(case when od.tlid = nvl(brk.tlid,'xxxxx') then od.execamt else 0 end ) amtTLID
        , sum(case when od.via = 'F' then od.execamt else 0 end ) MS_Floor
        , sum(case when od.via = 'T' then od.execamt else 0 end ) MS_Call
        , sum(case when od.via = 'O' then od.execamt else 0 end ) MS_Trade
        , sum(case when od.via = 'M' then od.execamt else 0 end ) MS_Mobile
        , sum(case when od.via = 'H' then od.execamt else 0 end ) MS_Home
    from  reaflnk a , recflnk c, recfdef cd,  cfmast cf, retype rt
        , (select * from vw_odmast_all) od
            left join
          (
            select a.afacctno, u.tlid, a.frdate,nvl(a.clstxdate -1,a.todate) todate,  d.effdate, nvl(d.closedate -1 , d.expdate) expdate
            from reaflnk a, recfdef d, recflnk c, reuserlnk u, retype rt
            where a.reacctno = c.custid || d.reactype and d.refrecflnkid = c.autoid and rt.actype = d.reactype and rt.rerole in ('BM','RM')
            and u.refrecflnkid = c.autoid
          ) brk
          on od.afacctno = brk.afacctno and od.txdate between brk.frdate and brk.todate and od.txdate between brk.effdate and brk.expdate
    where od.deltd <> 'Y' and od.afacctno = a.afacctno
    and c.custid = cf.custid
    and c.autoid = cd.refrecflnkid and a.reacctno = c.custid || cd.reactype and cd.reactype = rt.actype and rt.rerole in ('RD')
    and od.txdate between v_fromdate and v_todate
    and od.txdate between a.frdate and nvl(a.clstxdate -1, a.todate)
    and od.txdate between cd.effdate and nvl(cd.closedate - 1, cd.expdate)
    group by  c.autoid, cf.fullname
    order by sum(od.execamt) desc
) b where rownum < 11
;


 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
/

