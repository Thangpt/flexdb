﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'TYPORMST';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TYPORMST','M','Tiểu khoản',1,'Y','Sub account');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TYPORMST','T','Loại hình',0,'Y','Product type');
COMMIT;
/