﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'TRFTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFTYPE','BA','Chuyển tiền mua',3,'Y','Chuyển tiền mua');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFTYPE','BF','Chuyển phí mua',2,'Y','Chuyển phí mua');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFTYPE','SA','Chuyển tiền bán',1,'Y','Chuyển tiền bán');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RM','TRFTYPE','SF','Chuyển phí bán',0,'Y','Chuyển phí bán');
COMMIT;
/