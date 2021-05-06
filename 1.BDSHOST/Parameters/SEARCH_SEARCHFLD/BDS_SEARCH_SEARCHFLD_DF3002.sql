﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'DF3002';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('DF3002','Theo dõi trạng thái Deal tổng bị CALL','DF Deal Status','SELECT * FROM ( select al1.cdcontent DEALFLAGTRIGGER,DF.GROUPID,CF.CUSTODYCD,CF.FULLNAME,
AF.ACCTNO AFACCTNO,CF.ADDRESS,CF.IDCODE,nvl(DF.CONTRACTCHK,''N'') CONTRACTCHK,DECODE(DF.LIMITCHK,''N'',0,1) LIMITCHECK ,
DF.ORGAMT -DF.RLSAMT AMT, DF.LNACCTNO , DF.STATUS DEALSTATUS ,DF.ACTYPE ,DF.RRTYPE, DF.DFTYPE, DF.CUSTBANK, DF.CIACCTNO,DF.FEEMIN,
DF.TAX,DF.AMTMIN,DF.IRATE,DF.MRATE,DF.LRATE,DF.RLSAMT,DF.DESCRIPTION, lns.rlsdate, lns.overduedate,
to_date (lns.overduedate,''DD/MM/RRRR'') - to_date ((SELECT VARVALUE FROM SYSVAR WHERE VARNAME=''CURRDATE''),''DD/MM/RRRR'') duenum,
(case when df.ciacctno is not null then df.ciacctno when df.custbank is not null then   df.custbank else '''' end )
RRID , decode (df.RRTYPE,''O'',1,0) CIDRAWNDOWN,decode (df.RRTYPE,''B'',1,0) BANKDRAWNDOWN,
decode (df.RRTYPE,''C'',1,0) CMPDRAWNDOWN,dftype.AUTODRAWNDOWN,df.calltype,ROUND(LN.RLSAMT) AMTRLS,
LN.RATE1,LN.RATE2,LN.RATE3,LN.CFRATE1,LN.CFRATE2,LN.CFRATE3,
A1.CDCONTENT PREPAIDDIS,A2.CDCONTENT INTPAIDMETHODDIS,A3.CDCONTENT AUTOAPPLYDIS,TADF,ROUND(DDF) DDF, RTTDF RTT,
ROUND(ODCALLDF) ODCALLDF, ROUND(ODCALLSELLRCB) ODCALLSELLRCB,
ROUND(ODCALLSELLMRATE) ODCALLSELLMRATE, ROUND(ODCALLSELLMRATE) - ROUND(NVL(od.sellamount,0)) ODSELLDF,
ROUND(ODCALLSELLRXL) ODCALLSELLRXL, ROUND(ODCALLRTTDF) ODCALLRTTDF, ROUND(ODCALLRTTDF) ODCALLRTTF,
ROUND(CURAMT) CURAMT, ROUND(CURINT) CURINT, ROUND(CURFEE) CURFEE, ROUND(LNS.PAID) PAID,
ROUND(DF.DFBLOCKAMT), ROUND(vndselldf) vndselldf, ROUND(vndwithdrawdf) vndwithdrawdf, ROUND(ROUND(tadf) - ddf*(v.irate/100)) vwithdrawdf,
LEAST(ln.MInterm, TO_NUMBER( TO_DATE(lns.OVERDUEDATE,''DD/MM/RRRR'') - TO_DATE(lns.RLSDATE,''DD/MM/RRRR'')) )  MInterm, ln.intpaidmethod, lnt.WARNINGDAYS,
A4.CDCONTENT RRTYPENAME, AF.FAX1, CF.EMAIL, ODDF
from dfgroup df, dftype, lnmast ln, lntype lnt ,lnschd lns, afmast af , cfmast cf, allcode al1,
   ALLCODE A1, ALLCODE A2, ALLCODE A3, v_getgrpdealformular v , allcode A4, v_getdealsellamt od
where df.lnacctno= ln.acctno and ln.acctno=lns.acctno and ln.actype=lnt.actype and lns.reftype=''P'' and df.afacctno= af.acctno and af.custid= cf.custid and df.actype=dftype.actype
and A1.cdname = ''YESNO'' and A1.cdtype =''SY'' AND A1.CDVAL = LN.PREPAID
and A2.cdname = ''INTPAIDMETHOD'' and A2.cdtype =''LN'' AND A2.CDVAL = LN.INTPAIDMETHOD
and A3.cdname = ''AUTOAPPLY'' and a3.cdtype =''LN'' AND A3.CDVAL = LN.AUTOAPPLY
and A4.cdname = ''RRTYPE'' and A4.cdtype =''DF'' AND A4.CDVAL = DF.RRTYPE
and df.flagtrigger=al1.cdval and al1.cdname=''FLAGTRIGGER'' and df.groupid=v.groupid(+)
and df.groupid=od.groupid(+) and df.afacctno=od.afacctno(+)
) WHERE ODDF>0 AND (( RTT <= MRATE AND RTT> LRATE) OR (DUENUM<=WARNINGDAYS and duenum>0) )','DFGROUP','frmViewDFMAST','GROUPID DESC',null,null,50,'N',30,'NYNNYYYYYN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'DF3002';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (63,'EMAIL','Email','C','DF3002',100,null,'LIKE,=',null,'Y','N','N',100,null,'EMAIL','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (61,'FAX1','Số điện thoại','C','DF3002',100,null,'LIKE,=',null,'Y','N','N',100,null,'FAX1','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (59,'RRTYPENAME','Nguồn','C','DF3002',100,null,'LIKE,=',null,'Y','N','N',100,null,'RRTYPENAME','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (57,'LNACCTNO','Số HĐ vay','C','DF3002',18,'cccc.cccccc.cccccc','LIKE,=','_','Y','N','N',100,null,'LN Account number','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (55,'WARNINGDAYS','Số ngày cảnh báo đến hạn','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'INTPAIDMETHOD','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (53,'INTPAIDMETHOD','Phương thức trả lãi','C','DF3002',18,'cccc.cccccc.cccccc','LIKE,=','_','Y','N','N',100,null,'INTPAIDMETHOD','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (52,'LASTSMS','Lần SMS cuối','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'LASTSMS','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (52,'LASTEMAIL','Lần EMAIL cuối','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'LASTSMS','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (51,'MINTERM','Số ngày tính lãi tối thiểu','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'MINTERM','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (49,'VWITHDRAWDF','GT giải tỏa/bổ sung','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'VWITHDRAWDF','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (47,'VNDWITHDRAWDF','Tiền được giải tỏa','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'VNDWITHDRAWDF','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (45,'VNDSELLDF','Tiền bán trong ngày trả nợ','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'VNDSELLDF','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (43,'DFBLOCKAMT','Tiền mặt','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'DFBLOCKAMT','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (41,'PAID','Nợ đã trả','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'PAID','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (39,'CURFEE','Nợ phí','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'CURFEE','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (37,'CURINT','Nợ lãi','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'CURINT','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (35,'CURAMT','Nợ gốc','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'CURAMT','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (33,'ODCALLSELLRXL','Tiền nộp thêm Rxl','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'ODCALLRTTDF','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (28,'ODSELLDF','Dự tính tiền cần bán thêm(chờ khớp bán)','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'ODSELLDF','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (27,'ODCALLSELLMRATE','Dự tính tiền cần bán thêm(đã khớp bán)','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'ODSELLDF','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (26,'ODCALLSELLRCB','Tiền nộp thêm Rcb','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'ODSELLDF','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (25,'ODCALLDF','Tiền cần nộp thêm Rat','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'ODCALLDF','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (24,'DUENUM','Số ngày đến hạn','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Due day number','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (23,'OVERDUEDATE','Ngày đến hạn','D','DF3002',100,'__/__/____','LIKE,=','##/##/####','Y','Y','N',100,null,'Over due date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (21,'RLSDATE','Ngày giải ngân','D','DF3002',100,'__/__/____','LIKE,=','##/##/####','Y','Y','N',100,null,'Release date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (19,'DDF','Nợ quy đổi','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Loan value','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (17,'TADF','Tài sản quy đổi','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Asset value','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'LRATE','Tỷ lệ xử lý','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0.###0','Y','N','N',100,null,'LRATE','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'MRATE','Tỉ lệ cảnh báo','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0.###0','Y','N','N',100,null,'MRATE','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'IRATE','Tỉ lệ an toàn','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0.###0','Y','N','N',100,null,'IRATE','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'RTT','Tỉ lệ thực tế','N','DF3002',100,null,'<,<=,=,>=,>,<>','#,##0.###0','Y','N','N',100,null,'RTT','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'GROUPID','Số deal tổng','C','DF3002',18,'cccc.cccccc.cccccc','LIKE,=','_','Y','Y','Y',120,null,'DF Account number','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'FULLNAME','Họ và tên','C','DF3002',100,null,'LIKE,=','_','Y','Y','N',100,null,'Custody CD','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'AFACCTNO','Số Tiểu khoản','C','DF3002',120,null,'LIKE,=','_','Y','Y','N',100,null,'Account number','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CUSTODYCD','TK Lưu ký','C','DF3002',100,null,'LIKE,=','_','Y','Y','N',100,null,'Custody CD','N',null,null,'N',null,null,null,'N');
COMMIT;
/