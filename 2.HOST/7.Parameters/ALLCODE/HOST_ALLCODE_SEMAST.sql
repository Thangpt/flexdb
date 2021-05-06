﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'SEMAST';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','015','Tạm giữ',14,'Y','Tạm giữ');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','014','Cost date',13,'Y','Cost date');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','013','Nhận',12,'Y','Nhận');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','012','Phong tỏa',11,'Y','Phong tỏa');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','011','Vay',10,'Y','Vay');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','010','Gửi',9,'Y','Gửi');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','009','Rút',8,'Y','Rút');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','008','STANDING',7,'Y','STANDING');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','007','Bù trừ',6,'Y','Bù trừ');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','006','Ký quỹ',5,'Y','Ký quỹ');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','005','TS thế chấp',4,'Y','TS thế chấp');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','004','Giao dịch',3,'Y','Giao dịch');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','003','Giá vốn',2,'Y','Giá vốn');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','002','Trạng thái',1,'Y','Trạng thái');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('IC','SEMAST','001','Ngày GD cuối',0,'Y','Ngày GD cuối');
COMMIT;
/
