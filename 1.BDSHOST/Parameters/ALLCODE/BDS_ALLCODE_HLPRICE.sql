﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'HLPRICE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('ID','HLPRICE','LOW','Giá thấp nhất',1,'Y','Low');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('ID','HLPRICE','HIGH','Giá cao nhất',0,'Y','High');
COMMIT;
/