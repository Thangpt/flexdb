﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'MAXREGRPLEVEL';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','MAXREGRPLEVEL','3','Qui định mức nhóm môi giới tối đa','The maximum level of remiser group','N');
COMMIT;
/
