CREATE OR REPLACE PROCEDURE sa0011 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   F_DATE       IN       VARCHAR2,
   T_DATE       IN       VARCHAR2
)
IS
-- ---------   ------  -------------------------------------------
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);

   v_CurrDate        DATE;
   VF_DATE              date;
   VT_DATE              date;


-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := upper(pv_OPT);
   V_INBRID := pv_BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := pv_BRID;
        end if;
    end if;

     select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';
     VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
     VT_DATE := to_Date(T_DATE,'DD/MM/RRRR');

-- GET REPORT'S DATA
OPEN PV_REFCURSOR for
select aa.i_date, aa.ten_nhom, aa.ma_nhom, aa.giam_doc, aa.tlid, aa.custid
    , (nvl(aa.I_sltkmm,0)) I_sltkmm, (nvl(aa.sltkmm,0)) sltkmm
    , nvl(round(main.execamt/1000000000,2),0) execamt
    , nvl(round(main.feeamt/1000000,2),0) feeamt
    , nvl(round(main.I_execamt/1000000000,2),0) I_execamt
    , nvl(round(main.I_feeamt/1000000,2),0) I_feeamt
    , nvl(round(dvtc/1000000000,2),0) dvtc
from
(   select a.i_date, a.autoid, a.custid, a.ten_nhom, a.ma_nhom, a.giam_doc, a.tlid
           ,nvl(b.sltkmm,a.sltkmm) sltkmm
           ,nvl(b.I_sltkmm,a.I_sltkmm) I_sltkmm
    from
    (
    select VT_DATE i_date, g.autoid, g.custid, g.fullname ten_nhom, g.autoid ma_nhom, cf.fullname giam_doc, substr(g.custid,1,4) tlid
        , 0 sltkmm
        , 0 I_sltkmm
    from   (select * from regrp union all select * from regrphist) g, cfmast cf
    where  g.custid = cf.custid
        and g.effdate <= VT_DATE
        and g.expdate >= VF_DATE
    ) a left join
    (
    select i_date, autoid, main.custid, ten_nhom, ma_nhom, giam_doc, tlid
            , count(distinct co.custid) sltkmm
            , count(distinct cT.custid) I_sltkmm
    from
         (  select VT_DATE i_date, g.autoid, g.custid, g.fullname ten_nhom, g.autoid ma_nhom, cf.fullname giam_doc, substr(g.custid,1,4) tlid
               , a.afacctno , g.effdate, g.expdate, d.effdate d_effdate, nvl(d.closedate - 1, d.expdate) d_expdate, a.frdate a_frdate, nvl(a.clstxdate - 1, a.todate) a_todate

           from  recflnk c, recfdef d, (select * from regrp union all select * from regrphist) g
               , regrplnk l, cfmast cf
               , (select a.reacctno, a.frdate, a.todate, a.clstxdate, a.afacctno from  reaflnk a) a
           where g.autoid = l.refrecflnkid and l.reacctno = a.reacctno and g.custid = cf.custid
           and c.autoid = d.refrecflnkid and substr(a.reacctno,1,10) = c.custid and substr(a.reacctno,11,4) = d.reactype
           and a.frdate <= VT_DATE and nvl(a.clstxdate -1, a.todate) >= VF_DATE
           and d.effdate <= VT_DATE and nvl(d.closedate -1, d.expdate) >= VF_DATE
           and l.frdate <=VT_DATE and nvl(l.clstxdate -1 , l.todate) >= VF_DATE
           and g.effdate <= VT_DATE and g.expdate >= VF_DATE
           and (substr(g.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(g.custid,1,4))<> 0)
         ) main
        left join
        (   select af.acctno, af.custid from cfmast cf, afmast af
            where cf.custid = af.custid and cf.opndate between VF_DATE and VT_DATE
        ) co
        on main.afacctno = co.acctno and VT_DATE between main.a_frdate and main.a_todate
            and VT_DATE between main.effdate and main.expdate
            and VT_DATE between d_effdate and d_expdate
        left join
        (   select af.acctno, af.custid from cfmast cf, afmast af
            where cf.custid = af.custid and cf.opndate = VT_DATE
        ) cT on main.afacctno = ct.acctno and VT_DATE between main.a_frdate and main.a_todate
            and VT_DATE between main.effdate and main.expdate
            and VT_DATE between d_effdate and d_expdate
    group by i_date, autoid, main.custid, ten_nhom, ma_nhom, giam_doc, tlid
    ) b on a.autoid = b.autoid and a.custid = b.custid
) aa left join
(
    select  a.ma_nhom, a.custid
        , sum(nvl(a.execamt,0)) execamt
        , sum(nvl(a.feeamt,0)) feeamt
        , sum(nvl(a.t_execamt,0)) I_execamt
        , sum(nvl(a.t_feeamt,0)) I_feeamt
    from

          (
          select g.autoid ma_nhom,g.custid
              , od.afacctno
              , sum(case when od.txdate = VT_DATE then od.execamt else 0 end ) t_execamt
              , sum(case when od.txdate = VT_DATE then od.feeacr else 0 end ) t_feeamt
              , sum(nvl(od.execamt,0)) execamt
              , sum(nvl(od.feeacr,0)) feeamt
          from reaflnk a, recflnk c, recfdef d, (select * from regrp union all select * from regrphist) g
              , regrplnk l, vw_odmast_all od, retype t
              , afmast , cfmast
          where g.autoid = l.refrecflnkid and l.reacctno = a.reacctno
              and c.autoid = d.refrecflnkid and substr(a.reacctno,1,10) = c.custid and substr(a.reacctno,11,4) = d.reactype
              and t.actype = d.reactype and t.rerole in ('BM','RM')
              and od.afacctno = a.afacctno
              and afmast.custid = cfmast.custid and afmast.acctno = a.afacctno and substr(cfmast.custodycd,4,1) <> 'P'
              and od.txdate >= to_Date(F_DATE,'DD/MM/RRRR') and od.txdate <= to_Date(T_DATE,'DD/MM/RRRR')
              and od.txdate between a.frdate and nvl(a.clstxdate -1, a.todate)
              and od.txdate between d.effdate and nvl(d.closedate -1, d.expdate)
              and od.txdate between l.frdate and nvl(l.clstxdate -1 , l.todate)
              and od.txdate between g.effdate and g.expdate
          group by g.autoid, g.custid, od.afacctno
          ) a
    group by  a.custid, a.ma_nhom
) main on aa.autoid =main.ma_nhom and aa.custid = main.custid
left join
(
select g.autoid, g.custid
    , sum(nvl(d.du_no,0) + nvl(c.amt,0)) dvtc
from  recflnk c, recfdef d, (select * from regrp union all select * from regrphist) g, RETYPE RT
    , regrplnk l
    , (select * from reaflnk ) A
        left join
      ( --du no hien tai
       select  trfacctno afacctno, nvl(sum(t0amt),0) +  nvl(sum(marginamt),0) du_no
       from
       (
        select trfacctno,
                 sum(oprinnml+oprinovd) t0amt,
                 sum(prinnml+prinovd) marginamt
        from lnmast ln, lntype lnt,
                (select acctno, sum(nml) dueamt
                        from lnschd
                        where reftype = 'P' and overduedate = getcurrdate
                        group by acctno) ls
        where ftype = 'AF'
                and ln.actype = lnt.actype
                and ln.acctno = ls.acctno(+)
        group by ln.trfacctno
       )
       /*vw_lngroup_all*/ where VT_DATE  = v_CurrDate  group by  trfacctno
       union all
       --du no qua khu
       /*select  afacctno, max(t0amt) + max(mramt) du_no
       from  tbl_mr3007_log where txdate = VT_DATE  group by afacctno*/
       select  afacctno, sum(mrprinamt) + sum(t0prinamt) du_no
       from  MR5005_LOG where txdate = VT_DATE  group by afacctno
       )d on a.afacctno = d.afacctno
        left join
        (
        SELECT  ACCTNO
            , SUM(NVL(ADS.AMT, 0) + NVL(ADS.FEEAMT, 0)- (case when VT_DATE >= ads.cleardt then ads.paidamt else 0 end)) AMT
        FROM   VW_ADSCHD_ALL ADS
        WHERE     (ADS.AMT > 0   OR   ADS.PAIDDATE = v_CurrDate ) --V_CRRDATE
            AND    ADS.txdate     <=   VT_DATE
        GROUP  BY  ACCTNO
        ) c on a.afacctno = c.acctno
where g.autoid = l.refrecflnkid and l.reacctno = a.reacctno AND D.REACTYPE = RT.actype AND RT.REROLE IN ('BM','RM')
    and c.autoid = d.refrecflnkid and substr(a.reacctno,1,10) = c.custid and substr(a.reacctno,11,4) = d.reactype
    and VT_DATE between a.frdate and nvl(a.clstxdate -1, a.todate)
    and VT_DATE between d.effdate and nvl(d.closedate -1, d.expdate)
    and VT_DATE between l.frdate and nvl(l.clstxdate -1 , l.todate)
    and VT_DATE between g.effdate and g.expdate
group by g.autoid, g.custid
) e on aa.autoid = e.autoid and aa.custid = e.custid

;


 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
/

