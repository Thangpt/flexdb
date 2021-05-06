﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'TRFLOGSTS';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFLOGSTS','B','Gửi lại',9,'N','Resend');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFLOGSTS','D','Ðã xoá',8,'N','Deleted');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFLOGSTS','H','Hoàn thành 1 phần',7,'N','Half Finish');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFLOGSTS','F','Hoàn thành',6,'N','Finish');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFLOGSTS','E','NH xác nhận có lỗi',5,'N','Error');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFLOGSTS','R','NH từ chối',4,'N','Rejected');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFLOGSTS','C','NH đã xác nhận',3,'N','Confirmed');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFLOGSTS','S','Đã gửi sang NH',2,'N','Sent');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFLOGSTS','A','Chờ gửi',1,'N','Sending');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFLOGSTS','P','Chờ xử lý',0,'N','Pending');
COMMIT;
/