﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'DAMINBAL';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('DEFINED','DAMINBAL','0','Day advanced min balance!',null,'N');
COMMIT;
/
