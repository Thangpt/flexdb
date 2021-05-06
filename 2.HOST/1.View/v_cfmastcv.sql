create or replace force view v_cfmastcv as
select  NVL(cf.brid,' ') brid, NVL(cf.custodycd,' ') custodycd ,NVL(cf.fullname,' ')fullname,NVL(TO_CHAR(cf.dateofbirth,'DD-MM-YYYY'),' ')dateofbirth,NVL(cf.sex,' ')sex,NVL(cf.idcode,' ') idcode,
NVL(TO_CHAR(cf.iddate,'DD-MM-YYYY'),' ') iddate,NVL(cf.idplace,' ') idplace ,NVL(cf.phone,' ') phone, NVL(cf.mobile,' ') mobilecall,' 'mobilesms
,NVL(cf.fax,' ')fax,NVL(cf.email,' ')email,NVL(cf.address,' ')address, NVL(cf.COUNTRY,' ')COUNTRY , NVL(cf.province,' ') province
, DECODE(trim(cf.CUSTTYPE),'I','001','002') CTMTYPE,custatcom isdepo ,' 'maker,' ' checker , ' 'careby,NVL(cf.pin,' ')pin, nvl(CFC.PHONE,' ') PHONE1
--,(case when custodycd is null then 'AUTO' ELSE ' ' END) ISAUTO
,nvl(cfc.address,' ') address1,DECODE(af.TERMOFUSE,'001','N','Y') ISSIGN, nvl( cf.shortname,' ')  name , nvl(cf.tradingcode,' ')tradingcode, NVL(aftype.vat,' ') tac
from cfmast CF, cfcontact CFC  ,afmast af,aftype 
where cf.custid = cfc.custid(+) and  length (custodycd) =10
and cf.custid = af.custid
and af.actype = aftype.actype
AND LENGTH(custodycd)=10
order by custodycd
;

