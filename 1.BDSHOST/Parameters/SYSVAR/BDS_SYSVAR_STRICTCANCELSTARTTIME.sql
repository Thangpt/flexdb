﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'STRICTCANCELSTARTTIME';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('OL','STRICTCANCELSTARTTIME','0820','Thoi gian bat dau kiem soat huy lenh','Thoi gian bat dau kiem soat huy lenh','N');
COMMIT;
/
