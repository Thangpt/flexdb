﻿--
--
/
DELETE APPRVRQD WHERE OBJNAME = 'CFOTHERACC';
INSERT INTO APPRVRQD (OBJNAME,RQDSTRING,MAKERID,MAKERDT,APPRVID,APPRVDT,MODNUM)
VALUES ('CFOTHERACC','ALL',null,null,null,null,'1');
COMMIT;
/
