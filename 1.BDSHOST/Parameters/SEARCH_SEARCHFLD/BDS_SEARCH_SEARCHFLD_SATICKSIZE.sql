﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SATICKSIZE';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SATICKSIZE','Buoc gia','Tick size','SELECT MST.AUTOID, MST.TICKSIZE, MST.FROMPRICE, MST.TOPRICE FROM SECURITIES_TICKSIZE MST WHERE MST.STATUS=''Y'' AND MST.CODEID=''<$KEYVAL>'' ORDER BY FROMPRICE','SA.SECURITIES_TICKSIZE','frmSECURITIES_TICKSIZE',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SATICKSIZE';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'TOPRICE','Đến','N','SATICKSIZE',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',80,null,'To price','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'FROMPRICE','Từ','N','SATICKSIZE',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',80,null,'From price','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'TICKSIZE','Bước giá','N','SATICKSIZE',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',80,null,'Ticksize','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Mã quản lý','N','SATICKSIZE',100,null,'=,<>,<,<=,>=,>','#,##0','N','Y','Y',100,null,'Auto ID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
