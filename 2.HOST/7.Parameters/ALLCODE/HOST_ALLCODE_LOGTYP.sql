﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'LOGTYP';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','LOGTYP','M','Ghép lệnh',1,'Y','Ghép lệnh');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','LOGTYP','C','Sửa lỗi',0,'Y','Sửa lỗi');
COMMIT;
/
