﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'CONTRACTCHK';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CONTRACTCHK','N','Không',2,'Y','No');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CONTRACTCHK','Y','Có',1,'Y','Yes');
COMMIT;
/
