﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'REFPOLICYCD';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','REFPOLICYCD','E','Cấm',2,'Y','Exception is forbidden');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','REFPOLICYCD','L','Cho phép',1,'Y','Limited');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','REFPOLICYCD','N','Không qui định',0,'Y','None');
COMMIT;
/
