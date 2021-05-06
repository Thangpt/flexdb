﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'TYPESUBCD';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','TYPESUBCD','F','KH nước ngoài',2,'Y','Foreign customer');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','TYPESUBCD','C','KH trong nước',1,'Y','Domestic customer');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','TYPESUBCD','P','Tự doanh',0,'Y','Prop. Trade');
COMMIT;
/