﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'CUSTTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CUSTTYPE','B','Tổ chức',1,'Y','Tổ chức');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CUSTTYPE','I','Cá nhân',0,'Y','Cá nhân');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','CUSTTYPE','B','Ngân hàng lưu ký',4,'Y','Custodian bank');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','CUSTTYPE','O','CTCK khác',4,'Y','Other securities company');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','CUSTTYPE','P','Tự doanh',3,'Y','Prop. trade');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','CUSTTYPE','F','Cty QL quỹ',2,'Y','Fund company');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','CUSTTYPE','N','Thông thường',1,'Y','Normal');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','CUSTTYPE','R','Dự trữ',0,'Y','Reserved');
COMMIT;
/
