﻿--
--
/
DELETE APPMODULES WHERE MODCODE = 'LN';
INSERT INTO APPMODULES (TXCODE,MODCODE,MODNAME,CLASSNAME)
VALUES ('55','LN','Tiền vay','LN');
COMMIT;
/