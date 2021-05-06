create or replace force view v_semargininfo_bod as
select se.codeid, sum(se.trade) trade, sum(nvl(sts.qtty,0)) receiving
from semast se, afmast af, aftype aft, mrtype mrt, lntype lnt,
      (select sum(qtty) qtty,acctno
     from stschd where duetype='RS' and deltd='N' and status <> 'C' group by acctno  ) sts
where se.afacctno = af.acctno
and af.actype = aft.actype
and aft.mrtype = mrt.actype
and mrt.mrtype = 'T'
and aft.lntype = lnt.actype(+)
and se.acctno=sts.acctno(+)
and (   nvl(lnt.chksysctrl,'N') = 'Y'
    or exists (select 1 from afidtype afi, lntype lnt1 where afi.objname = 'LN.LNTYPE' and afi.aftype = af.actype and afi.actype = lnt1.actype and lnt1.chksysctrl='Y'))
group by se.codeid;

