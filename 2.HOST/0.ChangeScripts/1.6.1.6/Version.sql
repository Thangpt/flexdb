delete version where UPDATEDATE = getcurrdate;
insert into version (UPDATEDATE, REPORTVERSION, ACTUALVERSION)
values (getcurrdate, 'reports.1.0.0.0001.0093', '1000074');
commit;
