create or replace force view vw_rootordermap_all as
select "FOACCTNO","ORDERID","STATUS","MESSAGE","ID" from rootordermap
union all
select "FOACCTNO","ORDERID","STATUS","MESSAGE","ID" from rootordermaphist;

