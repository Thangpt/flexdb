﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CF0064';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CF0064','Tra cứu Tiểu khoản chờ duyệt','View contract pending to approve','SELECT AFMAST.ACTYPE, SUBSTR(AFMAST.CUSTID,1,4) || ''.'' || SUBSTR(AFMAST.CUSTID,5,6) CUSTID,CF.FULLNAME,  SUBSTR(AFMAST.ACCTNO,1,4) || ''.'' || SUBSTR(AFMAST.ACCTNO,5,6) ACCTNO, AFMAST.AFTYPE,A10.cdcontent TYPENAME, A1.CDCONTENT TRADEFLOOR,A2.CDCONTENT TRADETELEPHONE,A3.CDCONTENT TRADEONLINE,AFMAST.PIN,A4.CDCONTENT LANGUAGE,AFMAST.TRADEPHONE,A5.CDCONTENT ALLOWDEBIT,AFMAST.BANKACCTNO,AFMAST.SWIFTCODE,A7.CDCONTENT RECEIVEVIA,AFMAST.EMAIL,AFMAST.ADDRESS,AFMAST.FAX,AFMAST.CIACCTNO,AFMAST.IFRULECD,AFMAST.LASTDATE,A8.CDCONTENT STATUS,AFMAST.MARGINLINE,AFMAST.TRADELINE,AFMAST.ADVANCELINE,AFMAST.REPOLINE,AFMAST.DEPOSITLINE,AFMAST.BRATIO,AFMAST.TELELIMIT,AFMAST.ONLINELIMIT,AFMAST.CFTELELIMIT,AFMAST.CFONLINELIMIT,AFMAST.TRADERATE,AFMAST.DEPORATE,AFMAST.MISCRATE,A9.CDCONTENT TERMOFUSE,AFMAST.DESCRIPTION
FROM AFMAST AFMAST,CFMAST CF,AFTYPE AFT, ALLCODE A1, ALLCODE A2,ALLCODE A3,ALLCODE A4,ALLCODE A5,ALLCODE A7,ALLCODE A8,ALLCODE A9 ,ALLCODE A10
WHERE AFMAST.STATUS=''T'' AND AFMAST.CUSTID=CF.CUSTID AND AFMAST.ACTYPE=AFT.ACTYPE AND
A1.CDTYPE = ''SY'' AND A1.CDNAME = ''YESNO'' AND
A1.CDVAL= AFMAST.TRADEFLOOR AND
A2.CDTYPE = ''SY'' AND A2.CDNAME = ''YESNO'' AND
A2.CDVAL= AFMAST.TRADETELEPHONE AND A3.CDTYPE = ''SY'' AND
A3.CDNAME = ''YESNO'' AND
A3.CDVAL= AFMAST.TRADEONLINE AND A4.CDTYPE = ''CF'' AND
A4.CDNAME = ''LANGUAGE'' AND
A4.CDVAL = AFMAST.LANGUAGE AND A5.CDTYPE = ''SY'' AND
A5.CDNAME = ''YESNO'' AND
A5.CDVAL = AFMAST.ALLOWDEBIT AND
A7.CDTYPE = ''CF'' AND
A7.CDNAME = ''RECEIVEVIA'' AND
A7.CDVAL = AFMAST.RECEIVEVIA AND
A8.CDTYPE = ''CF'' AND
A8.CDNAME = ''STATUS'' AND
A8.CDVAL = AFMAST.STATUS AND
A9.CDTYPE = ''CF'' AND
A9.CDNAME = ''TERMOFUSE'' AND
A9.CDVAL = AFMAST.TERMOFUSE AND
A10.CDTYPE = ''CF'' AND
A10.CDNAME = ''AFTYPE'' AND
A10.CDVAL = AFMAST.AFTYPE ','AFMAST',null,null,'0064',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CF0064';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (18,'MISCRATE','Phí khác','N','CF0064',20,null,'LIKE,=','#,##0','Y','N','N',100,null,'MiscRate','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (17,'DEPORATE','Phí lưu ký','N','CF0064',20,null,'LIKE,=','#,##0.###0','Y','N','N',100,null,'DepositoryRate','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'TRADERATE','Phí giao dịch','N','CF0064',20,null,'LIKE,=','#,##0.###0','Y','N','N',100,null,'TradeRate','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'CFONLINELIMIT','Hạn mức Online của KH','N','CF0064',20,null,'LIKE,=','#,##0','Y','N','N',100,null,'CF OnlineLimit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'CFTELELIMIT','Hạn mức Tele của KH','N','CF0064',20,null,'LIKE,=','#,##0','Y','N','N',100,null,'CF TeleLimit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'ONLINELIMIT','Hạn mức Online','N','CF0064',20,null,'LIKE,=','#,##0','Y','N','N',100,null,'OnlineLimit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'TELELIMIT','Hạn mức Tele','N','CF0064',20,null,'LIKE,=','#,##0','Y','N','N',100,null,'TeleLimit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'BRATIO','Tỷ lệ ký quỹ','N','CF0064',20,null,'LIKE,=','#,##0.###0','Y','N','N',100,null,'Secured ratio','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'DEPOSITLINE','Hạn mức gửi','N','CF0064',20,null,'LIKE,=','#,##0','Y','N','N',100,null,'DepositLine','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'REPOLINE','Hạn mức Repo','N','CF0064',20,null,'LIKE,=','#,##0','Y','N','N',100,null,'RepoLine','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'ADVANCELINE','Hạn mức ứng trước','N','CF0064',20,null,'LIKE,=','#,##0','Y','N','N',100,null,'AdvanceLine','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'TRADELINE','Hạn mức giao dịch','N','CF0064',20,null,'LIKE,=','#,##0','Y','N','N',100,null,'TradeLine','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'MARGINLINE','Hạn mức Margin','N','CF0064',20,null,'LIKE,=','#,##0','Y','N','N',100,null,'MarginLine','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'DESCRIPTION','Diễn giải','C','CF0064',100,null,'LIKE,=',null,'N','N','N',100,null,'Note','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'TYPENAME','Tên Tiểu khoản','C','CF0064',100,null,'=',null,'Y','Y','N',80,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''AFTYPE'' ORDER BY LSTODR','Type name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'ACCTNO','Số Tiểu khoản','C','CF0064',10,'9999.999999','LIKE,=','_','Y','Y','Y',100,null,'Contract number','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'FULLNAME','Tên khách hàng','C','CF0064',100,null,'LIKE,=',null,'Y','Y','N',150,null,'Customer name','N','90',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CUSTID','Mã khách hàng','C','CF0064',10,'9999.999999','LIKE,=','_','Y','Y','N',100,null,'Customer id','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'ACTYPE','Mã loại hình','C','CF0064',100,'cccc','LIKE,=','_','Y','Y','N',100,null,'Product code','N','39',null,'N',null,null,null,'N');
COMMIT;
/
