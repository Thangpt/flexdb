﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'LMCHKTYP';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','LMCHKTYP','B','Số dư đầu ngày',1,'Y','BOD balance');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','LMCHKTYP','C','Số dư hiện tại',0,'Y','Current balance');
COMMIT;
/
