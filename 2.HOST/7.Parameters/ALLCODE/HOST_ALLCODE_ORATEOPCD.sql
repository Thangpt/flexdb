﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'ORATEOPCD';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','ORATEOPCD','-','Minus',1,'Y','Minus');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','ORATEOPCD','%','Percentage',1,'Y','Percentage');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','ORATEOPCD','+','Plus',0,'Y','Plus');
COMMIT;
/
