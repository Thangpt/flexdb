﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'OPTFORCESELL';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','OPTFORCESELL','M','Luật bán force sell (Rat - I hoặc Rdt - M)','Rule for force sell','Y');
COMMIT;
/
