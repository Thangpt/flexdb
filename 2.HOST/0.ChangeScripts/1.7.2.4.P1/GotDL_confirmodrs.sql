create table confirmodrs_bk as
select c.* from vw_odmast_all od,confirmodrsts c
where od.ORDERID = c.orderid and od.TLID = '6868';
/
create table confirmodrsts_20200422 as
select * from confirmodrsts where 0=0;
/

begin 
 for rec in (select * from confirmodrs_bk ) loop
 delete confirmodrsts where orderid = rec.orderid ;
  commit;
 end loop;
end;

