

DELETE VERSION WHERE UPDATEDATE = getcurrdate; 
insert into VERSION (UPDATEDATE, REPORTVERSION, ACTUALVERSION)
values (getcurrdate, 'reports.1.0.0.0001.0088', '1000071');
COMMIT;