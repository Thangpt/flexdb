--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'LN0002';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('LN0002','Tra cứu thông tin vay tài khoản (MR+BL)','View loan accounts (AF loan type)','select cf.custodycd,af.acctno afacctno,cf.fullname,lns.autoid,lns.rlsdate,
case when ln.rrtype = ''B'' then ln.custbank when ln.rrtype = ''C'' then ''BVSC'' else null end rrtype,
ln.actype lntype,ln.acctno lnacctno, c1.cdcontent chksysctrl,
case when lns.reftype = ''P'' then ''Margin'' when lns.reftype = ''GP'' then ''Bao lanh'' else null end reftype,
ROUND(nml)+ROUND(ovd)+ROUND(paid) rlsamt,lns.intnmlacrbank,
ROUND(lns.paid) paid,ROUND(lns.nml)+ROUND(lns.ovd) prin,ROUND(lns.intnmlacr)+ROUND(lns.intdue)+ROUND(lns.intovd)+ROUND(lns.intovdprin) intprin,
ROUND(lns.ovd) ovd,ROUND(lns.intovd)+ROUND(lns.intovdprin) intovd,
lns.overduedate, greatest(to_number(to_date(sy_Date.varvalue,''DD/MM/RRRR'') - lns.overduedate),0) ovddays,   lns.overduedate - lns.rlsdate period
from lnschd lns, lnmast ln, afmast af, cfmast cf, lntype lnt, sysvar sy_Date, allcode c1
where lns.acctno = ln.acctno
and ln.trfacctno = af.acctno
and af.custid = cf.custid
and ln.actype = lnt.actype
and lns.reftype in (''P'',''GP'')
and ln.ftype = ''AF''
and c1.cdname = ''YESNO'' and c1.cdtype = ''SY'' and c1.cdval = lnt.chksysctrl
and sy_Date.varname = ''CURRDATE'' and sy_Date.grname = ''SYSTEM''','LNMAST',null,'PRIN ASC',null,null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'LN0002';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (19,'INTNMLACRBANK','Lãi Cty trả hộ','N','LN0002',20,null,'=,<,<=,>=,>','#,##0','Y','Y','N',120,null,'INTNMLACRBANK','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (18,'PERIOD','Kỳ hạn món vay','N','LN0002',100,null,'<,<=,=,>=,>,<>','#,##0.0000','Y','Y','N',80,null,'Fee. rate 3','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (17,'OVDDAYS','Số ngày quá hạn','N','LN0002',100,null,'<,<=,=,>=,>,<>','#,##0.0000','Y','Y','N',80,null,'Fee. rate 2','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'OVERDUEDATE','Ngày đến hạn','D','LN0002',100,null,'<,<=,=,>=,>,<>','#,##0.0000','Y','Y','N',80,null,'Fee. rate 1','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'INTOVD','Lãi quá hạn','N','LN0002',20,null,'=,<,<=,>=,>','#,##0','Y','N','N',120,null,'Overdue interest','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'OVD','Gốc quá hạn','N','LN0002',20,null,'=,<,<=,>=,>','#,##0','Y','N','N',120,null,'Overdue principal','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'INTPRIN','Lãi còn dư','N','LN0002',20,null,'=,<,<=,>=,>','#,##0','Y','N','N',120,null,'Due principal','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'PRIN','Gốc còn dư','N','LN0002',20,null,'=,<,<=,>=,>','#,##0','Y','N','N',120,null,'Due principal','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'PAID','Gốc đã thu hồi','N','LN0002',20,null,'=,<,<=,>=,>','#,##0','Y','N','N',120,null,'Paid principal','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'RLSAMT','Giá trị giải ngân','N','LN0002',20,null,'=,<,<=,>=,>','#,##0','Y','N','N',120,null,'Overdue principal','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'REFTYPE','Tính chất vay','C','LN0002',10,'CCCC','LIKE,=','_','Y','Y','N',100,'select * from (SELECT ''BL'' VALUE, ''Bao lanh'' DISPLAY FROM dual union all SELECT ''MR'' VALUE, ''Margin'' DISPLAY FROM dual) ORDER BY VALUE','Product type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'CHKSYSCTRL','Tuân thủ loại hình','C','LN0002',10,'CCCC','LIKE,=','_','Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''YESNO'' ORDER BY LSTODR','Product type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'LNTYPE','Loại hình vay','C','LN0002',10,'CCCC','LIKE,=','_','Y','Y','N',100,null,'Product type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'RRTYPE','Nguồn giải ngân','C','LN0002',100,null,'LIKE,=','_','N','N','N',100,null,'Category','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'RLSDATE','Ngày giải ngân','D','LN0002',10,null,'=,<,<=,>=,>','__/__/____','Y','Y','N',120,null,'Released date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'AUTOID','Số hiệu giải ngân','N','LN0002',20,null,'=,<,<=,>=,>','#,##0','N','N','Y',120,null,'Auto ID','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'LNACCTNO','Số tài khoản vay','C','LN0002',16,null,'LIKE,=','CCCC.CC.CCCC.CCCCCC','Y','Y','N',120,null,'Loan account','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'FULLNAME','Tên khách hàng','C','LN0002',150,null,'LIKE,=',null,'Y','Y','N',120,null,'Customer name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'AFACCTNO','Số Tiểu khoản','C','LN0002',10,null,'LIKE,=','_','Y','Y','N',120,null,'Contract number','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'CUSTODYCD','Số lưu ký','C','LN0002',100,null,'=, LIKE',null,'Y','Y','N',80,null,'Custody code','N',null,null,'N',null,null,null,'N');
COMMIT;
/
