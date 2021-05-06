create or replace force view cf_info_view as
(/*select af.tradephone phone1
       , af.phone1 phone2
       , af.custid Custid
       ,af.acctno
       ,cf.fullname name
       ,af.pin pin
       ,a.cdcontent class
       ,c1.fullname    ||' : '|| c.acctno text
from cfauth c, cfmast cf, afmast af, allcode a, cfmast c1, afmast a1
where --c.acctno ='0001278819'and
c.custid=af.custid
and c.custid=cf.custid
and a.cdtype='CF'
and a.cdname='CLASS'
and a.cdval=cf.class
and a1.acctno=c.acctno
and a1.custid=c1.custid
union all*/
select af.tradephone phone1
       , af.phone1 phone2
       , af.custid Custid
       , af.acctno
       ,cf.fullname name
       ,af.pin pin
       , a.cdcontent class
       ,cf.fullname    ||' : '|| af.acctno text
From cfmast cf, afmast af,allcode a
where cf.custid=af.custid
and a.cdtype='CF'
and a.cdname='CLASS'
and a.cdval=cf.class
--and af.custid=0001000097
)
;

