﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'MARGINTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','MARGINTYPE','T','Credit line',2,'Y','Credit line');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','MARGINTYPE','L','Margin loan',1,'Y','Margin loan');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','MARGINTYPE','N','Normal',0,'Y','Normal');
COMMIT;
/
