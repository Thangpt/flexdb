create table lnschd_20201020 as
select ln.*,  temp , ln.intovdprin - temp chenhlech 
from (select sum(intovdprin ) temp , autoid  from vw_lnschdlog_all group by autoid) a , lnschd ln 
where a.autoid = ln.autoid and ln.intovdprin <> temp  and ln.reftype = 'P';
/
begin
  for rec in ( select * from lnschd_20201020) loop 
    update lnschd set INTOVDPRIN = rec.temp where autoid = rec.autoid;
    commit;
  end loop;
 end;
 /
create table lnmast_20201020 as
select   mst.*, temp
from lnmast mst , (select sum(schd.intovdprin) temp , acctno  from lnschd schd  WHERE  reftype = 'P' group by schd.acctno) t
where mst.acctno = t.acctno and (mst.intovdacr <> t.temp OR mst.intovdacr < 0);
/
begin
  for rec in ( select * from lnmast_20201020 ) loop 
    update lnmast set intovdacr = rec.temp  where acctno = rec.acctno;
    commit;
  end loop;
 end;
/
create table lnschd_20201020_after as
select ln.* from  lnschd ln where  ln.intovdprin < 0 ;
create table lnmast_20201020_after as
select ln.* from  lnmast  ln where  ln.intovdacr < 0 ;


