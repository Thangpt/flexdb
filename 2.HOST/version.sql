delete version where  REPORTVERSION='reports.1.0.0.0001.0117' and ACTUALVERSION ='1000086';
insert into version (UPDATEDATE, REPORTVERSION, ACTUALVERSION)
values (getcurrdate, 'reports.1.0.0.0001.0117', '1000086');
commit;
