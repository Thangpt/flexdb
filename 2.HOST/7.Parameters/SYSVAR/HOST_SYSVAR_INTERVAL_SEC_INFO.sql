﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'INTERVAL_SEC_INFO';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','INTERVAL_SEC_INFO','30000',null,null,'N');
COMMIT;
/