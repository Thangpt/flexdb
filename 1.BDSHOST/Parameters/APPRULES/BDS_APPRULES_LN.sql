--
--
/
DELETE APPRULES WHERE APPTYPE = 'LN';
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','22','LNMAST','FEEDUE','>=',-540013,'Over due fee',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','21','LNAPPL','INUSEDAMT','==',-540010,'Inused amount must be zero',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','20','LNAPPL','STATUS','IN',-540001,'Invalid status',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','19','LNMAST','OINTDUE','>=',-540012,'Over T+0 due interest',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','18','LNMAST','OPRINNML','>=',-540011,'Over T+0 normal principal',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','17','LNMAST','INTOVDACR','==',-540009,'Over overdue interest',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','16','LNMAST','INTNMLOVD','==',-540007,'Over overdue interest',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','15','LNMAST','INTDUE','==',-540005,'Over due interest',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','14','LNMAST','INTNMLACR','==',-540004,'Over normal interest',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','13','LNMAST','PRINOVD','==',-540003,'Over overdue principal',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','12','LNMAST','PRINNML','==',-540002,'Over normal principal',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','11','LNMAST','STATUS','NI',-540001,'Invalid status',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','10','LNMAST','INTOVDACR','>=',-540009,'Over overdue interest',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','09','LNMAST','LNTYPE','NI',-540008,'Invalid loan type',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','08','LNMAST','APRLIMIT','>=',-540110,'Over approved limit',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','07','LNMAST','INTNMLOVD','>=',-540007,'Over overdue interest',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','06','LNMAST','INTNMLPBL','>=',-540006,'Over payable interest',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','05','LNMAST','INTDUE','>=',-540005,'Over due interest',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','04','LNMAST','INTNMLACR','>=',-540004,'Over normal interest',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','03','LNMAST','PRINOVD','>=',-540003,'Over overdue principal',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','02','LNMAST','PRINNML','>=',-540002,'Over normal principal',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('LN','01','LNMAST','STATUS','IN',-540001,'Invalid status',null,null);
COMMIT;
/
