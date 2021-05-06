﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'ATYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','ATYPE','TD','Tiết kiệm',3,'Y','Term deposit');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','ATYPE','FX','Ngoại tệ',2,'Y','Foreign currency');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','ATYPE','RE','Bất động sản',1,'Y','Real estate');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','ATYPE','SE','Chứng khoán',0,'Y','Securities');
COMMIT;
/
