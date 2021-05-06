﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'CASTATUS';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','O','Đã chuyển khoản để đóng tài khoản',14,'Y','Đã chuyển khoản để đóng tài khoản');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','W','Đã chuyển chứng khoán chờ giao dịch thành giao dịch',13,'Y','Đã chuyển chứng khoán chờ giao dịch thành giao dịch');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','J','Hoàn tất phân bổ',12,'Y','Hoàn tất phân bổ');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','H','Đã thực hiện phân bổ chứng khoán 3341',11,'Y','Đã thực hiện phân bổ chứng khoán 3341');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','G','Đã thực hiện phân bổ tiền 3342',10,'Y','Đã thực hiện phân bổ tiền 3342');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','B','Không có số dư chứng khoán',9,'Y','Không có số dư chứng khoán');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','V','Đã xác nhận với VSD',8,'Y','Đã xác nhận với VSD');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','E','Từ chối',7,'Y','Từ chối');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','M','Đã thực hiện 3384',7,'Y','Đã thực hiện 3384');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','R','Hủy',6,'Y','Hủy');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','D','Đã xóa',5,'Y','Đã xóa');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','C','Thành công',4,'Y','Thành công');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','S','Xác nhận',3,'Y','Xác nhận');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','A','Chờ xác nhận',2,'Y','Chờ xác nhận');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','N','Duyệt',1,'Y','Duyệt');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','P','Chờ duyệt',0,'Y','Chờ duyệt');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','CASTATUS','I','Chờ thực hiện',0,'Y','Chờ thực hiện');
COMMIT;
/