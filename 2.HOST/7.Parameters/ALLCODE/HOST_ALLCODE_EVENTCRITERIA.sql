﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'EVENTCRITERIA';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CI','EVENTCRITERIA','002','Lãi cộng dồn > 0 và Trái thái <> Đóng',0,'Y','Lãi cộng dồn > 0 và Trái thái <> Đóng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CI','EVENTCRITERIA','001','Số dư >0 và Trạng thái <> Đóng',0,'Y','Số dư >0 và Trạng thái <> Đóng');
COMMIT;
/
