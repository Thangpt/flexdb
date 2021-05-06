Create table CHANGE_BRID_AFMAST as
select  cf.custid, cf.custodycd, af.acctno,  cf.brid cfbrid, af.brid afbrid, 'P' STATUS
from cfmast cf, afmast af
where cf.custid = af.custid and  cf.status <>'C' and af.status <>'C' and af.brid <> cf.brid  ;

begin
  for rec in ( select * from CHANGE_BRID_AFMAST where status = 'P') loop
      update afmast set brid = rec.cfbrid where custid = rec.custid and acctno =  rec.acctno;
      update CHANGE_BRID_AFMAST set status = 'C' where custid = rec.custid and acctno =  rec.acctno;
      commit;
  end loop;
end;

