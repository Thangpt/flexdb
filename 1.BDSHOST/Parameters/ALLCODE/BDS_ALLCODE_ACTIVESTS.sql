﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'ACTIVESTS';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','ACTIVESTS','P','Chờ kích hoạt',2,'Y','Pending');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','ACTIVESTS','N','Chưa kích hoạt',1,'Y','Inactive');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','ACTIVESTS','Y','Đã kích hoạt',0,'Y','Actived');
COMMIT;
/
