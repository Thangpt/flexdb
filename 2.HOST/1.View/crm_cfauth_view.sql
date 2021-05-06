create or replace force view crm_cfauth_view as
select cf.acctno,cf.telephone,cf.fullname,cf.licenseno,cf.valdate,cf.expdate
from CFAUTH cf
where deltd<>'Y'
and cf.valdate <=sysdate and cf.expdate>=trunc(sysdate);

