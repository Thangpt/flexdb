﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'ADVSELLDUTY_SET';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ADVSELLDUTY_SET','0.1','Advanced sell duty setting!',null,'Y');
COMMIT;
/