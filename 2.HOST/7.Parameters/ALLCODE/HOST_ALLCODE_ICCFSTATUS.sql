﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'ICCFSTATUS';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','ICCFSTATUS','S','Tạm dừng',1,'Y','Tạm dừng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','ICCFSTATUS','E','Hết hiệu lực',1,'Y','Hết hiệu lực');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','ICCFSTATUS','C','Tùy biến',1,'Y','Tùy biến');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','ICCFSTATUS','C','Đóng',1,'Y','Đóng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','ICCFSTATUS','A','Hoạt động',0,'Y','Hoạt động');
COMMIT;
/
