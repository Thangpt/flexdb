﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'EMAIL_HCM';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','EMAIL_HCM','CCC.OPEN@kbsec.com.vn','Địa chỉ email RCS','Địa chỉ email RCS','Y');
COMMIT;
/