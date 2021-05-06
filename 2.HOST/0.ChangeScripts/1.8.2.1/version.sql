delete version where UPDATEDATE = getcurrdate AND REPORTVERSION = 'reports.1.0.0.0001.01156' AND ACTUALVERSION = '1000085' ;
insert into version (UPDATEDATE, REPORTVERSION, ACTUALVERSION)
values (getcurrdate, 'reports.1.0.0.0001.0116', '1000085');
commit;
