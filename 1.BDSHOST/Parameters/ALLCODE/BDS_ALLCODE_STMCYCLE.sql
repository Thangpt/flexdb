﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'STMCYCLE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','STMCYCLE','Y','Hằng năm',2,'Y','Hằng năm');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','STMCYCLE','Q','Hằng quý',1,'Y','Hằng quý');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','STMCYCLE','M','Hằng tháng',0,'Y','Hằng tháng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CI','STMCYCLE','Y','Hằng năm',2,'Y','Hằng năm');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CI','STMCYCLE','Q','Hằng quý',1,'Y','Hằng quý');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CI','STMCYCLE','M','Hằng tháng',0,'Y','Hằng tháng');
COMMIT;
/