﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'TLLOGINTERVAL';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','TLLOGINTERVAL','0','Interval for tllog searching','Interval for tllog searching','N');
COMMIT;
/
