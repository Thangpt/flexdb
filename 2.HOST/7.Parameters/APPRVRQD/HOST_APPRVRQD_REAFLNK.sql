﻿--
--
/
DELETE APPRVRQD WHERE OBJNAME = 'REAFLNK';
INSERT INTO APPRVRQD (OBJNAME,RQDSTRING,MAKERID,MAKERDT,APPRVID,APPRVDT,MODNUM)
VALUES ('REAFLNK','ALL',null,null,null,null,'1');
COMMIT;
/