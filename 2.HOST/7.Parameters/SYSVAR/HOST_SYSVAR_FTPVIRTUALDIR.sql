--
--
/
DELETE SYSVAR WHERE VARNAME = 'FTPVIRTUALDIR';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','FTPVIRTUALDIR','D:\ftpmail\Upload\','Đường dẫn virtual của ftp server chua file upload','Virtual directory of ftp service','Y');
COMMIT;
/
