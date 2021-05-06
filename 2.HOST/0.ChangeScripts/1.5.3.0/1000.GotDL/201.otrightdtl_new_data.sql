insert into otrightdtl (autoid, cfcustid, authcustid, otmncode, otright, deltd, via)
select seq_otrightdtl.nextval , t.cfcustid,t.authcustid, t.otmncode, substr(t.otright,1,4)|| 'YNN' , t.deltd, t.via
              from (select distinct o.cfcustid,o.authcustid, o.otmncode, o.otright, o.deltd, o.via
              from OTRIGHTDTL_BACKUP o 
              where deltd = 'N' and VIA ='A' 
              and not exists (select * from otrightdtl where cfcustid = o.cfcustid and authcustid = o.authcustid and deltd ='N' and VIA ='A') ) t ;
commit;