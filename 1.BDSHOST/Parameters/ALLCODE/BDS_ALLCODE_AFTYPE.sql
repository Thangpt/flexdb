﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'AFTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','AFTYPE','006','TK lưu ký',5,'N','TK lưu ký');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','AFTYPE','005','TK liên kết',4,'N','TK liên kết');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','AFTYPE','004','Tổ chức tài chính',3,'N','Tổ chức tài chính');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','AFTYPE','003','CLB đầu tư',2,'N','CLB đầu tư');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','AFTYPE','002','Tổ chức',1,'Y','Tổ chức');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','AFTYPE','001','Cá nhân',0,'Y','Cá nhân');
COMMIT;
/