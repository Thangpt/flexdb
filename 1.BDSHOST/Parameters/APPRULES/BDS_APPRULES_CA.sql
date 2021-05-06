﻿--
--
/
DELETE APPRULES WHERE APPTYPE = 'CA';
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CA','24','CASCHD','ISCISE','IN',-122201,'ERR_ISCISE_STATUS_INVALID','CASCHD',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CA','23','CASCHD','ISCI','IN',-122201,'ERR_ISCI_STATUS_INVALID','CASCHD',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CA','05','CASCHD','STATUS','IN',-300017,'ERR_CASCHD_STATUS_INVALID','CASCHD',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CA','04','CAMAST','ACTIONDATE','>=',-300016,'ERR_ACTIONDATE_INVALID','CAMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CA','03','CAMAST','REPORTDATE','>=',-300015,'ERR_REPORTDATE_INVALID','CAMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CA','02','CASCHD','STATUS','IN',-300014,'ERR_CASCHD_STATUS_INVALID','CASCHD',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('CA','01','CAMAST','STATUS','IN',-300013,'ERR_CAMAST_STATUS_INVALID','CAMAST',null);
COMMIT;
/
