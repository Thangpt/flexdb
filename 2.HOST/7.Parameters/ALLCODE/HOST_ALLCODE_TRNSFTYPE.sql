﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'TRNSFTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TRNSFTYPE','001','Chuyển bán',0,'Y','TN');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TRNSFTYPE','000','Chuyển vay',0,'Y','T0');
COMMIT;
/
