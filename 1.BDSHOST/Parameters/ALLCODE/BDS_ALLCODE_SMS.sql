﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'SMS';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','SMS','0988913503','Email nhan thong bao',4,'Y','Email nhan thong bao');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','SMS','0988913505','Email nhan thong bao',4,'Y','Email nhan thong bao');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','SMS','0988913504','Email nhan thong bao',4,'Y','Email nhan thong bao');
COMMIT;
/