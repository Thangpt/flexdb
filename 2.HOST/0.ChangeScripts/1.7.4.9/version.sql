delete version where UPDATEDATE = getcurrdate and REPORTVERSION='reports.1.0.0.0001.0114' and ACTUALVERSION='1000084';
insert into version (UPDATEDATE, REPORTVERSION, ACTUALVERSION)
values (getcurrdate, 'reports.1.0.0.0001.0114', '1000084');
commit;
