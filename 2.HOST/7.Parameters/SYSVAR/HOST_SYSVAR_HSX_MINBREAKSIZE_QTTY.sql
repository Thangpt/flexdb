﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'HSX_MINBREAKSIZE_QTTY';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','HSX_MINBREAKSIZE_QTTY','1000','Khá»‘i lÆ°á»£ng tÃ¡ch lá»‡nh tá»‘i thiá»ƒu','HSX: Minimum quantiy break size','N');
COMMIT;
/
