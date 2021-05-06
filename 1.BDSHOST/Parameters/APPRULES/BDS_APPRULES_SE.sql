﻿--
--
/
DELETE APPRULES WHERE APPTYPE = 'SE';
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','30','SBSECURITIES','CAREBY','CB',-900100,'ERR_SBSECURITIES_CAREBY_INVALID','SBSECURITIES',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','25','SEMAST','DTOCLOSE','>=',-900120,'AMOUNT OVER DTOCLOSE','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','23','SEMAST','SENDDEPOSIT','>=',-900057,'AMOUNT OVER SENDDEPOSIT','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','20','SEMAST','BLOCKQTTY','>=',-900040,'Block not enought','SEBLOCKDEAL',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','19','SEMAST','RECEIVING','>=',-900054,'RECEIVING AMOUNT IS NOT ENOUGHT','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','18','SEMAST','RETAILLOT','<=',-900053,'AMOUNT IS NOT RETAIL','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','17','SEMAST','ABSSTANDING','>=',-900050,'AMOUNT OVER MORTAGE','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','16','SEMORTAGEDTL','STATUS','IN',-900049,'[-900049]: INVALID STATUS',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','15','SEWITHDRAWDTL','STATUS','IN',-900046,'[-900046]: INVALID STATUS',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','14','SEWITHDRAWDTL','STATUS','IN',-900043,'[-900043]: Invalid SEWITHDRAWDTL status',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','13','SEREVERT','SESTATUS','<=',-900042,'EXIST INACTIVE SE ACCOUNTS',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','12','SEMAST','TRADING','>=',-900017,'TRADE NOT ENOUGHT',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','11','SEWITHDRAW','AVLSEWITHDRAW','>=',-900017,'TRADE NOT ENOUGHT',null,null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','10','SEMAST','NETTING','>=',-900041,'NETTING NOT ENOUGHT','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','09','SEMAST','MORTAGE','>=',-900020,'AMOUNT OVER MORTAGE','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','08','SEMAST','SENDDEPOSIT','>=',-900020,'AMOUNT OVER SENDDEPOSIT','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','07','SEMAST','SECURED','>=',-900018,'AMOUNT OVER DEPOSIT','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','06','SEMAST','DEPOSIT','>=',-900102,'AMOUNT OVER DEPOSIT','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','05','SEMAST','COSTPRICE','>=',-900014,'COST PRICE NOT ENOUGHT','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','04','SEMAST','BLOCKED','>=',-900040,'BLOCK NOT ENOUGHT','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','03','SEMAST','TRADE','>=',-900017,'TRADE NOT ENOUGHT','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','02','SEMAST','WITHDRAW','>=',-900017,'TRADE NOT ENOUGHT','SEMAST',null);
INSERT INTO APPRULES (APPTYPE,RULECD,TBLNAME,FIELD,OPERAND,ERRNUM,ERRMSG,REFID,FLDRND)
VALUES ('SE','01','SEMAST','STATUS','IN',-900019,'Invalid status','SEMAST',null);
COMMIT;
/
