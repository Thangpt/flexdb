﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'TCDTBIDV';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','TCDTBIDV','1','1: chay TCDTBIDV, 0: khong chay. ',null,'Y');
COMMIT;
/
