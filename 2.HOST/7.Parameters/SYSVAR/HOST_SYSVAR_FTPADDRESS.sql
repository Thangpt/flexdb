﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'FTPADDRESS';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','FTPADDRESS','ftp://10.100.20.25/Upload/','Địa chỉ ftp server','Ftp server address','Y');
COMMIT;
/
