﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'CONTACTTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CONTACTTYPE','003','Khác',2,'Y','Khác');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CONTACTTYPE','002','Tổ chức',1,'Y','Tổ chức');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CONTACTTYPE','001','Cá nhân',0,'Y','Cá nhân');
COMMIT;
/
