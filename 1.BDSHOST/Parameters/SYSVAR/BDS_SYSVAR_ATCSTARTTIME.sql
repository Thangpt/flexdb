--
--
/
DELETE SYSVAR WHERE VARNAME = 'ATCSTARTTIME';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ATCSTARTTIME','090500','Thoi gian bat dau cho phep lenh ATC',null,'N');
COMMIT;
/
