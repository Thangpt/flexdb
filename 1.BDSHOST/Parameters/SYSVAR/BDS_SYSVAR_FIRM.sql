﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'FIRM';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','FIRM','091','Cong ty','Firm','N');
COMMIT;
/