﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'CADUTY';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','CADUTY','0.5','Coporate action duty!',null,'N');
COMMIT;
/
