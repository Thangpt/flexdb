﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'OD8844';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('OD8844','Danh sách các lệnh xóa y/c sửa lỗi','8844 order list','SELECT ODFIX.MATCHVALUE, ODFIX.AFACCTNO || OD.CODEID SEAFACCTNO, ODFIX.LOANFACCTNO || OD.CODEID LOANSEAFACCTNO, DECODE(SUBSTR(OD.EXECTYPE, 2,1), ''B'', ''1'', ''0'') BUYORDER, DECODE(SUBSTR(OD.EXECTYPE, 2,1), ''S'', ''1'', ''0'') SELLORDER, ODFIX.LOANQTTY, ODFIX.DESCRIPTION, OD.TXDATE TXDATE, AUTOID, ORGORDERID, ODFIX.AFACCTNO, FIXQTTY, DUEDATE NEWCLEARDATE, CF.CUSTODYCD FROM ODFIXRQS ODFIX, AFMAST AF, CFMAST CF, ODMAST OD WHERE AF.CUSTID = CF.CUSTID AND ODFIX.ORGORDERID = OD.ORDERID AND OD.AFACCTNO = AF.ACCTNO AND ODFIX.STATUS <> ''A'' and ODFIX.DELTD = ''N'' AND FIXORDERID IS NULL','ODMAST',null,'ORGORDERID DESC','8844',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'OD8844';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'MATCHVALUE','Gía trị khớp','N','OD8844',100,null,'<,<=,=,>=,>,<>',null,'Y','N','N',100,null,'MATCHVALUE','N','16',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'LOANSEAFACCTNO','Số tiểu khoản vay sửa lỗi','C','OD8844',100,null,'LIKE,=',null,'Y','Y','N',100,null,'LOANSEAFACCTNO','N','15',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'SELLORDER','Sửa lệnh bán','C','OD8844',100,null,'LIKE,=',null,'N','Y','N',100,null,'SELLORDER','N','14',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'BUYORDER','Sửa lệnh mua','C','OD8844',100,null,'LIKE,=',null,'N','Y','N',100,null,'BUYORDER','N','13',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'SEAFACCTNO','Số tiểu khoản ck','C','OD8844',100,null,'LIKE,=',null,'Y','Y','N',100,null,'SEAFACCTNO','N','12',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'LOANQTTY','LOANQTTY','N','OD8844',100,null,'<,<=,=,>=,>,<>',null,'Y','N','N',100,null,'LOANQTTY','N','11',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'AUTOID','Số tt','C','OD8844',150,null,'LIKE,=',null,'Y','Y','N',100,null,'AUTOID','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'NEWCLEARDATE','Ngày thanh toán','D','OD8844',150,null,'=',null,'Y','Y','N',100,null,'New Clear date','N','09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'TXDATE','Ngày gd','D','OD8844',150,null,'=',null,'Y','Y','N',100,null,'New Clear date','N','08',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'FIXQTTY','Khối lượng khớp','C','OD8844',150,null,'LIKE,=',null,'Y','Y','N',100,null,'FIXQTTY','N','05',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'AFACCTNO','Số tiểu khoản','C','OD8844',130,null,'LIKE,=',null,'Y','Y','N',100,null,'AFACCTNO','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CUSTODYCD','Số lưu ký','C','OD8844',130,null,'LIKE,=',null,'Y','Y','N',100,null,'AFACCTNO','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'ORGORDERID','Số hiệu lệnh sửa lỗi','C','OD8844',170,null,'LIKE,=',null,'Y','Y','Y',100,null,'OrderId','N','01',null,'N',null,null,null,'N');
COMMIT;
/