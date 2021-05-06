create or replace force view vw_gl_investor_info as
select cf.custid,cf.custodycd,nvl(cf.shortname,' ') shortname,cf.fullname,
al.cdcontent IDTYPE_DESC,cf.idcode ,to_char(cf.iddate,'dd/mm/yyyy') iddate,cf.idplace
,cf.address,nvl(cf.phone,' ') phone,nvl(cf.mobile,' ') mobile,nvl(cf.fax,' ')fax,nvl(cf.email,' ') email,cf.sex ,
to_char(cf.dateofbirth,'dd/mm/yyyy') dateofbirth,al1.cdcontent country,cf.custtype ,cf.brid
from cfmast cf, allcode al ,allcode al1
where cf.idtype= al.cdval and al.cdname ='IDTYPE'
AND CF.country= AL1.CDVAL AND AL1.CDNAME ='COUNTRY';

