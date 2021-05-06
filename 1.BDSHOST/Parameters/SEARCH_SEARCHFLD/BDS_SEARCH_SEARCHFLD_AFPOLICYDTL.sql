﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'AFPOLICYDTL';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('AFPOLICYDTL','Chi tiết chính sách đầu tư','Detail of investment policy for sub-account','SELECT MST.AUTOID, MST.MAXRATIO, MST.MAXVALUE, A0.CDCONTENT DESC_ATYPE,
A1.CDCONTENT DESC_TRADEPLACE, A2.CDCONTENT DESC_ECONOMIC, SBSYM.SYMBOL, SBCCY.SHORTCD
FROM AFPOLICYDTL MST, ALLCODE A0, ALLCODE A1, ALLCODE A2, SBSECURITIES SBSYM, SBCURRENCY SBCCY
WHERE A0.CDTYPE=''CF'' AND A0.CDNAME=''ATYPE'' AND A0.CDVAL=MST.ATYPE
AND A1.CDTYPE=''SA'' AND A1.CDNAME=''TRADEPLACE'' AND A1.CDVAL=MST.TRADEPLACE
AND A2.CDTYPE=''SA'' AND A2.CDNAME=''ECONOMIC'' AND A2.CDVAL=MST.SECTOR
AND MST.CODEID=SBSYM.CODEID AND MST.CCYCD=SBCCY.CCYCD AND MST.MSTID=''<$KEYVAL>''','CF.AFPOLICYDTL','frmAFPOLICYDTL',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'AFPOLICYDTL';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'SHORTCD','Loại tiền','C','AFPOLICYDTL',100,null,'>,<,=',null,'Y','Y','N',80,null,'Currency','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'SYMBOL','Chứng khoán','C','AFPOLICYDTL',100,null,'>,<,=',null,'Y','Y','N',80,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'DESC_ECONOMIC','Nghành nghề','C','AFPOLICYDTL',100,null,'>,<,=',null,'Y','Y','N',150,null,'Economic','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'DESC_TRADEPLACE','Nơi giao dịch','C','AFPOLICYDTL',100,null,'>,<,=',null,'Y','Y','N',80,null,'Exchange','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'MAXVALUE','Giá trị tối đa','N','AFPOLICYDTL',100,null,'<,>,=','#,##0','Y','Y','N',100,null,'Maximum value','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'MAXRATIO','Tỷ lệ tối đa','N','AFPOLICYDTL',100,null,'<,>,=','#,##0.#0','Y','Y','N',100,null,'Maximum ratio','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'DESC_ATYPE','Loại','C','AFPOLICYDTL',100,null,'>,<,=',null,'Y','Y','N',80,null,'Type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Mã quản lý','C','AFPOLICYDTL',100,null,'LIKE,=','_','Y','Y','Y',80,null,'AutoID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
