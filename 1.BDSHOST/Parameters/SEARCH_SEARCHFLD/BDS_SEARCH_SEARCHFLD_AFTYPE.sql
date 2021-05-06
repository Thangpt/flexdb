﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'AFTYPE';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('AFTYPE','Loại hình tiểu khoản giao dịch','Sub-account product type management','SELECT ACTYPE, TYPENAME, A0.CDCONTENT AFSTATUS, A1.CDCONTENT AFTYPE, TYP.DESCRIPTION, A02.CDCONTENT STATUS,
A03.CDCONTENT APPRV_STS,
(CASE WHEN APPRV_STS IN (''D'') THEN ''N'' ELSE ''Y'' END) EDITALLOW, (CASE WHEN APPRV_STS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW,
(CASE WHEN APPRV_STS IN (''D'') THEN ''N'' ELSE ''Y'' END) AS DELALLOW, DISADVFEEDAYS,TYP.PRODTYPE
FROM AFTYPE TYP, ALLCODE A0, ALLCODE A1, ALLCODE A02, ALLCODE A03
WHERE A0.CDTYPE = ''SY'' AND A0.CDNAME = ''TYPESTS'' AND A0.CDVAL=TYP.APPROVECD AND A1.CDTYPE = ''CF''
AND A02.CDVAL = TYP.STATUS AND A02.CDTYPE = ''SY'' AND A02.CDNAME = ''STATUS''
AND A03.CDVAL = TYP.APPRV_STS AND A03.CDTYPE = ''SY'' AND A03.CDNAME = ''APPRV_STS''
AND A1.CDNAME = ''AFTYPE'' AND A1.CDVAL=TYP.AFTYPE','AFTYPE','frmAFTYPE',null,null,0,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'AFTYPE';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (100,'DELALLOW','Cho phép xóa?','C','AFTYPE',100,null,'LIKE,=',null,'N','Y','N',100,null,'Delete Allow','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (100,'APRALLOW','Cho phép duyệt?','C','AFTYPE',100,null,'LIKE,=',null,'N','Y','N',100,null,'Aprove Allow','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (100,'EDITALLOW','Cho phép sửa?','C','AFTYPE',100,null,'LIKE,=',null,'N','Y','N',100,null,'Edit Allow','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'STATUS','Trạng thái','C','AFTYPE',100,null,'=',null,'Y','N','N',200,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''STATUS'' ORDER BY LSTODR','Status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'APPRV_STS','Trạng thái duyệt','C','AFTYPE',100,null,'=',null,'Y','Y','N',200,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''APPRV_STS'' ORDER BY LSTODR','Apprv Status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'DESCRIPTION','Diễn giải','C','AFTYPE',100,null,'LIKE,=',null,'Y','Y','N',200,null,'Description','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'AFTYPE','Phân loại','C','AFTYPE',100,null,'=',null,'N','N','N',200,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''AFTYPE'' ORDER BY LSTODR','Categories','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'AFSTATUS','Ðang sử dụng','C','AFTYPE',100,null,'=',null,'Y','N','N',200,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''TYPESTS'' ORDER BY LSTODR','Status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1.1,'PRODTYPE','Loại sản phẩm','C','AFTYPE',100,null,'LIKE,=',null,'Y','Y','N',150,null,'Product type','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'TYPENAME','Tên loại hình','C','AFTYPE',100,null,'LIKE,=',null,'Y','Y','N',150,null,'Product name','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'ACTYPE','Mã loại hình','C','AFTYPE',100,'9999','LIKE,=','_','Y','Y','Y',100,null,'Product type','N',null,null,'N',null,null,null,'N');
COMMIT;
/