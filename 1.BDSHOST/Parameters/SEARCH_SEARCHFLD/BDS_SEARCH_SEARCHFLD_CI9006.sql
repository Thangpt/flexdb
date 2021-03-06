--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CI9006';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CI9006','Tra cứu thông tin tài khoản thấu chi','Overdraft account information','SELECT CI.ACCTNO AFACCTNO,CF.FULLNAME,AF.TRADEPHONE ,CI.BALANCE - NVL(v.ADVAMT,0) -NVL(v.SECUREAMT,0) BALANCE,CI.ODAMT,CI.ODINTACR,
greatest(CI.OAMT + nvl(T0.OAMT,0),0) TOAMT,
ABS(CASE WHEN CI.OAMT + nvl(T0.OAMT,0)> 0 THEN least(NVL(T0.OAMT,0),CI.OAMT + nvl(T0.OAMT,0)) ELSE greatest(NVL(T0.OAMT,0) - abs(CI.OAMT)-nvl(T0.OAMT,0),0) END) T0AMT,
ABS(CASE WHEN CI.OAMT  > 0 THEN least(NVL(T1.OAMT,0),CI.OAMT) ELSE 0 END) T1AMT,
ABS(CASE WHEN CI.OAMT > NVL(T1.OAMT,0) THEN least (nvl(T2.OAMT,0),CI.OAMT+nvl(T0.OAMT,0) - NVL(T0.OAMT,0) -NVL(T1.OAMT,0)) ELSE 0 END) T2AMT,
ABS(CASE WHEN CI.OAMT > NVL(T1.OAMT,0)+nvl(T2.OAMT,0) THEN least (NVL(T3.OAMT,0) ,CI.OAMT+nvl(T0.OAMT,0) - NVL(T0.OAMT,0) -NVL(T1.OAMT,0)-nvl(T2.OAMT,0)) ELSE 0 END) T3AMT,
ABS(CASE WHEN CI.OAMT > NVL(T1.OAMT,0)+nvl(T2.OAMT,0)+nvl(T3.OAMT,0) THEN CI.OAMT+nvl(T0.OAMT,0) - NVL(T0.OAMT,0) - NVL(T1.OAMT,0)- nvl(T2.OAMT,0)-nvl(T3.OAMT,0) ELSE 0 END) TTAMT,
greatest(CI.OAMT + nvl(TT0.OAMT,0),0) TTOAMT,
ABS(CASE WHEN CI.OAMT + nvl(TT0.OAMT,0)> 0 THEN least(NVL(TT0.OAMT,0),CI.OAMT + nvl(TT0.OAMT,0)) ELSE greatest(NVL(TT0.OAMT,0) - abs(CI.OAMT)-nvl(TT0.OAMT,0),0) END) TT0AMT
FROM CFMAST CF,AFMAST AF,
(SELECT BALANCE-NVL(V.SECUREAMT,0) BALANCE, ODAMT, ODINTACR,(ODAMT + ODINTACR-BALANCE+NVL(V.SECUREAMT,0)) OAMT,ACCTNO FROM CIMAST,V_GETBUYORDERINFO V WHERE CIMAST.ACCTNO =V.AFACCTNO (+) ) CI,
(SELECT NVL(SUM(execamt + 0.2/100 * execamt - execqtty * quoteprice * bratio/100),0) OAMT, AFACCTNO FROM ODMAST WHERE DELTD <> ''Y'' AND EXECTYPE IN (''NB'',''BC'') AND  execamt + feeacr - execqtty * quoteprice * bratio/100>0 AND TXDATE=to_date(''<$BUSDATE>'',''DD/MM/YYYY'') GROUP BY AFACCTNO) TT0,
(SELECT ROUND(NVL(SUM(quoteprice* remainqtty * (1+0.2/1000- bratio/100) + execamt + 0.2/100 * execamt - execqtty * quoteprice * bratio/100),0),4) OAMT, AFACCTNO FROM ODMAST WHERE DELTD <> ''Y'' AND EXECTYPE IN (''NB'',''BC'') AND  quoteprice* remainqtty * (1+0.2/1000- bratio/100) + execamt + feeacr - execqtty * quoteprice * bratio/100>0 AND TXDATE=to_date(''<$BUSDATE>'',''DD/MM/YYYY'') GROUP BY AFACCTNO) T0,
(SELECT ROUND(NVL(SUM(quoteprice* remainqtty * (1+0.2/1000- bratio/100) + execamt + feeacr - execqtty * quoteprice * bratio/100),0)* (1+ 14.5/100/360* (to_date(''<$BUSDATE>'',''DD/MM/YYYY'')-txdate)),4) OAMT, AFACCTNO FROM ODMAST WHERE DELTD <> ''Y'' AND EXECTYPE IN (''NB'',''BC'') AND quoteprice* remainqtty * (1+0.2/1000- bratio/100) + execamt + feeacr - execqtty * quoteprice * bratio/100>0 AND GETDUEDATE(TXDATE,''B'',''000'',1)=to_date(''<$BUSDATE>'',''DD/MM/YYYY'') GROUP BY AFACCTNO,TXDATE) T1,
(SELECT ROUND(NVL(SUM(quoteprice* remainqtty * (1+0.2/1000- bratio/100) + execamt + feeacr - execqtty * quoteprice * bratio/100),0) * (1+ 14.5/100/360* (to_date(''<$BUSDATE>'',''DD/MM/YYYY'')-txdate)),4) OAMT, AFACCTNO FROM ODMAST WHERE DELTD <> ''Y'' AND EXECTYPE IN (''NB'',''BC'') AND quoteprice* remainqtty * (1+0.2/1000- bratio/100) + execamt + feeacr - execqtty * quoteprice * bratio/100>0 AND GETDUEDATE(TXDATE,''B'',''000'',2)=to_date(''<$BUSDATE>'',''DD/MM/YYYY'') GROUP BY AFACCTNO,TXDATE) T2,
(SELECT ROUND(NVL(SUM(quoteprice* remainqtty * (1+0.2/1000- bratio/100) + execamt + feeacr - execqtty * quoteprice * bratio/100),0) * (1+ 14.5/100/360* (to_date(''<$BUSDATE>'',''DD/MM/YYYY'')-txdate)),4) OAMT, AFACCTNO FROM ODMAST WHERE DELTD <> ''Y'' AND EXECTYPE IN (''NB'',''BC'') AND quoteprice* remainqtty * (1+0.2/1000- bratio/100) + execamt + feeacr - execqtty * quoteprice * bratio/100>0 AND GETDUEDATE(TXDATE,''B'',''000'',3)=to_date(''<$BUSDATE>'',''DD/MM/YYYY'') GROUP BY AFACCTNO,TXDATE) T3,
 v_getbuyorderinfo v
