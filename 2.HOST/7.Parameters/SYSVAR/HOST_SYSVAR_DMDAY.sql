﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'DMDAY';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','DMDAY','360','Số ngày ngủ đông','dm day','Y');
COMMIT;
/