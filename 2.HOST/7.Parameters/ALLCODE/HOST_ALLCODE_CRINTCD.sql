﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'CRINTCD';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CI','CRINTCD','001','Tính lãi hằng ngày',1,'Y','Tính lãi hằng ngày');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CI','CRINTCD','000','Không tính lãi',0,'Y','Không tính lãi');
COMMIT;
/
