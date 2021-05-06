﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'TD0002';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('TD0002','Trang thai so du gui ho tro lai suat','Trang thai so du gui ho tro lai suat','SELECT mst.actype, A3.CDCONTENT DESC_SCHDTYPE, MST.ACCTNO, MST.AFACCTNO, CF.FULLNAME,
    MST.ORGAMT, MST.FRDATE,(SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = ''000''
                                AND SBDATE >= MST.TODATE AND HOLIDAY = ''N'') TODATE,
    MST.BALANCE, MST.INTPAID,
    FN_TDMASTINTRATIO(MST.ACCTNO,TO_DATE(SYSVAR.VARVALUE,''DD/MM/YYYY''),MST.BALANCE) INTAVLAMT,
    MST.INTPAID+
    FN_TDMASTINTRATIO(MST.ACCTNO,TO_DATE(SYSVAR.VARVALUE,''DD/MM/YYYY''),MST.BALANCE) total_INT,
    MST.MORTGAGE
FROM TDMAST MST, AFMAST AF, CFMAST CF, ALLCODE A3, SYSVAR
WHERE MST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND MST.STATUS in (''N'',''A'')
AND A3.CDTYPE=''TD'' AND A3.CDNAME=''SCHDTYPE'' AND MST.SCHDTYPE=A3.CDVAL
AND SYSVAR.VARNAME= ''CURRDATE''
AND MST.BALANCE > 0
AND CF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>'')
','TDMAST','frmTDMAST',null,null,0,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'TD0002';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'MORTGAGE','Gia tri bao dam','N','TD0002',80,null,'<,<=,=,>=,>,<>','#,##0.###','Y','Y','N',100,null,'Mortgage','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'TOTAL_INT','Tong lai','N','TD0002',70,null,'<,<=,=,>=,>,<>','#,##0.###','Y','Y','N',100,null,'Total interest','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'INTAVLAMT','Lai chua nhan','N','TD0002',70,null,'<,<=,=,>=,>,<>','#,##0.###','Y','Y','N',100,null,'Interest not received','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'INTPAID','Lai da nhan','N','TD0002',70,null,'<,<=,=,>=,>,<>','#,##0.###','Y','Y','N',100,null,'Interest received','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'BALANCE','So du hien tai','N','TD0002',80,null,'<,<=,=,>=,>,<>','#,##0.###','Y','Y','N',100,null,'Current balance','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'TODATE','Den han','D','TD0002',80,null,'<,<=,=,>=,>,<>','##/##/####','Y','Y','N',100,null,'To date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'FRDATE','Tu ngay','D','TD0002',80,null,'<,<=,=,>=,>,<>','##/##/####','Y','Y','N',100,null,'From date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'ORGAMT','So du ban dau','N','TD0002',80,null,'<,<=,=,>=,>,<>','#,##0.###','Y','Y','N',100,null,'Initial balance','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'FULLNAME','Ten khach hang','C','TD0002',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Customer name','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'AFACCTNO','So tieu khoan','C','TD0002',80,null,'LIKE,=',null,'Y','Y','N',100,null,'Sub account','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'ACCTNO','So tieu khoan tiet kiem','C','TD0002',120,null,'LIKE,=',null,'Y','Y','Y',100,null,'Term deposit sub-account','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'DESC_SCHDTYPE','Loai la','C','TD0002',80,null,'LIKE,=',null,'Y','Y','N',100,null,'Interest schema','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'ACTYPE','loai hinh','C','TD0002',100,null,'=,LIKE',null,'Y','Y','N',100,null,'TD type','N',null,null,'N',null,null,null,'N');
COMMIT;
/