﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'INVPOLICY';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','INVPOLICY','L','Chỉ định',2,'Y','Limited');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','INVPOLICY','E','Loại trừ',1,'Y','Excluded');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','INVPOLICY','N','Không có',0,'Y','None');
COMMIT;
/
