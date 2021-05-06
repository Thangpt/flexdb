﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'PERCENTCHANGE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('ID','PERCENTCHANGE','-3','Giá giảm >= 3%',7,'Y','less than 3%');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('ID','PERCENTCHANGE','-2','Giá giảm >= 2%',6,'Y','less than 2%');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('ID','PERCENTCHANGE','-1','Giá giảm >= 1%',5,'Y','less than 1%');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('ID','PERCENTCHANGE','3','Giá tăng >= 3%',3,'Y','greater than 3%');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('ID','PERCENTCHANGE','2','Giá tăng >= 2%',2,'Y','greater than 2%');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('ID','PERCENTCHANGE','1','Giá tăng >= 1%',1,'Y','greater than 1%');
COMMIT;
/
