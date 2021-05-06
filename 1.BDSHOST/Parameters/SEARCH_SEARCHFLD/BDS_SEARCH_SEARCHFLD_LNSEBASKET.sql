﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'LNSEBASKET';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('LNSEBASKET','Loại hình ký quỹ','InUsed credit line product','SELECT TYP.AUTOID, TYP.ACTYPE, MST.TYPENAME, TYP.EFFDATE, TYP.EXPDATE FROM LNSEBASKET TYP, LNTYPE MST WHERE TYP.ACTYPE=MST.ACTYPE AND TYP.BASKETID=''<$KEYVAL>'' ORDER BY TYP.ACTYPE','SA.LNSEBASKET','frmLNSEBASKET',null,null,0,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'LNSEBASKET';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'EFFDATE','Ngày hiệu lực','D','LNSEBASKET',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Effective date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'TYPENAME','Tên loại hình','C','LNSEBASKET',100,null,'LIKE,=',null,'Y','Y','N',200,null,'Name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'ACTYPE','Mã loại hình','C','LNSEBASKET',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Mã quản lý','N','LNSEBASKET',20,null,'=,<>,<,<=,>=,>','#,##0','Y','Y','Y',80,null,'Auto ID','N',null,null,'N',null,null,null,'N');
COMMIT;
/