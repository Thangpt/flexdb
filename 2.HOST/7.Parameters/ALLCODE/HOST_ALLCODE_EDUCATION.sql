﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'EDUCATION';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','EDUCATION','004','Khác',3,'Y','Khác');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','EDUCATION','003','Cấp 2',2,'Y','Cấp 2');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','EDUCATION','002','Đại Học',1,'Y','Đại Học');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','EDUCATION','001','Cấp 3',0,'Y','Cấp 3');
COMMIT;
/