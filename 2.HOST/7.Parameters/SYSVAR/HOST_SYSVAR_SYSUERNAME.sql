﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'SYSUERNAME';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','SYSUERNAME','vinh.luc','Dịch vụ khách hàng','customer service','N');
COMMIT;
/
