﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'VOUCHER';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','VOUCHER','P','Chờ',1,'Y','Chờ');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','VOUCHER','C','Hoàn tất',0,'Y','Hoàn tất');
COMMIT;
/
