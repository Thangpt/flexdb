﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'BOARD';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','BOARD','O','Lô lẻ',2,'Y','Lô lẻ');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','BOARD','M','Bảng chính',1,'Y','Bảng chính');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','BOARD','B','Lô lớn',0,'Y','Lô lớn');
COMMIT;
/