﻿--
--
/
DELETE APPRVRQD WHERE OBJNAME = 'SETYPE';
INSERT INTO APPRVRQD (OBJNAME,RQDSTRING,MAKERID,MAKERDT,APPRVID,APPRVDT,MODNUM)
VALUES ('SETYPE','ALL',null,null,null,null,'1');
COMMIT;
/
