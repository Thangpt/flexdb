﻿--
--
/
DELETE APPRVRQD WHERE OBJNAME = 'AFMAST';
INSERT INTO APPRVRQD (OBJNAME,RQDSTRING,MAKERID,MAKERDT,APPRVID,APPRVDT,MODNUM)
VALUES ('AFMAST','ALL',null,null,null,null,'1');
COMMIT;
/
