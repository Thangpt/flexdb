﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'BANKACCTVALIDATE';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('CF','BANKACCTVALIDATE','Y','Co kiem tra tai khoan ngan hang khong','Co kiem tra tai khoan ngan hang khong','N');
COMMIT;
/
