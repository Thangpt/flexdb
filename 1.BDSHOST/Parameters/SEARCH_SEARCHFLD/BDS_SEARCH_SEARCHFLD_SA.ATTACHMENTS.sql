﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SA.ATTACHMENTS';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SA.ATTACHMENTS','Thông tin các báo cáo gửi kèm Email','Email attachments','SELECT A.AUTOID, A.ATTACHMENT_ID, R.RPTID REPORT_ID, R.DESCRIPTION FROM ATTACHMENTS A, RPTMASTER R WHERE A.REPORT_ID = R.RPTID AND A.ATTACHMENT_ID = ''<$KEYVAL>''','SA.ATTACHMENTS',null,null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SA.ATTACHMENTS';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'DESCRIPTION','Tên báo cáo','C','SA.ATTACHMENTS',10,'ccccc','LIKE,=','_','Y','Y','N',400,null,'Report name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'REPORT_ID','Mã báo cáo','C','SA.ATTACHMENTS',10,'ccccc','LIKE,=','_','Y','Y','N',100,null,'Report Id','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'ATTACHMENT_ID','Tên file mẫu','C','SA.ATTACHMENTS',10,'ccccc','LIKE,=','_','Y','Y','N',100,null,'Attachment Id','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'AUTOID','Mã mẫu','C','SA.ATTACHMENTS',10,'cccc','LIKE,=','_','Y','Y','Y',0,null,'Auto Id','N',null,null,'N',null,null,null,'N');
COMMIT;
/