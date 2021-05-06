﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CLLINK';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CLLINK','Thong tin the chap','Mortgage information','SELECT LMACCTNO REF_ACCTNO, MAX(CF.FULLNAME) DES_ACCTNO,
SUM(CASE WHEN DORC=''C'' THEN CLAMT ELSE -CLAMT END) AMT
FROM CLLINK DTL, AFMAST AF, CFMAST CF
WHERE AF.ACCTNO=DTL.LMACCTNO AND DTL.CLACCTNO=''<$KEYVAL>'' AND AF.CUSTID = CF.CUSTID
GROUP BY DTL.LMACCTNO HAVING SUM(CASE WHEN DORC=''C'' THEN CLAMT ELSE -CLAMT END)>0','CL.CLLINK','frmCLLINK',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CLLINK';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'AMT','Gia tri','N','CLLINK',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'Amount','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'DES_ACCTNO','Ho ten','C','CLLINK',100,'cccccc','LIKE,=','_','Y','Y','N',250,null,'Customer name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'REF_ACCTNO','So hop dong','C','CLLINK',100,null,'LIKE,=','_','Y','Y','Y',150,null,'Contract number','N',null,null,'N',null,null,null,'N');
COMMIT;
/
