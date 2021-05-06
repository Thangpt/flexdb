﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'ROLECD';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','ROLECD','005','Khác',4,'Y','Khác');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','ROLECD','004','Cổ đông lớn',3,'Y','Cổ đông lớn');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','ROLECD','003','Ban điều hành',2,'Y','Ban điều hành');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','ROLECD','002','Ban kiểm soát',1,'Y','Ban kiểm soát');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','ROLECD','001','HĐQT',0,'Y','HĐQT');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','ROLECD','005','Khác',4,'Y','Khác');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','ROLECD','004','Cổ đông lớn',3,'Y','Cổ đông lớn');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','ROLECD','003','HĐQT',2,'Y','HĐQT');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','ROLECD','002','Kiểm toán',1,'Y','Kiểm toán');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','ROLECD','001','Ban điều hành',0,'Y','Ban điều hành');
COMMIT;
/
