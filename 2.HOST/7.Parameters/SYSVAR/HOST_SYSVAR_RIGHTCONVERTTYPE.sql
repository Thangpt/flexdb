﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'RIGHTCONVERTTYPE';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','RIGHTCONVERTTYPE','012/013/017/020/026','Convert type!',null,'N');
COMMIT;
/
