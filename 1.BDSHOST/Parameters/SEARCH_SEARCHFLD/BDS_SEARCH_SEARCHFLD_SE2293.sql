--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SE2293';
INSERT into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('SE2293', 'Quản lý hồ sơ xin rút chứng khoán (chưa thực hiện 2292)', 'Depository management', 'SELECT   SUBSTR(SEMAST.ACCTNO,1,4) || ''.'' || SUBSTR(SEMAST.ACCTNO,5,6) || ''.'' || SUBSTR(SEMAST.ACCTNO,11,6) ACCTNO, SYM.SYMBOL, SUBSTR(SEMAST.AFACCTNO,1,4) || ''.'' || SUBSTR(SEMAST.AFACCTNO,5,6) AFACCTNO,iss.fullname issname,
SEWD.WITHDRAW  WITHDRAW,SEMAST.CODEID,SYM.PARVALUE,SEINFO.BASICPRICE  PRICE,SEMAST.LASTDATE SELASTDATE,AF.LASTDATE AFLASTDATE,NVL(SEMAST.LASTDATE,AF.LASTDATE) LASTDATE,CF.CUSTODYCD,A1.CDCONTENT TRADEPLACE, CF.FULLNAME, SEWD.TXDATE,
SEWD.TXNUM, SEWD.TXDATETXNUM ,CF.IDCODE LICENSE, IDPLACE LICENSEPLACE,IDDATE LICENSEDATE,CF.ADDRESS, CASE WHEN NVL(AF.TRADEPHONE,'''')='''' THEN AF.PHONE1 ELSE AF.TRADEPHONE END PHONE,
NVL(SEP.PITQTTY,0) PITQTTY
FROM SEMAST,SBSECURITIES SYM,AFMAST AF,CFMAST CF,ALLCODE A1
, SECURITIES_INFO SEINFO,  SEWITHDRAWDTL SEWD,issuers iss,
(SELECT txnum, txdate, sum(qtty) pitqtty FROM sepitallocate GROUP BY txnum, txdate) sep
WHERE SYM.CODEID=SEINFO.CODEID
AND A1.CDTYPE = ''SE'' AND A1.CDNAME = ''TRADEPLACE'' AND A1.CDVAL = SYM.TRADEPLACE
AND CF.CUSTID =AF.CUSTID
AND SYM.CODEID = SEMAST.CODEID
AND SEMAST.afacctno= AF.acctno
AND SEMAST.WITHDRAW >0
AND SEMAST.ACCTNO = SEWD.ACCTNO
AND SEWD.STATUS = ''P''
AND iss.issuerid = sym.issuerid
AND SEWD.Txdate = sep.txdate (+) --1.8.2.5: thue quyen
AND sewd.txnum = sep.txnum (+)', 'SEMAST', null, null, '2293', null, 50, 'N', 30, 'NYNNYYYNNN', 'Y', 'T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SE2293';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'LICENSE','Số giấy tờ','C','SE2293',50,null,'LIKE,=',null,'Y','Y','N',60,null,'ID code','N','92',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'TXDATETXNUM','Key','C','SE2293',20,null,'LIKE,=','_','N','N','N',50,null,'Withdraw txnum','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'LICENSEPLACE','Noi cap CT','C','SE2293',300,null,'LIKE,=',null,'N','N','N',300,null,'Issname','N','96',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'ISSNAME','Tên chứng khoán','C','SE2293',300,null,'LIKE,=',null,'Y','Y','N',300,null,'Issname','N','89',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'ADDRESS','Dia chi','C','SE2293',300,null,'LIKE,=',null,'N','N','N',300,null,'Issname','N','97',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'PHONE','So dien thoai','C','SE2293',20,null,'LIKE,=','_','N','N','N',50,null,'Phone','N','93',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'PRICE','Giá','N','SE2293',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Price','N','09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'TRADEPLACE','Nơi giao dịch','C','SE2293',100,null,'LIKE,=','_','Y','Y','N',50,null,'TradePlace','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'CUSTODYCD','Số TK lưu ký','C','SE2293',100,null,'LIKE,=','_','Y','Y','N',100,null,'Custody CD','N','04',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'LASTDATE','Ngày thực hiện giao dịch trước','D','SE2293',100,'__/__/____','<,<=,=,>=,>,<>','##/##/####','Y','Y','N',100,null,'Last date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'LICENSEDATE','Ngày cap CT','D','SE2293',100,'__/__/____','<,<=,=,>=,>,<>','##/##/####','N','N','N',100,null,'Last date','N','95',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'PARVALUE','Mệnh giá','N','SE2293',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Parvalue','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5.1,'PITQTTY','SL GD từ quyền','N','SE2293',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'PitQtty','N','15',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'WITHDRAW','KL chứng khoán xin rút','N','SE2293',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Quantity','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'ACCTNO','Số tài khoản SE','C','SE2293',100,'cccc.cccccc.cccccc','LIKE,=','_','N','N','Y',120,null,'Account number','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'AFACCTNO','Số Tiểu khoản','C','SE2293',100,null,'LIKE,=','_','Y','Y','N',100,null,'Contract number','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'FULLNAME','Họ tên','C','SE2293',100,null,'LIKE,=','_','Y','Y','N',50,null,'Full name','N','90',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'SYMBOL','Chứng khoán','C','SE2293',100,'ccccccccccccccc','LIKE,=','_','Y','Y','N',100,null,'Symbol','N','01',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-1,'TXNUM','Số CT GD xin rút','C','SE2293',10,null,'LIKE,=','_','Y','Y','N',50,null,'Withdraw txnum','N','06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-2,'TXDATE','Ngày TH GD xin rút','D','SE2293',10,'__/__/____','<,<=,=,>=,>,<>','##/##/####','Y','Y','N',100,null,'Withdraw txdate','N','05',null,'N',null,null,null,'N');
COMMIT;
/
