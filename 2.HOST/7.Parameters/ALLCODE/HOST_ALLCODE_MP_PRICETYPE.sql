﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'MP_PRICETYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','MP_PRICETYPE','MP','Thị trường',2,'Y','Thị trường');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','MP_PRICETYPE','LO','Giới hạn',0,'Y','Giới hạn');
COMMIT;
/