create or replace force view v_depointacrcv as
select cf.custodycd, round( ci.cidepofeeacr)  DEPOINTACR,CF.BRID
from  cimast ci , cfmast cf
where cf.custid = ci.custid 
and ci.cidepofeeacr >0
order by cf.custodycd;

