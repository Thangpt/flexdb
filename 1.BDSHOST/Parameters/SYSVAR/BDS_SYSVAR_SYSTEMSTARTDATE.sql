﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'SYSTEMSTARTDATE';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','SYSTEMSTARTDATE','01/02/2012','Ngày bắt đầu chạy thật của hệ thống','System begin start date','N');
COMMIT;
/
