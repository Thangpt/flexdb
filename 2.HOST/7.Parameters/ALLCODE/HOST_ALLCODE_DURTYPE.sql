﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'DURTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','DURTYPE','L','Dài hạn',2,'Y','Dài hạn');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','DURTYPE','M','Trung hạn',1,'Y','Trung hạn');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','DURTYPE','S','Ngắn hạn',0,'Y','Ngắn hạn');
COMMIT;
/
