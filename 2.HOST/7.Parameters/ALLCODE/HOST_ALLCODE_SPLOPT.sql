﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'SPLOPT';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','SPLOPT','Q','Tách theo khối lượng',2,'Y','Tách theo khối lượng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','SPLOPT','O','Tách theo số lệnh',1,'Y','Tách theo số lệnh');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','SPLOPT','N','Không tách lệnh',0,'Y','Không tách lệnh');
COMMIT;
/
