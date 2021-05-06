﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SE2294';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SE2294','Quản lý hồ sơ xin rút chứng khoán mà TT chưa trả lời (chưa thực hiện 2201)','Waiting reply from Depository management','SELECT   SUBSTR(SEMAST.ACCTNO,1,4) || ''.'' || SUBSTR(SEMAST.ACCTNO,5,6) || ''.'' || SUBSTR(SEMAST.ACCTNO,11,6) ACCTNO, SYM.SYMBOL, SUBSTR(SEMAST.AFACCTNO,1,4) || ''.'' || SUBSTR(SEMAST.AFACCTNO,5,6) AFACCTNO,
SEWD.WITHDRAW  WITHDRAW,SEMAST.CODEID,SYM.PARVALUE,SEINFO.BASICPRICE  PRICE,CF.IDCODE LICENSE, cf.IDPLACE LICENSEPLACE,IDDATE LICENSEDATE,CF.ADDRESS,SEMAST.LASTDATE SELASTDATE,AF.LASTDATE AFLASTDATE,NVL(SEMAST.LASTDATE,AF.LASTDATE) LASTDATE,CF.CUSTODYCD,A1.CDCONTENT TRADEPLACE, CF.FULLNAME, SEWD.TXDATE, SEWD.TXNUM, SEWD.TXDATETXNUM
FROM SEMAST,SBSECURITIES SYM,AFMAST AF,CFMAST CF,ALLCODE A1
, SECURITIES_INFO SEINFO,  SEWITHDRAWDTL SEWD
WHERE SYM.CODEID=SEINFO.CODEID
AND A1.CDTYPE = ''SA'' AND A1.CDNAME = ''TRADEPLACE'' AND A1.CDVAL = SYM.TRADEPLACE
AND CF.CUSTID =AF.CUSTID
AND SYM.CODEID = SEMAST.CODEID
AND SEMAST.afacctno= AF.acctno
AND SEMAST.WITHDRAW >0
AND SEMAST.ACCTNO = SEWD.ACCTNO
AND SEWD.STATUS = ''A''','SEMAST',null,null,'2294',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SE2294';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'IDPLACE','Nơi cấp','C','SE2294',100,null,'LIKE,=','_','Y','Y','N',50,null,'Id Place','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'LICENSEDATE','Ngày cấp','D','SE2294',100,null,'<,<=,=,>=,>,<>','##/##/####','N','N','N',100,null,'Id date','N','95',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'LICENSE','Số giấy tờ','C','SE2294',50,null,'LIKE,=',null,'Y','Y','N',60,null,'ID code','N','92',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'ADDRESS','Địa chỉ','C','SE2294',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Address','N','91',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'TXDATETXNUM','Key','C','SE2294',20,null,'LIKE,=','_','N','N','N',50,null,'Withdraw txnum','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'PRICE','Giá','N','SE2294',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Price','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'TRADEPLACE','Nơi giao dịch','C','SE2294',100,null,'LIKE,=','_','Y','Y','N',50,null,'TradePlace','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'CUSTODYCD','Số TK lưu ký','C','SE2294',100,null,'LIKE,=','_','Y','Y','N',100,null,'Custody CD','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'LASTDATE','Ngày thực hiện giao dịch trước','D','SE2294',100,'__/__/____','<,<=,=,>=,>,<>','##/##/####','Y','Y','N',100,null,'Last date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'PARVALUE','Mệnh giá','N','SE2294',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Parvalue','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'WITHDRAW','KL chứng khoán xin rút','N','SE2294',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Quantity','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'ACCTNO','Số tài khoản SE','C','SE2294',100,'cccc.cccccc.cccccc','LIKE,=','_','N','N','Y',120,null,'Account number','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'AFACCTNO','Số Tiểu khoản','C','SE2294',100,null,'LIKE,=','_','Y','Y','N',100,null,'Contract number','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'FULLNAME','Họ tên','C','SE2294',100,null,'LIKE,=','_','Y','Y','N',50,null,'Full name','N','90',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CODEID','Chứng khoán','C','SE2294',100,'cccccc','LIKE,=','_','N','N','N',100,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'SYMBOL','Chứng khoán','C','SE2294',100,'ccccccccccccccc','LIKE,=','_','Y','Y','N',100,null,'Symbol','N','04',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-1,'TXNUM','Số CT GD xin rút','C','SE2294',10,null,'LIKE,=','_','Y','Y','N',50,null,'Withdraw txnum','N','06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-2,'TXDATE','Ngày TH GD xin rút','D','SE2294',10,'__/__/____','<,<=,=,>=,>,<>','##/##/####','Y','Y','N',100,null,'Withdraw txdate','N','05',null,'N',null,null,null,'N');
COMMIT;
/
