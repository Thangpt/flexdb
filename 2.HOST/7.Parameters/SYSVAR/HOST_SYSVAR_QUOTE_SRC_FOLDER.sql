﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'QUOTE_SRC_FOLDER';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','QUOTE_SRC_FOLDER','C:\QUOTE_SRC_FOLDER',null,null,'N');
COMMIT;
/
