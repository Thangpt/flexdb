﻿--
--
/
DELETE APPMODULES WHERE MODCODE = 'CL';
INSERT INTO APPMODULES (TXCODE,MODCODE,MODNAME,CLASSNAME)
VALUES ('52','CL','Tài sản thế chấp','CL');
COMMIT;
/
