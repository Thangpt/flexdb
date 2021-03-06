--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SE2266';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SE2266','Xác nhận chuyển khoản chứng khoán ra ngoài(Giao dịch 2266)','View sending account to outward transfer (wait for 2266)','SELECT SEO.*, CF.FULLNAME,CF.CUSTODYCD,AF.ACCTNO AFACCTNO,
  SEC.SYMBOL, SE.COSTPRICE,(AF.ACCTNO||NVL(SEC.REFCODEID,SEC.CODEID)) ACCTNO_UPDATECOST
  FROM SESENDOUT SEO, CFMAST CF, AFMAST AF, SBSECURITIES SEC,SEMAST SE
  WHERE SUBSTR(SEO.ACCTNO,0,10)=AF.ACCTNO
  AND AF.CUSTID=CF.CUSTID
  AND SEC.CODEID=SEO.CODEID
  AND SE.ACCTNO=SEO.ACCTNO
  and seo.strade+seo.sblocked+seo.scaqtty+seo.srightoffqtty + seo.scaqttyreceiv + seo.scaqttydb + seo.scaamtreceiv + seo.srightqtty > 0
  and deltd=''N''','SEMAST','frmSEMAST',null,'2266',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SE2266';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (22,'RECUSTNAME','Tên khách hàng nhận CK','C','SE2266',10,null,'LIKE,=','_','Y','Y','N',100,null,'Received fullname','N','24',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (21,'RECUSTODYCD','Số LK nhận CK','C','SE2266',10,'ccc.c.cccccc','LIKE,=','_','Y','Y','N',100,null,'Received custody code','N','23',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (20,'SRIGHTQTTY','Quyền biểu quyết','N','SE2266',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'Right Qtty','N','19',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (19,'SCAAMTRECEIV','Tiền CA','N','SE2266',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'CA Amount','N','17',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (18,'SCAQTTYDB','CK CA chờ giảm','N','SE2266',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'Debit CA Quantity','N','22',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (17,'SCAQTTYRECEIV','CK CA chờ về','N','SE2266',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'Receiving CA Quantity','N','21',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'SRIGHTOFFQTTY','Quyền mua','N','SE2266',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'Right Quantity','N','20',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'SCAQTTY','Số CK quyền','N','SE2266',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'CA quantity','N','13',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'SBLOCKED','Số CK phong tỏa','N','SE2266',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Blocked','N','06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'STRADE','Số CK giao dịch','N','SE2266',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Trading','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'COSTPRICE','Giá vốn','N','SE2266',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'Cost price','N','09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'PRICE','Giá chuyển','N','SE2266',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'Price','N','16',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'CODEID','Chứng khoán','C','SE2266',100,'cccccc','LIKE,=','_','N','N','N',100,null,'Symbol','N','01',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'SYMBOL','Chứng khoán','C','SE2266',100,'ccccccccccccccc','LIKE,=','_','Y','Y','N',100,null,'Symbol','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'ACCTNO_UPDATECOST','Số TK update costprice','C','SE2266',100,'cccc.cccccc.cccccc','LIKE,=','_','N','N','N',120,null,'Account No','N','15',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'FULLNAME','Tên khách hàng','C','SE2266',10,null,'LIKE,=','_','Y','Y','N',100,null,'Fullname','N','90',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'ACCTNO','Số chi tiết TK','C','SE2266',100,'cccc.cccccc.cccccc','LIKE,=','_','Y','Y','Y',120,null,'Account No','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'AFACCTNO','Mã Tiểu khoản','C','SE2266',100,null,'LIKE,=','_','Y','Y','N',100,null,'Contract No','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-10,'CUSTODYCD','Số tài khoản lưu ký','C','SE2266',10,'ccc.c.cccccc','LIKE,=','_','Y','Y','N',100,null,'Custody code','N','05',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-11,'VSDMESSAGETYPE','Loại điện gửi lên VSD','C','SE2266',25,null,'LIKE,=',null,'N','N','N',100,null,'Vsd message type','N','97',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-12,'AUTOID','AUTOID','N','SE2266',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'AUTOID','N','18',null,'N',null,null,null,'N');
COMMIT;
/
