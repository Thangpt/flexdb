﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'LNDRAWDOWN';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','LNDRAWDOWN','R','Tái ký',1,'Y','ReDrawdown');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','LNDRAWDOWN','D','Giải ngân lần đầu',0,'Y','Drawdown');
COMMIT;
/
