﻿--
--
/
DELETE APPMODULES WHERE MODCODE = 'MR';
INSERT INTO APPMODULES (TXCODE,MODCODE,MODNAME,CLASSNAME)
VALUES ('18','MR','Margin credit line','MR');
COMMIT;
/
