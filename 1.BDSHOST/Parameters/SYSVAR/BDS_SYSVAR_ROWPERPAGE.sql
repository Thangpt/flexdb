﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'ROWPERPAGE';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ROWPERPAGE','100','Row in page',null,'N');
COMMIT;
/
