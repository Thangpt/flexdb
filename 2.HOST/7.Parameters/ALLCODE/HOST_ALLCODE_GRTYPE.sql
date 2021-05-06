﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'GRTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GR','GRTYPE','010','Bảo lãnh khác',9,'Y','Bảo lãnh khác');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GR','GRTYPE','009','Bảo lãnh đối ứng',8,'Y','Bảo lãnh đối ứng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GR','GRTYPE','008','Bảo lãnh BH chất lượng sản phẩm',7,'Y','Bảo lãnh BH chất lượng sản phẩm');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GR','GRTYPE','007','Bảo lãnh vay vốn trong nước',6,'Y','Bảo lãnh vay vốn trong nước');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GR','GRTYPE','006','Bảo lãnh mua thiết bị trả chậm',5,'Y','Bảo lãnh mua thiết bị trả chậm');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GR','GRTYPE','005','Bảo lãnh nộp thuế',4,'Y','Bảo lãnh nộp thuế');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GR','GRTYPE','004','Bảo lãnh thanh toán',3,'Y','Bảo lãnh thanh toán');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GR','GRTYPE','003','Bảo lãnh hoàn trả ứng trước',2,'Y','Bảo lãnh hoàn trả ứng trước');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GR','GRTYPE','002','Bảo lãnh thực hiện HĐ',1,'Y','Bảo lãnh thực hiện HĐ');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GR','GRTYPE','001','Bảo lãnh dự thầu',0,'Y','Bảo lãnh dự thầu');
COMMIT;
/