WHERE
CF.CUSTID=AF.CUSTID AND AF.ACCTNO=CI.ACCTNO
AND AF.ACCTNO =TT0.AFACCTNO(+)
AND AF.ACCTNO =T0.AFACCTNO(+)
AND AF.ACCTNO =T1.AFACCTNO(+)
AND AF.ACCTNO =T2.AFACCTNO(+)
AND AF.ACCTNO =T3.AFACCTNO(+)
AND AF.ACCTNO =v.AFACCTNO(+)
','CIMAST',null,null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CI9006';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'TT0AMT','Thấu chi T-0','N','CI9006',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Real Overdraft T-0','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'TTOAMT','Tổng thấu chi','N','CI9006',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Real total Overdraft','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'TTAMT','Thấu chi <T-3','N','CI9006',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Overdraft <T-3','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'T3AMT','Thấu chi T-3','N','CI9006',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Overdraft T-3','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'T2AMT','Thấu chi T-2','N','CI9006',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Overdraft T-2','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'T1AMT','Thấu chi T-1','N','CI9006',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Overdraft T-1','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'TOAMT','Tổng thấu chi','N','CI9006',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Total Overdraft','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'T0AMT','Thấu chi T-0','N','CI9006',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Overdraft T-0','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'ODINTACR','Lãi thấu chi','N','CI9006',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Overdraft interest','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'ODAMT','Đã thấu chi','N','CI9006',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Overdraft amount','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'BALANCE','Số dư','N','CI9006',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Balance','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'TRADEPHONE','Số ĐT','C','CI9006',110,'CCCDCDCCCCCC','LIKE,=','_','Y','Y','N',120,null,'Phone','N','  ',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'FULLNAME','Tên khách hàng','C','CI9006',150,null,'LIKE,=',null,'Y','Y','Y',120,null,'Fullname','N','01',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'AFACCTNO','Số tài khoản','C','CI9006',110,null,'LIKE,=','_','Y','Y','N',120,null,'Contract number','N','  ',null,'N',null,null,null,'N');
COMMIT;
/
