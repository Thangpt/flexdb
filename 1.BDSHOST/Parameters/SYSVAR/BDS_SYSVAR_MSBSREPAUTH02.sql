﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'MSBSREPAUTH02';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('REPRESENT','MSBSREPAUTH02','Số 19/2013/UQ-MSBS','TGĐ Mạc Quang Huy','14/01/2013','N');
COMMIT;
/