﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'REROLE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RE','REROLE','DG','Chăm sóc hộ',4,'Y','Delegate Broker');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RE','REROLE','RM','Chăm sóc tài khoản_CA',2,'Y','Relationship Management');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RE','REROLE','BM','Môi giới_BR',1,'Y','Broker');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RE','REROLE','RD','Người giới thiệu_DSF',0,'Y','Referrer');
COMMIT;
/