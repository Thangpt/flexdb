﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'PMTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','PMTYPE','T','Qui định lịch trả gốc',1,'Y','Template');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','PMTYPE','N','Thông thường',0,'Y','Normal');
COMMIT;
/
