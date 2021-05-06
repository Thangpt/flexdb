create or replace force view v_crintacrcv as
select cf.custodycd, round( ci.CRINTACR)  CRINTACR,CF.BRID
from  cimast ci , cfmast cf
where cf.custid = ci.custid 
and ci.CRINTACR <>0
order by cf.custodycd;

