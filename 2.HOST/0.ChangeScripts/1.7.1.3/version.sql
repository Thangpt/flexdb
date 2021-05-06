delete from version where UPDATEDATE = getcurrdate;
insert into version (UPDATEDATE, REPORTVERSION, ACTUALVERSION)
values (getcurrdate, 'reports.1.0.0.0001.0109', '1000080');
commit;
