﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'T0OVRQRATIO';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('MARGIN','T0OVRQRATIO','70','Tỷ lệ vay bảo lãnh.','T0OVER Ratio','Y');
COMMIT;
/