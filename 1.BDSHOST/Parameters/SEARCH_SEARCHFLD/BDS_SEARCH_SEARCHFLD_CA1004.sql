﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CA1004';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CA1004','Chốt danh sách đăng ký phân bổ thực hiện quyền (đối chiếu all)','Chốt danh sách đăng ký phân bổ thực hiện quyền (đối chiếu all)','SELECT * FROM (SELECT CF.CUSTODYCD,MAX(CAS.AUTOID) AUTOID,CAS.CAMASTID,
   MAX(CAS.AFACCTNO) AFACCTNO,MAX(A0.CDCONTENT) CATYPE, MAX(CAS.CODEID) CODEID,
   MAX(A0.CDVAL) CATYPEVALUE, CF.FULLNAME,
   DECODE(SUBSTR(CF.CUSTODYCD,4,1),''F'',MAX(CF.TRADINGCODE),CF.IDCODE) IDCODE ,
   DECODE(SUBSTR(CF.CUSTODYCD,4,1),''F'',MAX(CF.TRADINGCODEDT),CF.IDDATE) IDDATE, MAX(CF.IDPLACE) IDPLACE, MAX(CF.ADDRESS) ADDRESS,
   SUM(CAS.TRADE) BALANCE,SUM(CAS.QTTY) QTTY, SUM(CAS.AMT) AMT, SUM(CAS.AQTTY) AQTTY,
   MAX(CA.REPORTDATE) REPORTDATE,MAX(CA.ACTIONDATE) ACTIONDATE,
   SUM(CAS.AAMT) AAMT, MAX(SYM.SYMBOL) SYMBOL, MAX(A1.CDCONTENT) STATUS
FROM CASCHD CAS, SBSECURITIES SYM, ALLCODE A0, ALLCODE A1, CAMAST CA, AFMAST AF, CFMAST CF
WHERE A0.CDTYPE = ''CA'' AND A0.CDNAME = ''CATYPE'' AND A0.CDVAL = CA.CATYPE
AND A1.CDTYPE = ''CA'' AND A1.CDNAME = ''CASTATUS'' AND A1.CDVAL = CAS.STATUS
AND CAS.CAMASTID = CA.CAMASTID AND CA.CODEID = SYM.CODEID
AND CAS.DELTD =''N'' AND CA.DELTD=''N'' AND CAS.AFACCTNO= AF.ACCTNO
AND AF.CUSTID = CF.CUSTID  GROUP BY CF.CUSTODYCD,CAS.CAMASTID,CF.FULLNAME,CF.IDCODE,CF.IDDATE) WHERE 0=0 ','CASCHD','frmCASCHD',null,null,null,50,'N',30,'NYNNYYYNNY','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CA1004';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'AMT','Số tiền','N','CA1004',100,null,'<,<=,=,>=,>','#,##0','N','N','N',100,null,'Amount','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'QTTY','Số lượng','N','CA1004',100,null,'<,<=,=,>=,>','#,##0','N','N','N',100,null,'Quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'BALANCE','Số CK ĐK','N','CA1004',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',120,null,'Balance','N',null,null,'N',null,null,'BALANCE','N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'CODEID','Chứng khoán','C','CA1004',100,null,'=',null,'N','N','N',100,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'STATUS','Trạng thái','C','CA1004',100,null,'LIKE,=',null,'Y','Y','N',80,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''CA'' AND CDNAME = ''CASTATUS'' ORDER BY LSTODR','Status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'CATYPE','Loại TH quyền','C','CA1004',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''CA''
AND CDNAME = ''CATYPE'' AND CDUSER=''Y''  ORDER BY LSTODR','Coporate type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'SYMBOL','Chứng khoán','C','CA1004',100,null,'LIKE,=',null,'Y','Y','N',80,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'IDDATE','Ngày cấp','D','CA1004',100,null,'=,LIKE',null,'Y','Y','N',100,null,'Id date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'IDCODE','Số CMT','C','CA1004',100,null,'=',null,'Y','Y','N',100,null,'Id code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'FULLNAME','Tên đầy đủ','C','CA1004',250,null,'=',null,'Y','Y','N',250,null,'Full name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'AFACCTNO','Mã tiểu khoản','C','CA1004',100,null,'=','0###-#####0','N','N','N',100,null,'Contrac No','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Số tự tăng','C','CA1004',100,null,'<,<=,=,>=,>',null,'N','N','Y',100,null,'AutoId','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-1,'CUSTODYCD','Số lưu ký','C','CA1004',100,null,'=, LIKE',null,'Y','Y','N',120,null,'Custody code','N',null,null,'N',null,null,'CUSTODYCD','Y');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-5,'CAMASTID','Mã TH quyền','C','CA1004',100,null,'LIKE,=',null,'Y','Y','N',120,null,'CA code','N',null,null,'N',null,null,null,'N');
COMMIT;
/