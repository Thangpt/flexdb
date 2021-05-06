CREATE TABLE OTRIGHTPRE as
select * from OTRIGHT where 0=0;

insert into del_tbl_scheduler  (txdate,bk_table_name,table_name,del_date)
values (getcurrdate, 'OTRIGHTPRE', 'OTRIGHT',getcurrdate+120 );
commit; 

CREATE TABLE OTRIGHTDTLPRE as
select * from OTRIGHTDTL where 0=0;

insert into del_tbl_scheduler  (txdate,bk_table_name,table_name,del_date)
values (getcurrdate, 'OTRIGHTDTLPRE', 'OTRIGHTDTL',getcurrdate+120 );
commit; 
