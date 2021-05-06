create or replace force view v_semargininfo_sy_bod as
select se.codeid, sum(se.trade) trade, sum(nvl(sts.qtty,0)) receiving
from semast se, afmast af, aftype aft, mrtype mrt,
     (select sum(qtty) qtty,acctno
     from stschd where duetype='RS' and deltd='N' and status <> 'C' group by acctno  ) sts
where se.afacctno = af.acctno
and af.actype = aft.actype
and aft.mrtype = mrt.actype
and mrt.mrtype = 'T'
and se.acctno=sts.acctno(+)
group by se.codeid;

