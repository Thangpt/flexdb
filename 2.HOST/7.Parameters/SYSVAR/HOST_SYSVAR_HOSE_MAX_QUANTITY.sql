﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'HOSE_MAX_QUANTITY';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('BROKERDESK','HOSE_MAX_QUANTITY','500000','Khối lượng tối đa của 1 lệnh HOSE','Warning quantity on BD','N');
COMMIT;
/
