﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'T0INTLNSCHD';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('T0INTLNSCHD','Lich tra lai vay margin','Margin interest payment schedule','SELECT DISTINCT MST.AUTOID, MST.DUENO, MST.DUEDATE, MST.ACCTNO, A0.CDCONTENT REFTYPE, A1.CDCONTENT DUESTS, MST.NML, MST.OVD, MST.PAID
FROM (SELECT * FROM LNSCHD WHERE ACCTNO=''<$KEYVAL>'' UNION ALL SELECT * FROM LNSCHDHIST WHERE ACCTNO=''<$KEYVAL>'') MST, ALLCODE A0, ALLCODE A1 WHERE A0.CDTYPE = ''LN'' AND A0.CDNAME = ''REFTYPE'' AND A0.CDVAL=MST.REFTYPE and A1.CDTYPE = ''LN'' AND A1.CDNAME = ''DUESTS'' AND A1.CDVAL=MST.DUESTS AND MST.ACCTNO=''<$KEYVAL>'' AND MST.REFTYPE = ''GI'' ORDER BY MST.DUEDATE','LN.LNSCHD','frmLNSCHD',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'T0INTLNSCHD';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'DUESTS','Trang thai','C','T0INTLNSCHD',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''LN'' AND CDNAME = ''DUESTS'' ORDER BY LSTODR','Status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'DUEDATE','Ngay den han','C','T0INTLNSCHD',100,'99/99/9999','LIKE,=','_','Y','Y','N',100,null,'Due date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'PAID','So da tra','N','T0INTLNSCHD',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',80,null,'Paid amount','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'OVD','Du no qua han','N','T0INTLNSCHD',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',80,null,'Overdue principal','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'NML','Du no trong han','N','T0INTLNSCHD',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',80,null,'Normal principal','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'REFTYPE','Loai lich','C','T0INTLNSCHD',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE=''LN'' AND CDNAME=''REFTYPE'' ORDER BY LSTODR ','Ref. type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'DUENO','So hieu lich','C','T0INTLNSCHD',100,'cccccc','LIKE,=','_','N','N','N',100,null,'Internal code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Ma quan ly','C','T0INTLNSCHD',100,'cccccccccc','LIKE,=','_','N','Y','Y',80,null,'AutoID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
