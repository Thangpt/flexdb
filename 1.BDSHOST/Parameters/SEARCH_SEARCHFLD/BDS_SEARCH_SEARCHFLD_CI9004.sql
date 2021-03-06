--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CI9004';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CI9004','Tra cứu số dư bình quân trong tháng','View Average balance of month','SELECT DT.AFACCTNO,DT.TXDATE,ROUND(DT.CIBALANCE,3) CIBALANCE,ROUND(DT.SEBALANCE,3) SEBALANCE,ROUND(DT.AVRBAL,3) AVRBAL,PERIOD,ROUND(nvl(DT.VAL_OD,0),3) VAL_OD,ROUND(nvl(DT.VAL_IO,0),3) VAL_IO,ROUND(nvl(DT.FEEACR,0),3) FEEACR,CF.FULLNAME,CD.CDCONTENT CLASS
FROM ALLCODE CD,CFMAST CF,AFMAST AF,
    (
    SELECT DT.*, OD.VAL_OD,OD.VAL_IO,OD.FEEACR FROM
    (
    SELECT DT.* FROM (
    SELECT MAX(AFACCTNO) AFACCTNO,MAX(TXDATE) TXDATE,SUM(CIBALANCE)/COUNT(AFACCTNO) CIBALANCE,
    SUM(SEBALANCE)/COUNT(AFACCTNO) SEBALANCE, SUM(AVRBAL)/COUNT(AFACCTNO) AVRBAL,''EOD'' Period FROM
    (SELECT AFACCTNO,TXDATE,CIBALANCE,SEBALANCE,AVRBAL FROM AVRBAL
    UNION ALL
    SELECT CI.AFACCTNO,TO_DATE(SYS.VARVALUE,''DD/MM/YYYY'') TXDATE,
    CI.BALANCE CIBALANCE,DT.SEBALANCE,CI.BALANCE+DT.SEBALANCE AVRBAL
    FROM SYSVAR SYS,CIMAST CI,(SELECT MAX(SE.AFACCTNO) AFACCTNO,SUM(SE.TRADE*SEC.BASICPRICE)  SEBALANCE FROM SEMAST SE,SECURITIES_INFO SEC
    WHERE SEC.CODEID =SE.CODEID  GROUP BY SE.AFACCTNO) DT
    WHERE CI.AFACCTNO=DT.AFACCTNO AND SYS.VARNAME=''CURRDATE'' AND SYS.GRNAME=''SYSTEM''
    ) DT1  GROUP BY AFACCTNO ) DT )DT,
    (
    SELECT OD.AFACCTNO, nvl(SUM(OD.QUOTEPRICE*OD.ORDERQTTY),0) VAL_OD , nvl(SUM(EXECAMT),0) VAL_IO, nvl(SUM(OD.FEEACR),0) FEEACR
    FROM
    (SELECT TXDATE,AFACCTNO,QUOTEPRICE,ORDERQTTY,FEEACR,EXECAMT ,ORDERID FROM ODMASTHIST WHERE DELTD <>''Y'' AND EXECTYPE IN (''NB'',''BC'',''NS'',''SS'',''MS'')
    UNION ALL
SELECT TXDATE,AFACCTNO,QUOTEPRICE,ORDERQTTY,FEEACR,EXECAMT ,ORDERID FROM ODMAST WHERE DELTD <>''Y'' AND EXECTYPE IN (''NB'',''BC'',''NS'',''SS'',''MS''))OD ,
SYSVAR SYS
WHERE SYS.VARNAME=''CURRDATE'' AND SYS.GRNAME=''SYSTEM''
AND OD.TXDATE>=TO_DATE(''01/'' || SUBSTR(SYS.VARVALUE,4,7),''DD/MM/YYYY'')
AND OD.TXDATE<=LAST_DAY(TO_DATE(SYS.VARVALUE,''DD/MM/YYYY''))
GROUP BY OD.AFACCTNO) OD
WHERE DT.AFACCTNO =OD.AFACCTNO(+)
UNION ALL
SELECT AFACCTNO,TXDATE,CIBALANCE,SEBALANCE,AVRBAL,PERIOD,AVRODPLACE VAL_OD,AVRODMATCH VAL_IO,FEEACR FROM AVRBALALL ) DT
WHERE CF.CUSTID =AF.CUSTID AND AF.ACCTNO =DT.AFACCTNO AND CD.CDTYPE=''CF''
AND CD.CDNAME =''CLASS'' AND CD.CDVAL=CF.CLASS','CIMAST',null,null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CI9004';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'PERIOD','Chữ ký','C','CI9004',100,null,'=',null,'Y','Y','N',80,null,'Period','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'FEEACR','FEEACR','N','CI9004',20,null,'=,<,<=,>=,>','#,##0','Y','Y','N',120,null,'FEEACR','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'VAL_IO','VAL_IO','N','CI9004',20,null,'=,<,<=,>=,>','#,##0','Y','Y','N',120,null,'VAL_IO','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'VAL_OD','VAL_OD','N','CI9004',20,null,'=,<,<=,>=,>','#,##0','Y','Y','N',120,null,'VAL_OD','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'AVRBAL','Số dư trung bình','N','CI9004',20,null,'=,<,<=,>=,>','#,##0','Y','Y','N',120,null,'Average balance','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'SEBALANCE','Số dư SE trung bìnhSE Average balance','N','CI9004',20,null,'=,<,<=,>=,>','#,##0','Y','Y','N',120,null,'SE Average balance','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'CIBALANCE','Số dư CI trung bình','N','CI9004',20,null,'=,<,<=,>=,>','#,##0','Y','Y','N',120,null,'CI Average balance','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'TXDATE','Ngày giao dịch','D','CI9004',20,'99/99/9999','=,<,<=,>=,>','_','Y','Y','N',100,null,'TXDATE','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CLASS','Phân loại','C','CI9004',100,null,'=',null,'Y','Y','N',80,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''CLASS'' ORDER BY LSTODR','Class','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'FULLNAME','Tên khách hàng','C','CI9004',100,null,'LIKE,=',null,'Y','Y','N',150,null,'Customer name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AFACCTNO','Số Tiểu khoản','C','CI9004',10,null,'LIKE,=','_','Y','Y','N',120,null,'Contract number','N',null,null,'N',null,null,null,'N');
COMMIT;
/
