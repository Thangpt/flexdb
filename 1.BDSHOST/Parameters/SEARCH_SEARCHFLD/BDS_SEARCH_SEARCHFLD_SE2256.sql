--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SE2256';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SE2256','Giao dịch trở lại của chứng khoán chờ giao dịch','View pending to approve from depository center (wait for 2256)','SELECT distinct  LOG.BUSDATE TXDATE,A4.CDCONTENT TRADEPLACE , ACTYPE, SUBSTR(SEMAST.ACCTNO,1,4) || ''.'' || SUBSTR(SEMAST.ACCTNO,5,6) || ''.'' || SUBSTR(SEMAST.ACCTNO,11,6) ACCTNO, SYM.SYMBOL, SYM.PARVALUE, SEMAST.CODEID, SUBSTR(AFACCTNO,1,4) || ''.'' || SUBSTR(AFACCTNO,5,6) AFACCTNO,SUBSTR(CUSTODYCD,1,4) || ''.'' || SUBSTR(CUSTODYCD,5,6) CUSTODYCD, SEMAST.OPNDATE, CLSDATE, SEMAST.LASTDATE,
A1.CDCONTENT STATUS, SEMAST.PSTATUS, A2.CDCONTENT IRTIED, A3.CDCONTENT ICCFTIED, IRCD, COSTPRICE,SEDEPOSIT.DEPOSITQTTY SENDDEPOSIT,SEDEPOSIT.DEPOSITPRICE DEPOSITPRICE,SEDEPOSIT.DESCRIPTION DESCRIPTION,SEDEPOSIT.AUTOID AUTOID, CFMAST.CUSTID, COSTDT, LOG.BUSDATE PDATE,SEDEPOSIT.RDATE,
CFMAST.FULLNAME, CFMAST.ADDRESS, CFMAST.IDCODE,DEPOTRADE,DEPOBLOCK,A5.CDCONTENT CD_QTTYTYPE, SEDEPOSIT.TYPEDEPOBLOCK QTTYTYPE, SEDEPOSIT.WTRADE WTRADE
FROM SEMAST,CFMAST,SBSECURITIES SYM,(SELECT * FROM SEDEPOSIT WHERE STATUS=''C'' AND DELTD <> ''Y'') SEDEPOSIT, ALLCODE A1, ALLCODE A2, ALLCODE A3,ALLCODE A4,ALLCODE A5, ( SELECT MSGACCT,MAX(BUSDATE) BUSDATE FROM  ( SELECT * FROM TLLOG  WHERE TXSTATUS = ''1'' AND DELTD = ''N'' AND TLTXCD = ''2246'' UNION ALL SELECT * FROM TLLOGALL WHERE TXSTATUS = ''1'' AND DELTD = ''N'' AND TLTXCD = ''2246'' ) GROUP BY MSGACCT ) LOG
WHERE SEMAST.WTRADE>0 AND A1.CDTYPE = ''SE'' AND A1.CDNAME = ''STATUS'' AND A1.CDVAL = SEMAST.STATUS
AND SEMAST.CUSTID=CFMAST.CUSTID
AND A2.CDTYPE = ''SY'' AND A2.CDNAME = ''YESNO''  AND A2.CDVAL = IRTIED
AND nvl(A5.CDTYPE,''SE'') = ''SE'' AND NVL(A5.CDNAME,''QTTYTYPE'') = ''QTTYTYPE'' AND SEDEPOSIT.TYPEDEPOBLOCK=A5.CDVAL (+)
AND SYM.CODEID = SEMAST.CODEID
AND A3.CDTYPE = ''SY'' AND A3.CDNAME = ''YESNO''  AND A3.CDVAL = SEMAST.ICCFTIED
AND A4.CDTYPE = ''SE'' AND A4.CDNAME = ''TRADEPLACE''  AND A4.CDVAL = SYM.TRADEPLACE
AND SEDEPOSIT.ACCTNO=SEMAST.ACCTNO
AND LOG.MSGACCT = SEMAST.ACCTNO','SEMAST',null,null,'2256',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SE2256';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'WTRADE','Số dư chờ giao dich','N','SE2256',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'P Trade','N','14',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'RDATE','Ngày giao dịch trở lại','D','SE2256',100,null,'<,<=,=,>=,>,<>','##/##/####','Y','Y','N',100,null,'Return date','N','13',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'PDATE','Posted date','D','SE2256',100,null,'<,<=,=,>=,>,<>','##/##/####','N','N','N',100,null,'Posted date','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'IDCODE','Số giấy tờ','C','SE2256',50,null,'LIKE,=',null,'Y','Y','N',60,null,'ID CODE','N','92',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'DESCRIPTION','Diễn giải','C','SE2256',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Description','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'ADDRESS','Địa chỉ','C','SE2256',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Address','N','91',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'FULLNAME','Tên khách hàng','C','SE2256',150,null,'=','_','Y','Y','N',150,null,'Full name','N','90',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'DEPOSITPRICE','Giá lưu ký','N','SE2256',100,null,'<,<=,=,>=,>,<>',null,'N','N','N',100,null,'Deposit price','N','09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'PARVALUE','Mệnh giá','N','SE2256',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Parvalue','N','11',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'ACCTNO','Số TK SE','C','SE2256',100,'cccc.cccccc.cccccc','LIKE,=','_','N','N','Y',120,null,'Account number','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'AFACCTNO','Số Tiểu khoản','C','SE2256',100,null,'LIKE,=','_','Y','Y','N',100,null,'Contract number','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CUSTODYCD','Số lưu ký','C','SE2256',100,'cccc.cccccc','LIKE,=','_','Y','Y','N',100,null,'Custody code','N','88',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CODEID','Chứng khoán','C','SE2256',100,'cccccc','LIKE,=','_','N','N','N',100,null,'Symbol','N','01',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'TXDATE','Ngày chuyển hồ sơ lên TT','D','SE2256',100,null,'<,<=,=,>=,>,<>','##/##/####','Y','Y','N',100,null,'Previous action date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'SYMBOL','Chứng khoán','C','SE2256',100,'ccccccccccccccc','LIKE,=','_','Y','Y','N',100,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'TRADEPLACE','Nơi giao dịch','C','SE2256',100,'cccccc','LIKE,=','_','Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SE'' AND CDNAME = ''TRADEPLACE'' ORDER BY LSTODR','Trade place','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-1,'AUTOID','Số dư tăng','N','SE2256',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Auto ID','N','05',null,'N',null,null,null,'N');
COMMIT;
/
