﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'RM6610';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('RM6610','Tra cứu các giao dịch phong toả bị lệch (6610)','View unmatched holdid (6610)','SELECT CH.REFNO,CH.BANKCODE,CRB.BANKNAME,CF.CUSTODYCD,CF.FULLNAME,AF.ACCTNO AFACCTNO,
CH.BANKACCTNO,CH.HOLDAMOUNT,CH.BANKAMOUNT,CI.HOLDBALANCE,CG.TOTALCHOLD,CG.TOTALBHOLD
FROM CRBHOLDLIST CH,CRBDEFBANK CRB,AFMAST AF,CFMAST CF,CIMAST CI,
(
    SELECT BANKCODE,BANKACCTNO,SUM(HOLDAMOUNT) TOTALCHOLD,SUM(BANKAMOUNT) TOTALBHOLD
    FROM CRBHOLDLIST WHERE STATUS IN (''A'',''V'') GROUP BY BANKCODE,BANKACCTNO
) CG
WHERE CH.BANKCODE=AF.BANKNAME AND CH.BANKACCTNO=AF.BANKACCTNO
AND CH.BANKCODE=CRB.BANKCODE AND AF.CUSTID=CF.CUSTID
AND CI.AFACCTNO=AF.ACCTNO AND CH.BANKCODE=CG.BANKCODE
AND CH.BANKACCTNO=CG.BANKACCTNO AND CH.STATUS IN (''A'',''V'')
AND (CH.HOLDAMOUNT<>CH.BANKAMOUNT OR CG.TOTALCHOLD<>CG.TOTALBHOLD)','BANKINFO',null,null,'6610',0,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'RM6610';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'TOTALBHOLD','Tổng đối chiếu','N','RM6610',120,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Total hold of bank','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'TOTALCHOLD','Tổng phong toả theo dõi','N','RM6610',120,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Total hold local','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'HOLDBALANCE','Tổng phong toả của TK','N','RM6610',120,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Total hold of account','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'BANKAMOUNT','Số tiền đối chiếu','N','RM6610',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Bank Amount','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'HOLDAMOUNT','Số tiền phong toả','N','RM6610',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Hold Amount','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'BANKACCTNO','TK ngân hàng','C','RM6610',50,null,'LIKE,=',null,'Y','Y','N',50,null,'Bank Account No','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'AFACCTNO','Số tiểu khoản','C','RM6610',50,null,'LIKE,=',null,'Y','Y','N',50,null,'Account No','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'FULLNAME','Tên KH','C','RM6610',120,null,'LIKE,=',null,'Y','Y','N',120,null,'Customer Name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'CUSTODYCD','Số lưu ký','C','RM6610',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Custody Code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'BANKNAME','Tên ngân hàng','C','RM6610',120,null,'LIKE,=',null,'Y','Y','N',120,null,'Bank Name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'BANKCODE','Mã ngân hàng','C','RM6610',50,null,'LIKE,=',null,'Y','Y','N',50,null,'Bank Code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'REFNO','Số hiệu phong toả','C','RM6610',100,null,'LIKE,=',null,'Y','Y','Y',100,null,'Ref No','N',null,null,'N',null,null,null,'N');
COMMIT;
/