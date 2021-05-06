﻿--
--
/
DELETE APPRULES WHERE APPTYPE = 'CF';
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CF','34','AFMAST','COREBANK','IN',-200334,'IS_BANKING!','AFMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CF','33','AFMAST','STATUS','NI',-200010,'Invalid status','AFMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CF','32','AFMAST','WARNINGTERMOFUSE','==',-200206,'WARNING_OVER_IDEXPDATE','AFMAST','0');
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CF','31','AFMAST','IDEXPDAYS','>>',-200205,'WARNING_OVER_IDEXPDATE','AFMAST','0');
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CF','30','CFMAST','CAREBY','CB',-200100,'ERR_CFMAST_CAREBY_INVALID','CFMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CF','13','CFBANK','ISBANKSTATUS','>>',-200045,'[-200045]: Trạng thái khách hàng không hợp lệ hoặc Không phải là Ngân hàng !',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CF','12','AFMAST','CUSTODIANTYP','IN',-200300,'[-200300]: Nơi lưu ký không hợp lệ!',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CF','06','AFMAST','CUSTTYPE','IN',-200306,'Loại khách hàng bị chặn không được thực hiện giao dịch này','AFMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CF','05','CFMAST','ISBANKING','IN',-200045,'IS_NOT_BANKING!','CFMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CF','04','AFMAST','STATUS','IN',-200010,'ERR_CF_AFMAST_STATUS_INVALID!','AFMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CF','03','CFMAST','STATUS','IN',-200045,'ERR_INVALIF_CFMAST_STATUS!','CFMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CF','01','AFMAST','STATUS','IN',-200010,'Invalid status','AFMAST',null);
COMMIT;
/
