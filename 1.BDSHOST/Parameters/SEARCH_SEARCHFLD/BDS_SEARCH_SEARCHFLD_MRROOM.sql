﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'MRROOM';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('MRROOM','Danh sách room margin hệ thống','System margin room list','
select vm.codeid, vm.roomlimit prlimit, sb.symbol, nvl(vp.prinused,0) prinused
from vw_marginroomsystem vm, sbsecurities sb, securities_risk rsk,
(select codeid, sum(prinused) prinused from vw_afpralloc_all where restype = ''M'' group by codeid) vp
where vm.codeid = sb.codeid
and vm.codeid = vp.codeid(+)
and vm.codeid = rsk.codeid(+)
and rsk.ismarginallow = ''Y''
','MRROOM','CODEID',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'MRROOM';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'PRINUSED','Đã sử dụng','N','MRROOM',20,null,'<,<=,=,>=,>,<>','#,##0','Y','N','N',150,null,'In used','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'PRLIMIT','Hạn mức','N','MRROOM',20,null,'<,<=,=,>=,>,<>','#,##0','Y','N','N',150,null,'Limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'SYMBOL','Mã','C','MRROOM',10,null,'=,LIKE',null,'Y','Y','N',100,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CODEID','Mã hiệu','C','MRROOM',50,null,'=,LIKE','_','Y','Y','Y',100,null,'Poom/Room code','N',null,null,'N',null,null,null,'N');
COMMIT;
/
