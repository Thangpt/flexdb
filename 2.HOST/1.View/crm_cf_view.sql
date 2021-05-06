create or replace force view crm_cf_view
(brname, acctno, custodycd, fullname, opndate, sex, idcode, tradephone, phone1, pin, iddate, idplace, email, address, custid, class, refname, dateofbirth, aftype)
as
select br.brname,af.acctno, cf.custodycd,cf.fullname, af.opndate, cf.sex, cf.idcode, af.tradephone,af.phone1,
cf.pin, cf.iddate,cf.idplace,af.email, af.address, af.custid, cf.class, cf.refname,
 to_date(to_char(cf.DATEOFBIRTH,'mm/dd/yyyy'),'mm/dd/yyyy'), af.aftype
from afmast af, cfmast cf, brgrp br
where af.custid=cf.custid
and af.status = 'A'
and substr(af.acctno,1,4)=br.brid;

