create or replace force view vw_gl_bank_info as
select cf.custid,cf.custodycd,cf.shortname,cf.fullname,
al.cdcontent IDTYPE_DESC,cf.idcode ,cf.iddate,cf.idplace
,cf.address,cf.phone,cf.mobile,cf.fax,cf.email,cf.sex ,
cf.dateofbirth,al1.cdcontent country,cf.custtype ,cf.brid
from cfmast cf, allcode al ,allcode al1
where cf.idtype= al.cdval and al.cdname ='IDTYPE'
AND CF.country= AL1.CDVAL AND AL1.CDNAME ='COUNTRY';

