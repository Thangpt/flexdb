﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'AFGRP';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','AFGRP','004','Lưu ký nơi khác',3,'Y','Lưu ký nơi khác');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','AFGRP','003','Tự doanh',2,'Y','Tự doanh');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','AFGRP','002','Môi giới nước ngoài',1,'Y','Môi giới nước ngoài');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','AFGRP','001','Môi giới trong nước',0,'Y','Môi giới trong nước');
COMMIT;
/
