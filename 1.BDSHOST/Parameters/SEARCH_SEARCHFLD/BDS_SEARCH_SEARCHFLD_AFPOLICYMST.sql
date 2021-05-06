﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'AFPOLICYMST';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('AFPOLICYMST','Quản lý chính sách đầu tư','Investment policy for sub-account','
SELECT MST.AUTOID, MST.FULLNAME, A0.CDCONTENT DESC_INVPOLICY, A1.CDCONTENT DESC_CHECKTYP, A2.CDCONTENT DESC_STATUS,
(CASE WHEN MST.STATUS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW
FROM AFPOLICYMST MST, ALLCODE A0, ALLCODE A1, ALLCODE A2
WHERE A0.CDTYPE=''CF'' AND A0.CDNAME=''INVPOLICY'' AND A0.CDVAL=MST.INVPOLICY
AND A1.CDTYPE=''CF'' AND A1.CDNAME=''CHECKTYP'' AND A1.CDVAL=MST.CHECKTYP
AND A2.CDTYPE=''FN'' AND A2.CDNAME=''STATUS'' AND A2.CDVAL=MST.STATUS','AFPOLICYMST','frmAFPOLICYMST',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'AFPOLICYMST';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (100,'APRALLOW','Cho phép duyệt?','C','AFPOLICYMST',100,null,'LIKE,=',null,'N','N','N',100,null,'Aprove Allow','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'DESC_STATUS','Trạng thái','C','AFPOLICYMST',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE,CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE=''SY'' AND CDNAME=''TYPESTS'' ORDER BY LSTODR ','Status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'DESC_CHECKTYP','Kiểm soát','C','AFPOLICYMST',100,null,'LIKE,=',null,'Y','Y','N',150,null,'Check type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'DESC_INVPOLICY','Loại','C','AFPOLICYMST',100,null,'LIKE,=',null,'Y','Y','N',150,null,'Type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'FULLNAME','Tên','C','AFPOLICYMST',100,null,'LIKE,=',null,'Y','Y','N',250,null,'Name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Mã quản lý','C','AFPOLICYMST',100,null,'LIKE,=','_','N','N','Y',100,null,'AutoID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
