﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'ICCFTIERSCHD';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('ICCFTIERSCHD','Tham số bậc thang','Tier definition','
SELECT DTL.AUTOID, DTL.MODCODE, DTL.EVENTCODE, DTL.ACTYPE, DTL.FRAMT, DTL.TOAMT, DTL.DELTA,
APPEVENTS.EVENTNAME FROM ICCFTYPESCHD TYP, ICCFTIER DTL, APPEVENTS
WHERE TYP.EVENTCODE=DTL.EVENTCODE AND TYP.MODCODE=DTL.MODCODE
AND TYP.ACTYPE=DTL.ACTYPE
AND APPEVENTS.EVENTCODE=TYP.EVENTCODE AND TYP.AUTOID=''<$KEYVAL>''
ORDER BY DTL.MODCODE, DTL.EVENTCODE','SA.ICCFTIER','frmICCFTIER',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'ICCFTIERSCHD';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'DELTA','Biên độ','N','ICCFTIERSCHD',100,null,'=,<=,>=,>,<','#,##0.###0','Y','Y','N',100,null,'Delta','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'TOAMT','Đến','N','ICCFTIERSCHD',100,null,'=,<=,>=,>,<','#,##0','Y','Y','N',100,null,'To value','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'FRAMT','Từ','N','ICCFTIERSCHD',100,null,'=,<=,>=,>,<','#,##0','Y','Y','N',100,null,'From value','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'EVENTNAME','Tên sự kiện','C','ICCFTIERSCHD',100,null,'LIKE,=',null,'Y','Y','N',200,null,'Event name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'EVENTCODE','Mã sự kiện','C','ICCFTIERSCHD',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Event code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Mã quản lý','N','ICCFTIERSCHD',20,null,'=,<>,<,<=,>=,>','#,##0','N','Y','Y',100,null,'Auto ID','N',null,null,'N',null,null,null,'N');
COMMIT;
/