﻿--
--
/
DELETE APPMODULES WHERE MODCODE = 'GL';
INSERT INTO APPMODULES (TXCODE,MODCODE,MODNAME,CLASSNAME)
VALUES ('99','GL','Kế toán','GL');
COMMIT;
/
