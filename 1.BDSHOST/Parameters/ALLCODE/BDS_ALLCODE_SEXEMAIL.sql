﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'SEXEMAIL';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','SEXEMAIL','003',null,2,'Y',null);
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','SEXEMAIL','002','Bà',1,'Y','Ms');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','SEXEMAIL','001','Ông',0,'Y','Mr');
COMMIT;
/
