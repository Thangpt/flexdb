﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'ODSEND_TRADEPLACE';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ODSEND_TRADEPLACE',null,'USE HOSEGW','Used HoseGW','N');
COMMIT;
/
