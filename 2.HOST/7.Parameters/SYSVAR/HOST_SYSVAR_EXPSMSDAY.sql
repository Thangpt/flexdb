﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'EXPSMSDAY';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('DEFINED','EXPSMSDAY','3','So ngay hieu luc cua SMS','So ngay hieu luc cua SMS','N');
COMMIT;
/