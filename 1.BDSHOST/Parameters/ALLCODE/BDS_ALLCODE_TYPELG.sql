﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'TYPELG';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','TYPELG','O','OTC',3,'Y','OTC');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','TYPELG','P','Tự doanh',2,'Y','Tự doanh');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','TYPELG','F','Nước ngoài',1,'Y','Nước ngoài');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','TYPELG','C','Trong nước',0,'Y','Trong nước');
COMMIT;
/