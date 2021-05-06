﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SEBK31';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SEBK31','VSD từ chối tái lưu ký','Reject deposit certificate request from depository center','SELECT MST.OBJNAME, MST.TXDATE, MST.OBJKEY,
MST.AFACCTNO, MST.BANKCODE, MST.BANKACCT, MST.STATUS, MST.TXAMT, RF.*
FROM CRBTXREQ MST, (SELECT *
FROM   (SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
        FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE MST.STATUS=''P'' AND MST.REQID=DTL.REQID AND MST.TRFCODE=''SEREJECTDEPOSIT'')
PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN
(''QTTY'' as QTTY, ''LICENSE'' as LICENSE,
''CUSTNAME'' as CUSTNAME, ''CUSTODYCD'' as CUSTODYCD, ''BOARD'' as BOARD, ''SYMBOL'' as SYMBOL))
ORDER BY REQID) RF
WHERE MST.REQID=RF.REQID','BANKINFO','SEREJECTDEPOSIT','TXDATE, OBJKEY','EXEC',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SEBK31';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'AFACCTNO','Số tiểu khoản','C','SEBK31',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Sub-account','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'BOARD_R','Nơi giao dịch','C','SEBK31',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Board','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'TXAMT','Tổng khối lượng','N','SEBK31',100,null,'>=,<=,>,<,=',null,'Y','Y','N',100,null,'Qtty','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'SYMBOL_R','Chứng khoán','C','SEBK31',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'LICENSE_R','Số CMT/hộ chiếu','C','SEBK31',150,null,'LIKE,=',null,'Y','Y','N',150,null,'License','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'CUSTNAME_R','Tên khách hàng','C','SEBK31',150,null,'LIKE,=',null,'Y','Y','N',150,null,'Fullname','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'CUSTODYCD_R','Số TK lưu ký','C','SEBK31',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Account','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'OBJKEY','Số chứng từ','C','SEBK31',100,null,'LIKE,=',null,'Y','Y','N',100,null,'TxNum','N','21',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'TXDATE','Ngày','D','SEBK31',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'REQID','Số hiệu yêu cầu','C','SEBK31',100,null,'LIKE,=',null,'N','Y','Y',100,null,'Request ID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
