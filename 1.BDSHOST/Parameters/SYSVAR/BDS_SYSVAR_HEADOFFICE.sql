--
--
/
DELETE SYSVAR WHERE VARNAME = 'HEADOFFICE';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','HEADOFFICE','CÔNG TY CỔ PHẦN CHỨNG KHOÁN KB VIỆT NAM',null,null,'N');
COMMIT;
/
