﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'FEETYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CI','FEETYPE','VSDDEP','Phí LK trả VSD',1,'Y','VSD depository fee');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CI','FEETYPE','EXCBRK','Phí GD trả SGDCK',0,'Y','Exchange trading fee');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','FEETYPE','C','Phân lớp',2,'Y','Cluster');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','FEETYPE','T','Bậc thang',1,'Y','Tier');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','FEETYPE','F','Cố định',0,'Y','Fixed');
COMMIT;
/
