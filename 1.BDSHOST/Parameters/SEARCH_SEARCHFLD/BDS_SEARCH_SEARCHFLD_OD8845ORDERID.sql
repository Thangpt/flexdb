--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'OD8845ORDERID';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('OD8845ORDERID','Danh sách các lệnh y/c sửa lỗi','8845 order list','SELECT ODFIX.AUTOID, ODFIX.ORGORDERID, ODFIX.AFACCTNO, ODFIX.LOANQTTY - ODFIX.PAIDQTTY LOANQTTY, ODFIX.DUEDATE NEWCLEARDATE, OD.CODEID, SEC.SYMBOL FROM ODFIXRQS ODFIX, VW_ODMAST_ALL OD, SBSECURITIES SEC WHERE SEC.CODEID = OD.CODEID AND OD.ORDERID = ODFIX.ORGORDERID AND ODFIX.DELTD = ''N'' AND LOANQTTY - PAIDQTTY <> 0','ODMAST',null,'ORGORDERID DESC',null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'OD8845ORDERID';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'CODEID','Mã code CK','C','OD8845ORDERID',50,null,'LIKE,=',null,'N','Y','N',100,null,'CodeID','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'NEWCLEARDATE','Ngày thanh toán','D','OD8845ORDERID',150,null,'=',null,'Y','Y','N',100,null,'New Clear date','N','12',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'LOANQTTY','Khối lượng trả','C','OD8845ORDERID',150,null,'LIKE,=',null,'Y','Y','N',100,null,'LOANQTTY','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'SYMBOL','Mã CK','C','OD8845ORDERID',50,null,'LIKE,=',null,'Y','Y','N',100,null,'SYMBOL','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'AFACCTNO','Số tiểu khoản P','C','OD8845ORDERID',130,null,'LIKE,=',null,'Y','Y','N',100,null,'AFACCTNO','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'ORGORDERID','Số hiệu lệnh sửa lỗi','C','OD8845ORDERID',170,null,'LIKE,=',null,'Y','Y','Y',100,null,'OrderId','N',null,null,'N',null,null,null,'N');
COMMIT;
/
