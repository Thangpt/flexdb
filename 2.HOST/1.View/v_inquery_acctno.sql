create or replace force view v_inquery_acctno as
Select cf.custodycd ,  UPPER(pck_gwtransfer.correct_remark(cf.fullname,200)) fullname ,af.acctno,
a1.CDCONTENT acctnosum, af.acctno || '.' ||  UPPER(pck_gwtransfer.correct_remark(cf.fullname,200)) ||'.' || aft.typename   DESCRIPTION
from cfmast cf , afmast af , aftype aft  , allcode a1
where(cf.custid = af.custid)
and af.actype = aft.actype
and a1.cdtype='GW'
and a1.cdname='ACCTNOSUM'
and a1.cdval=substr(af.acctno,0,4)
and af.status in ('A','P');

