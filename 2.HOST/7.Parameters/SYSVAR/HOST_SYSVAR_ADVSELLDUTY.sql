﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'ADVSELLDUTY';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ADVSELLDUTY','0.1','Advanced sell duty!',null,'N');
COMMIT;
/