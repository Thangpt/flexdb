﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'V_CRBTRFACCTSRC';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('V_CRBTRFACCTSRC','Quản lý tài khoản nguồn ngân hàng','List of source bank account information','SELECT SRC.AUTOID,SRC.BANKCODE,CRB.BANKCODE || '':'' || CRB.BANKNAME BANKNAME,
SRC.BANKACCTNO,SRC.BANKACCTNAME
FROM CRBTRFACCTSRC SRC,CRBDEFBANK CRB
WHERE SRC.BANKCODE=CRB.BANKCODE','CRBTRFACCTSRC','CRBTRFACCTSRC',null,null,0,50,'N',0,'NNNNNNNNNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'V_CRBTRFACCTSRC';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'BANKACCTNAME','Tên tài khoản','C','V_CRBTRFACCTSRC',150,null,'LIKE,=',null,'Y','Y','N',150,null,'Bank account name','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'BANKACCTNO','Tài khoản','C','V_CRBTRFACCTSRC',100,null,'LIKE,=',null,'Y','Y','Y',100,null,'Bank account no','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'BANKNAME','Ngân hàng','C','V_CRBTRFACCTSRC',250,null,'LIKE,=',null,'Y','Y','N',250,null,'Bank Name','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'BANKCODE','Ngân hàng','C','V_CRBTRFACCTSRC',100,null,'LIKE,=',null,'N','N','N',100,null,'Bank code','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Mã quản lý','N','V_CRBTRFACCTSRC',80,null,'=',null,'N','N','N',80,null,'AutoID','Y',null,null,'N',null,null,null,'N');
COMMIT;
/