﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'TLLOGINTERVAL';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','TLLOGINTERVAL','1','Interval for tllog searching','Interval for tllog searching','N');
COMMIT;
/