﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'HNX_MINBREAKSIZE_CNT';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','HNX_MINBREAKSIZE_CNT','1','Sá»‘ lá»‡nh tÃ¡ch tá»‘i thiá»ƒu','HSX: Minimum order break size','N');
COMMIT;
/
