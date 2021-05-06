﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'OD9991';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('OD9991','Quản lý trạng thái thị trường - FO','Market infomation management - FO','SELECT mk.exchange, mk.sessionex, a1.cdcontent description, 0 SequenceMsg FROM marketinfo@DBL_FO mk, allcode a1 WHERE A1.cdval = mk.sessionex AND A1.CDNAME = ''MARKETSTATUS'' AND A1.CDTYPE = ''FO''','OD9991','frmOD9991',null,'9991',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'OD9991';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'SEQUENCEMSG','SEQUENCEMSG','C','OD9991',200,null,'LIKE,=','_','N','N','N',230,null,'SEQUENCEMSG','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'DESCRIPTION','Phiên GD','C','OD9991',200,null,'LIKE,=','_','Y','Y','N',230,null,'Session','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'SESSIONEX','Phiên GD','C','OD9991',200,null,'LIKE,=','_','N','N','N',230,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''FO'' AND CDNAME = ''MARKETSTATUS'' ORDER BY LSTODR','Session','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'EXCHANGE','Sàn GD','C','OD9991',80,null,'LIKE,=','_','Y','Y','N',130,null,'Exchange','N','01',null,'N',null,null,null,'N');
COMMIT;
/
