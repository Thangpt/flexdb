﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'DUEDATE';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','DUEDATE','22/06/2009','GET ODMAST DUEDATE',null,'N');
COMMIT;
/
