﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'TEMPLATE_CYCLE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TEMPLATE_CYCLE','Y','Hàng năm',5,'Y','Yearly');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TEMPLATE_CYCLE','M','Hàng tháng',4,'Y','Monthly');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TEMPLATE_CYCLE','W','Hàng tuần',3,'Y','Weekly');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TEMPLATE_CYCLE','D','Hàng ngày',2,'Y','Daily');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TEMPLATE_CYCLE','P','Gửi ngay',1,'Y','Passive');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TEMPLATE_CYCLE','I','Gửi liên tục',1,'Y','Immediate');
COMMIT;
/