﻿--
--
/
DELETE APPRULES WHERE APPTYPE = 'RM';
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('RM','03','CRBTRFLOG','ERRSTS','IN',-100432,'Trạng thái bảng kê không hợp lệ','CRBDEFBANK',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('RM','02','CRBTRFLOG','STATUS','IN',-100432,'Trạng thái bảng kê không hợp lệ','CRBDEFBANK',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('RM','01','CRBDEFBANK','STATUS','IN',-660001,'Bank status invalid','CRBDEFBANK',null);
COMMIT;
/
