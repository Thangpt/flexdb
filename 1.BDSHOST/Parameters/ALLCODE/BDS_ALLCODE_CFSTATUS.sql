﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'CFSTATUS';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CFSTATUS','N','Chờ đóng',6,'Y','Chờ đóng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CFSTATUS','E','Yêu cầu sửa lại',5,'Y','Yêu cầu sửa lại');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CFSTATUS','R','Hủy và làm mới',4,'Y','Hủy và làm mới');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CFSTATUS','C','Đóng',3,'Y','Đóng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CFSTATUS','B','Phong tỏa',2,'Y','Phong tỏa');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CFSTATUS','A','Hoạt động',1,'Y','Hoạt động');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CFSTATUS','P','Chờ duyệt',0,'Y','Chờ duyệt');
COMMIT;
/
