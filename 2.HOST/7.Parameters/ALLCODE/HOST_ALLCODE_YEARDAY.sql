﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'YEARDAY';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','YEARDAY','E','Tháng kiểu Euro',2,'Y','Tháng kiểu Euro');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','YEARDAY','M','Hằng tháng',1,'Y','Hằng tháng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','YEARDAY','A','Thực tế',0,'Y','Thực tế');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','YEARDAY','M','Năm',1,'Y','Năm');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','YEARDAY','E','Năm - Euro',1,'Y','Năm - Euro');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','YEARDAY','A','Thực tế',0,'Y','Thực tế');
COMMIT;
/
