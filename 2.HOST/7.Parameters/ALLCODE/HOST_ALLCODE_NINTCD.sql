﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'NINTCD';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','NINTCD','001','Bậc thang khi trả',1,'Y','Tier on payment');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','NINTCD','000','Tính lãi hằng ngày',0,'Y','Daily');
COMMIT;
/