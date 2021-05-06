--
--
/
DELETE SYSVAR WHERE VARNAME = 'AFCHALLENGE';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SA','AFCHALLENGE','ABC','Loại hình khách hàng tham gia cuộc thi KB Challenge','Loại hình khách hàng tham gia cuộc thi KB Challenge','Y');
COMMIT;
/
