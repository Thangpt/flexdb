--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CA3393';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CA3393','Hủy dang ký mua CP phát hành thêm(không phong tỏa tiền)','Hủy đăng ký mua CP phát hành thêm(không phong tỏa tiền)','SELECT   SUBSTR(CAMAST.CAMASTID,1,4) || ''.'' ||
SUBSTR(CAMAST.CAMASTID,5,6) || ''.'' ||
SUBSTR(CAMAST.CAMASTID,11,6) CAMASTID,
 CA.AFACCTNO, CAMAST.CODEID,CF.CUSTODYCD , A2.CDCONTENT
CATYPE, CA.PBALANCE ,  CA.BALANCE, CA.nmqtty  QTTY,
CA.nmqtty  MAXQTTY ,CA.aamt aamt , ( CASE WHEN CI.COREBANK
=''Y'' THEN 0 ELSE 1 END) ISCOREBANK, ( CASE WHEN
CI.COREBANK =''Yes'' THEN ''Y'' ELSE ''No'' END) COREBANK,
 SYM.SYMBOL, A1.CDCONTENT STATUS,CA.AFACCTNO||CA.CODEID
 SEACCTNO, CA.AFACCTNO||CAMAST.OPTCODEID
OPTSEACCTNO,SYM.PARVALUE PARVALUE,  CAMAST.REPORTDATE
REPORTDATE, CAMAST.ACTIONDATE,CAMAST.EXPRICE,
(CASE WHEN SUBSTR(CF.custodycd,4,1) = ''F'' THEN to_char(
''Secondary-offer shares, ''||SYM.SYMBOL ||'', exdate on ''
|| to_char (camast.reportdate,''DD/MM/YYYY'')||'',
ratio '' ||camast.RIGHTOFFRATE ||'', quantity '' ||ca.pqtty
||'', price ''|| CAMAST.EXPRICE ||'', '' || cf.fullname)
else to_char( ''Ðang ký quyền mua, ''||SYM.SYMBOL ||'',
ngày ch?t '' ||
 to_char (camast.reportdate,''DD/MM/YYYY'')||'', tỉ lệ ''
||camast.RIGHTOFFRATE ||'', SL '' ||ca.pqtty ||'', giá ''||
CAMAST.EXPRICE ||'', '' || cf.fullname ) end )
description,  ISS.fullname FROM  SBSECURITIES SYM,
ALLCODE A1,
 CAMAST, CASCHD  CA, AFMAST AF , CFMAST CF , CIMAST CI,
ISSUERS ISS, ALLCODE A2 WHERE AF.ACCTNO = CI.ACCTNO AND
A1.CDTYPE = ''CA'' AND A1.CDNAME = ''CASTATUS'' AND A1.CDVAL
= CA.STATUS AND CAMAST.CODEID = SYM.CODEID AND
CAMAST.catype=''014''
AND CAMAST.camastid  = CA.camastid AND CA.AFACCTNO =
AF.ACCTNO AND ISS.issuerid = sym.issuerid
AND CAMAST.CATYPE = A2.CDVAL AND A2.CDTYPE = ''CA'' AND
A2.CDNAME = ''CATYPE''
AND AF.CUSTID = CF.CUSTID AND CA.status IN( ''M'',''A'',''S'')
AND CA.status <>''Y'' AND CA.balance > 0 AND nvl(ca.nmqtty,0)> 0  AND AF.ACCTNO
LIKE ''%<$AFACCTNO>%''','CAMAST',null,null,'3393',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CA3393';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (26,'CUSTODYCD','Số lưu ký ','C','CA3393',100,null,'LIKE,=',null,'Y','Y','N',100,null,'CUSTODYCD','N','96',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (18,'REPORTDATE','Ngày đăng ký cuối cùng','C','CA3393',80,null,'=,>,<,>=,<=',null,'N','N','N',80,null,'Ngày đăng ký cuối cùng','N','23',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (17,'FULLNAME','Tên chứng khoán','C','CA3393',100,null,null,null,'N','N','N',80,null,'Tên chứng khoán','N','08',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'OPTSEACCTNO','Số tiểu khoản CK phát sinh','C','CA3393',100,null,'LIKE,=','_','Y','Y','N',100,null,'Opt SE account number','N','09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'DESCRIPTION','Diễn giải','C','CA3393',100,null,'=','_','Y','Y','N',100,null,'DESCRIPTION','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'ISCOREBANK','Kết nối Corebank ?','N','CA3393',100,null,'<,<=,=,>=,>','#,##0','N','N','N',100,null,'ISCOREBANK','N','60',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'EXPRICE','Giá','N','CA3393',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'EXPRICE','N','05',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'PARVALUE','Mệnh giá','N','CA3393',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'Par value','N','22',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'AAMT','Số tiền đã đăng ký mua','N','CA3393',150,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'AAMT','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'QTTY','Số CK đã đăng ký mua','N','CA3393',150,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'Quantity','N','21',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'MAXQTTY','Số lượng','N','CA3393',100,null,'<,<=,=,>=,>','#,##0','N','N','N',100,null,'Quantity','N','20',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'BALANCE','Số lượng QM đã đăng ký','N','CA3393',150,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'Balance','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'PBALANCE','Số lượng QM còn lại','N','CA3393',150,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'Balance','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'SEACCTNO','Số tiểu khoản CK','C','CA3393',100,null,'LIKE,=','_','Y','Y','N',100,null,'SE account number','N','06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'STATUS','Trạng thái','C','CA3393',100,null,'LIKE,=',null,'Y','N','N',80,null,'Status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'COREBANK','Kết nối Corebank ?','C','CA3393',100,null,'=',null,'N','N','N',80,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''YESNO'' ORDER BY LSTODR','Is core bank ?','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'CATYPE','Loại TH quyền','C','CA3393',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''CA''
AND CDNAME = ''CATYPE'' AND CDUSER=''Y''  ORDER BY LSTODR','Coporate type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'SYMBOL','Chứng khoán','C','CA3393',100,null,'LIKE,=',null,'Y','Y','N',80,null,'Symbol','N','04',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'AFACCTNO','Mã Tiểu khoản','C','CA3393',100,null,'=','_','Y','Y','N',100,null,'Contrac No','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CAMASTID','Mã TH quyền','C','CA3393',100,'cccc.cccccc.cccccc','LIKE,=','_','Y','Y','N',120,null,'CA code','N','02',null,'N',null,null,null,'N');
COMMIT;
/
