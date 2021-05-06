create or replace force view cf_info_view1 as
select distinct phone,class,text from 
(select af.tradephone phone
        ,a.cdcontent class
        , af.acctno||' '||cf.fullname ||' '||af.pin    text
From cfmast cf, afmast af,allcode a
where cf.custid=af.custid
and a.cdtype='CF'
and a.cdname='CLASS'
and a.cdval=cf.class
union all
select af.phone1 phone
        ,a.cdcontent class
        , af.acctno||' '||cf.fullname ||' '||af.pin    text
From cfmast cf, afmast af,allcode a
where cf.custid=af.custid
and a.cdtype='CF'
and a.cdname='CLASS'
and a.cdval=cf.class)
where phone is not null
order by phone;

