﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'PRODUCCODE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','PRODUCCODE','MAS10','Không dùng ứng trước trả nợ trong hạn',0,'Y','Do not use adv to pay loan');
COMMIT;
/