﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'HOSTSERVICEURL';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','HOSTSERVICEURL','http://10.100.20.21/HOSTService/HOSTService.svc','URL of HostService',null,'N');
COMMIT;
/
