﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'RPCLASS';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RP','RPCLASS','003','Kỳ hạn',2,'Y','Kỳ hạn');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RP','RPCLASS','002','ReREPO',1,'Y','ReREPO');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RP','RPCLASS','001','REPO',0,'Y','REPO');
COMMIT;
/
