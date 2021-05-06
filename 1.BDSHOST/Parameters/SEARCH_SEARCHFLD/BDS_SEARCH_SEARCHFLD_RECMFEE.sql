﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'RECMFEE';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('RECMFEE','Phí giảm trừ','Phí giảm trừ','SELECT RER.RERFID,RER.RERFTYPE,A1.CDCONTENT FEETYPE,RER.CALTYPE,
A2.CDCONTENT FEECALTYPE,RER.RERFRATE,RER. AFFECTDATE
FROM RERFEE RER,ALLCODE A1,ALLCODE A2
WHERE
RER.RERFTYPE=A1.CDVAL AND A1.CDTYPE=''RE'' AND A1.CDNAME=''RERFTYPE'' AND
RER.CALTYPE=A2.CDVAL AND A2.CDTYPE=''RE'' AND A2.CDNAME=''CALTYPE'' AND
RER.RERFOBJTYPE=''RE.RECFDEF''--La phi giam tru cho loai hinh
AND RER.REFOBJID=''<$KEYVAL>''','RE.RERFEE','frmRERFEE',null,null,0,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'RECMFEE';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'AFFECTDATE','Ngày hiệu lực','D','RECMFEE',100,null,'<,<=,=,>=,>','##/##/####','Y','Y','N',100,null,'Affect date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'RERFRATE','Tỉ lệ phí','N','RECMFEE',100,null,'<,<=,=,>=,>,<>','#,##0.##','Y','Y','N',100,null,'Percent','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'FEECALTYPE','Cách tính','C','RECMFEE',150,'CCCC','LIKE,=','_','Y','Y','N',150,null,'Cal type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'FEETYPE','Loại hình phí','C','RECMFEE',100,'CCCC','LIKE,=','_','Y','Y','N',100,null,'Fee Type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'RERFID','Mã phí giảm trừ','C','RECMFEE',100,'CCCC','LIKE,=','_','Y','Y','Y',100,null,'Reduce Fee Code','N',null,null,'N',null,null,null,'N');
COMMIT;
/