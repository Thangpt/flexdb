﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'ATC_PRICETYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','ATC_PRICETYPE','ATC','ATC',2,'Y','ATC');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','ATC_PRICETYPE','LO','Giới hạn',0,'Y','Giới hạn');
COMMIT;
/