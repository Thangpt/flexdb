﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'LNMAST_ALL';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('LNMAST_ALL','Tài khoản vay','Customer loan account management','
SELECT MST.PRINNML+MST.PRINOVD+MST.INTNMLACR+MST.INTOVDACR+MST.INTNMLOVD+MST.INTDUE-
MST.INTPREPAID+MST.OPRINNML+MST.OPRINOVD+MST.OINTNMLACR+
MST.OINTOVDACR+MST.OINTNMLOVD+MST.OINTDUE-MST.OINTPREPAID+
MST.FEE+MST.FEEDUE+MST.FEEOVD ODAMT, MST.PRINNML,
MST.PRINOVD, MST.INTDUE, MST.INTNMLOVD, MST.ACTYPE, MST.TRFACCTNO,
TYP.TYPENAME, CF.CUSTID, CF.FULLNAME, MST.ACCTNO, SBY.SHORTCD,
MST.CCYCD, A0.CDCONTENT DESC_STATUS, MST.NOTES, CF.CUSTODYCD,
(CASE WHEN MST.FTYPE =''AF'' THEN 1 ELSE 0 END) FINANCETYPE
FROM LNTYPE TYP, LNMAST MST, SBCURRENCY SBY, CFMAST CF, CIMAST CI, ALLCODE A0
WHERE MST.CCYCD=SBY.CCYCD AND TYP.ACTYPE=MST.ACTYPE AND A0.CDTYPE=''LN''
AND A0.CDNAME=''STATUS'' AND A0.CDVAL=MST.STATUS
AND CI.ACCTNO=MST.TRFACCTNO AND CI.CUSTID=CF.CUSTID
','LNMAST_ALL','frmLNMAST',null,null,null,50,'N',0,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'LNMAST_ALL';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'NOTES','Diễn giải','C','LNMAST_ALL',100,null,'LIKE,=',null,'Y','Y','N',200,null,'Description','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'DESC_STATUS','Trạng thái','C','LNMAST_ALL',100,null,'=',null,'Y','N','N',200,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''LN'' AND CDNAME = ''STATUS'' ORDER BY LSTODR','Status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'ODAMT','Tổng dư nợ','N','LNMAST_ALL',250,null,'<,<=,=,>=,>,<>','#,##0.###0','Y','N','N',100,null,'Loan amount','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'SHORTCD','Loại tiền','C','LNMAST_ALL',100,'cc','LIKE,=','_','Y','Y','N',100,null,'Currency','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'FULLNAME','Tên khách hàng','C','LNMAST_ALL',100,null,'LIKE,=',null,'Y','Y','N',150,null,'Customer name','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'CUSTID','Mã khách hàng','C','LNMAST_ALL',100,null,'LIKE,=',null,'Y','Y','N',150,null,'CustomerID','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'TRFACCTNO','Số tài khoản CI','C','LNMAST_ALL',100,null,'LIKE,=','ccccdcccccc','Y','Y','N',150,null,'CI account number','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'TYPENAME','Tên loại hình','C','LNMAST_ALL',100,null,'LIKE,=',null,'Y','Y','N',150,null,'Product name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'ACTYPE','Mã loại hình','C','LNMAST_ALL',100,'9999','LIKE,=','_','Y','N','N',100,null,'Product type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'ACCTNO','Số tài khoản vay','C','LNMAST_ALL',100,null,'LIKE,=','ccccdccccccdcccccc','Y','Y','Y',150,null,'Loan account number','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-1,'CUSTODYCD','Số lưu ký','C','LNMAST_ALL',100,null,'=, LIKE',null,'Y','Y','N',80,null,'Custody code','N',null,null,'N',null,null,null,'N');
COMMIT;
/