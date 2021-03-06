--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'OD8840';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('OD8840','Danh sách các lệnh xóa TTBT','8840 order list','SELECT nvl (adv.depoamt,0) AVLADVAMT, DECODE(EXECTYPE, ''MS'', 1, 0) ISMORTGAGESELL, DECODE(SUBSTR(EXECTYPE, 2,1), ''B'', 1, 0)*DECODE(OD.STSSTATUS, ''C'',1, 0) BUYORDER, DECODE(SUBSTR(EXECTYPE, 2,1), ''S'', 1, 0)*DECODE(OD.STSSTATUS, ''C'',1, 0) SELLORDER,OD.CODEID, OD.AFACCTNO || OD.CODEID SEACCTNO, OD.ORDERID, OD.TXDATE, CUSTODYCD, OD.AFACCTNO, CLEARDATE, ORDERQTTY, EXECQTTY MATCHQTTY, MATCHAMT MATCHVALUE FROM ODMAST OD, STSCHD STS, CFMAST CF, AFMAST AF, vw_getavladvance_by_order adv WHERE OD.ORDERID = ADV.ORDERID(+) AND OD.ORDERID = STS.ORGORDERID AND STS.DUETYPE IN (''RM'',''RS'') AND CF.CUSTID = AF.CUSTID AND AF.ACCTNO = OD.AFACCTNO AND STS.DELTD = ''N''','ODMAST',null,'ORDERID DESC','8840',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'OD8840';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'AVLADVAMT','Số tiền có thể ƯT','C','OD8840',100,null,'LIKE,=',null,'N','Y','N',100,null,'ADVAMT','N','15',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'ISMORTGAGESELL','Bán cấm cố','C','OD8840',100,null,'LIKE,=',null,'N','Y','N',100,null,'ISMORTGAGESELL','N','14',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'SELLORDER','Sửa lệnh bán','C','OD8840',100,null,'LIKE,=',null,'N','Y','N',100,null,'SELLORDER','N','13',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'BUYORDER','Sửa lệnh mua','C','OD8840',100,null,'LIKE,=',null,'N','Y','N',100,null,'BUYORDER','N','12',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'SEACCTNO','Số tiểu khoản','C','OD8840',100,null,'LIKE,=',null,'N','Y','N',100,null,'SEAcctno','N','11',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'CODEID','Mã CK','C','OD8840',100,null,'LIKE,=',null,'N','Y','N',100,null,'CodeId','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'MATCHVALUE','Giá trị khớp','N','OD8840',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Match value','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'MATCHQTTY','Khối lượng khớp','N','OD8840',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Match quantity','N','05',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'ORDERQTTY','Khối lượng đặt','N','OD8840',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Order quantity','N','06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'CLEARDATE','Ngày thanh toán','D','OD8840',100,null,'=',null,'Y','Y','N',100,null,'Clear date','N','09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'AFACCTNO','Số tiểu khoản','C','OD8840',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Afacctno','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'CUSTODYCD','Số lưu ký','C','OD8840',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Custody code','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'TXDATE','Ngày giao dịch','D','OD8840',100,null,'=',null,'Y','Y','N',100,null,'Txdate','N','08',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'ORDERID','Số hiệu lệnh','C','OD8840',100,null,'LIKE,=',null,'Y','Y','Y',100,null,'OrderId','N','01',null,'N',null,null,null,'N');
COMMIT;
/
