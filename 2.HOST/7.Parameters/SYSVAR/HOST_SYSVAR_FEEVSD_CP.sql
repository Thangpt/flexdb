﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'FEEVSD_CP';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('DEFINED','FEEVSD_CP','0.03','TI LE PHI TRA VSD CHO CP HOSE, HNX','VSD SHARES PAID FEE RATE (HOSE, HNX)','N');
COMMIT;
/
