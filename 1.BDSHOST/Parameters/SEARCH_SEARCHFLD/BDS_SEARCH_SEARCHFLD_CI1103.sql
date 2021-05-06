﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CI1103';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CI1103','Tra cứu lệnh cho phép trả ứng trước (1103)','View available order for paid advance payment (wait for 1103)','SELECT * FROM (SELECT (CASE WHEN ODMAST.exectype=''MS'' THEN 1 ELSE 0 END) ISMORTAGE,CD.CDCONTENT MORTAGE,
STSCHD.AFACCTNO,AMT,QTTY,FULLNAME,CUSTODYCD,SB.SYMBOL,AAMT,ORGORDERID,PAIDAMT,PAIDFEEAMT,
SYSRATE.VARVALUE FEERATE,STSCHD.TXDATE,
''Paid Advanced payment: '' || STSCHD.AFACCTNO || ''.'' || SB.SYMBOL || ''.'' || QTTY || ''.'' || SYSVAR.VARVALUE  DES,
GETDUEDATE(STSCHD.TXDATE,STSCHD.CLEARCD,SB.TRADEPLACE,STSCHD.CLEARDAY) CLEARDATE,
 decode ( GETDUEDATE(STSCHD.TXDATE,STSCHD.CLEARCD,''000'',STSCHD.CLEARDAY)-TO_DATE(SYSVAR.VARVALUE,''DD/MM/YYYY''),0,1,GETDUEDATE(STSCHD.TXDATE,STSCHD.CLEARCD,''000'',STSCHD.CLEARDAY)-TO_DATE(SYSVAR.VARVALUE,''DD/MM/YYYY'')) DAYS,
 ROUND(AAMT-PAIDAMT,0) DEPOAMT ,
 ROUND(AAMT-PAIDAMT,0) MAXDEPOAMT,
 ROUND(STSCHD.FAMT - STSCHD.PAIDFEEAMT - SYSMIN.VARVALUE) FEEMAX
FROM
(SELECT ORGORDERID,TXDATE,MAX(AFACCTNO) AFACCTNO, MAX(CODEID) CODEID, MAX(CLEARDAY) CLEARDAY,MAX(CLEARCD) CLEARCD,SUM(AMT) AMT,SUM(QTTY) QTTY,SUM(FAMT) FAMT,SUM(AAMT) AAMT,SUM(PAIDAMT) PAIDAMT,SUM(PAIDFEEAMT) PAIDFEEAMT
    FROM STSCHD WHERE DELTD <> ''Y'' AND STATUS=''N'' AND DUETYPE=''RM''
    GROUP BY ORGORDERID,TXDATE ) STSCHD,
ODMAST,SYSVAR,SYSVAR SYSRATE,SYSVAR SYSMIN,AFMAST,CFMAST,SBSECURITIES SB,ALLCODE CD
WHERE
AAMT-PAIDAMT>0
AND STSCHD.ORGORDERID=ODMAST.ORDERID
AND SYSVAR.VARNAME=''CURRDATE'' AND SYSVAR.GRNAME=''SYSTEM''
AND SYSRATE.VARNAME=''AINTRATE'' AND SYSRATE.GRNAME=''SYSTEM''
AND SYSMIN.VARNAME=''AMINBAL'' AND SYSMIN.GRNAME=''SYSTEM''
AND AFMAST.ACCTNO=STSCHD.AFACCTNO AND AFMAST.CUSTID=CFMAST.CUSTID
AND SB.CODEID=STSCHD.CODEID
AND CD.CDTYPE=''SY'' and CDNAME=''YESNO'' AND CDVAL=(CASE WHEN ODMAST.exectype=''MS'' THEN ''Y'' ELSE ''N'' END) ) WHERE DAYS>0','CIMAST',null,null,'1103',null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CI1103';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'DES','Diễn giải','C','CI1103',100,null,'LIKE,=','_','Y','N','N',100,null,'Description','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'MAXDEPOAMT','Số lượng còn lại','N','CI1103',100,null,'<,<=,=,>=,>,<>',null,'N','N','N',100,null,'Available paid advanced amount','N','20',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'FEEMAX','Số phí trả tối đa','N','CI1103',100,null,'<,<=,=,>=,>,<>',null,'N','N','N',100,null,'Maximum paid fee','N','19',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'DEPOAMT','Số lượng còn lại','N','CI1103',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Available paid advanced amount','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'FEERATE','Tỷ lệ ứng trước','N','CI1103',100,null,'<,<=,=,>=,>,<>','#,##0','Y','N','N',100,null,'Advanced rate','N','12',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'DAYS','Số ngày được ứng trước','N','CI1103',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Available day','N','13',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'AAMT','Lượng ký quỹ','N','CI1103',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Advanced amount','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'ISMORTAGE','Bán cầm cố','N','CI1103',100,null,'<,<=,=,>=,>,<>',null,'N','N','N',100,null,'Is mortage sell','N','60',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'MORTAGE','Bán cầm cố','C','CI1103',100,null,'LIKE,=',null,'Y','Y','N',80,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''YESNO'' ORDER BY LSTODR','Mortage sell','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'SYMBOL','Chứng khoán','C','CI1103',100,null,'LIKE,=','_','Y','N','N',100,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'QTTY','Số lượng khớp','N','CI1103',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Match quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'AMT','Lượng khớp','N','CI1103',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Match amount','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'ORGORDERID','Số hiệu lệnh gốc','C','CI1103',100,'9999.999999','LIKE,=','_','Y','Y','N',100,null,'Original order ID','N','05',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'TXDATE','Ngày khớp lệnh','D','CI1103',100,'DD/MM/YYYY','=,>,>=,<,<=,<>','DD/MM/YYYY','N','N','N',100,null,'Matched date','N','09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CUSTODYCD','TK lưu ký','C','CI1103',100,'ccc.c.cccccc','LIKE,=','_','Y','Y','N',100,null,'Custody code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'FULLNAME','Tên khách hàng','C','CI1103',100,null,'LIKE,=','_','Y','N','N',100,null,'Customer name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AFACCTNO','Số Tiểu khoản','C','CI1103',100,null,'LIKE,=','_','Y','Y','N',100,null,'Contract number','N','03',null,'N',null,null,null,'N');
COMMIT;
/