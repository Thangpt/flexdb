﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'MAX_NUMBER_VALUE';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','MAX_NUMBER_VALUE','1000000000000',null,null,'N');
COMMIT;
/
