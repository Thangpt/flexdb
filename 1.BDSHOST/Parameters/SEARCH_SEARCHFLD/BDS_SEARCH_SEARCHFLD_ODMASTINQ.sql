﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'ODMASTINQ';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('ODMASTINQ','Quan ly so lenh','Order management','SELECT OD.ORDERID ORDERID, OD.REFORDERID,A0.CDCONTENT TRADEPLACE,SUBSTR (OD.AFACCTNO, 1, 4) || ''.''|| SUBSTR (OD.AFACCTNO, 5, 6) AFACCTNO,
SUBSTR (CF.CUSTODYCD, 1, 3) || ''.''|| SUBSTR (CF.CUSTODYCD, 4, 1)|| ''.'' || SUBSTR (CF.CUSTODYCD, 5, 6) CUSTODYCD,
SE.SYMBOL SYMBOL, A1.CDCONTENT ORSTATUS,A10.CDCONTENT EDSTATUS, OT.TYPENAME ACTYPE,A2.CDCONTENT VIA, MK.TLNAME MAKER, OFC.TLNAME OFFICER,
OD.TXTIME MAKETIME,NVL(TLG.OFFTIME,''____'') APPRTIME,NVL(OD.SENDTIME,''____'') SENDTIME,A3.CDCONTENT TIMETYPE, OD.TXNUM, OD.TXDATE, OD.EXPDATE,
OD.BRATIO, A4.CDCONTENT EXECTYPE, OD.NORK, A5.CDCONTENT MATCHTYPE,OD.CLEARDAY, A6.CDCONTENT CLEARCD, A7.CDCONTENT PRICETYPE,OD.QUOTEPRICE, OD.STOPPRICE, OD.LIMITPRICE, OD.ORDERQTTY,
OD.REMAINQTTY, OD.EXECQTTY, OD.STANDQTTY, OD.CANCELQTTY, OD.ADJUSTQTTY,OD.REJECTQTTY, A8.CDCONTENT REJECTCD, OD.EXPRICE, OD.EXQTTY,
A9.CDCONTENT DELTD,OD.MAPORDERID FROM AFMAST AF,CFMAST CF,SBSECURITIES SE,ODTYPE OT,ALLCODE A0,ALLCODE A1,ALLCODE A2,
ALLCODE A3,ALLCODE A4,ALLCODE A5,ALLCODE A6,ALLCODE A7,ALLCODE A8,ALLCODE A9,ALLCODE A10,
(SELECT OD.*, OOD.TXTIME SENDTIME FROM
(SELECT OD.*, NVL(BK.ORDERNUMBER,'''') MAPORDERID FROM ODMAST OD, STCORDERBOOK BK WHERE OD.ORDERID=BK.ORDERID (+)
UNION ALL
SELECT OD.*, NVL(BK.ORDERNUMBER,'''') MAPORDERID FROM ODMASTHIST OD, STCORDERBOOKHIST BK WHERE OD.ORDERID=BK.ORDERID (+)
AND OD.TXDATE >=TO_DATE ((SELECT VARVALUE FROM SYSVAR WHERE VARNAME = ''DUEDATE'' AND GRNAME = ''SYSTEM''),''DD/MM/YYYY'')) OD,(
SELECT TXTIME ,ORGORDERID FROM OOD UNION ALL SELECT TXTIME ,ORGORDERID FROM OODHIST) OOD WHERE OD.ORDERID=OOD.ORGORDERID(+)) OD,
(SELECT TLID, TLNAME FROM TLPROFILES UNION ALL  SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL) MK,
(SELECT TLID, TLNAME FROM TLPROFILES UNION ALL  SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL) OFC,
(SELECT TXDATE, TXNUM, TLID, OFFID, TXTIME, OFFTIME, TLTXCD, DELTD,TXSTATUS FROM TLLOG
UNION ALL SELECT TXDATE, TXNUM, TLID, OFFID, TXTIME, OFFTIME, TLTXCD, DELTD,TXSTATUS FROM TLLOGALL) TLG
WHERE OD.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID AND OD.CODEID = SE.CODEID AND OD.ACTYPE = OT.ACTYPE
AND A10.CDTYPE = ''OD'' AND A10.CDNAME = ''EDSTATUS'' AND A10.CDVAL = OD.EDSTATUS
AND A0.CDTYPE = ''OD'' AND A0.CDNAME = ''TRADEPLACE'' AND A0.CDVAL = SE.TRADEPLACE AND A2.CDTYPE = ''OD'' AND A2.CDNAME = ''VIA''
AND A2.CDVAL = OD.VIA AND A3.CDTYPE = ''OD'' AND A3.CDNAME = ''TIMETYPE'' AND A3.CDVAL = OD.TIMETYPE AND A4.CDTYPE = ''OD''
AND A4.CDNAME = ''EXECTYPE'' AND A4.CDVAL = OD.EXECTYPE AND A5.CDTYPE = ''OD'' AND A5.CDNAME = ''MATCHTYPE'' AND A5.CDVAL = OD.MATCHTYPE
AND A6.CDTYPE = ''OD'' AND A6.CDNAME = ''CLEARCD'' AND A6.CDVAL = OD.CLEARCD AND A7.CDTYPE = ''OD'' AND A7.CDNAME = ''PRICETYPE''
AND A7.CDVAL = OD.PRICETYPE AND A8.CDTYPE = ''OD'' AND A8.CDNAME = ''REJECTCD'' AND A8.CDVAL = OD.REJECTCD AND A9.CDTYPE = ''SY''
AND A9.CDNAME = ''YESNO'' AND A9.CDVAL = OD.DELTD AND NVL(TLG.TLID,''____'') = MK.TLID AND NVL( TLG.OFFID,''____'') =OFC.TLID
AND OD.TXDATE = TLG.TXDATE AND OD.TXNUM = TLG.TXNUM AND A1.CDNAME = ''ORSTATUS''
AND (CASE WHEN (TLG.OFFID IS NULL) AND TLG.TLTXCD NOT IN (''8876'', ''8877'', ''8882'', ''8883'', ''8884'', ''8885'',''8890'',''8891'') THEN ''9''
WHEN (TLG.OFFID IS NOT NULL) AND TLG.TXSTATUS = ''5'' THEN ''6'' WHEN (TLG.OFFID IS NOT NULL) AND TLG.TXSTATUS = ''8'' THEN ''0''
ELSE OD.ORSTATUS END) = A1.CDVAL and (CF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>'') OR ''0001''=''<$TELLERID>'')','ODMAST','frmODMAST','ORDERID DESC',null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'ODMASTINQ';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (43,'MAPORDERID','Lenh trung tam','C','ODMASTINQ',100,null,'LIKE,=',null,'Y','Y','N',100,null,'STC order','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (42,'DELTD','Da xoa','C','ODMASTINQ',100,null,'=',null,'Y','Y','N',70,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''YESNO'' ORDER BY LSTODR','Deleted','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (41,'ICCFTIED','Kieu ICCF','C','ODMASTINQ',100,null,'=',null,'N','N','N',70,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''YESNO'' ORDER BY LSTODR','ICCF type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (40,'ICCFCD','Ma ICCF','C','ODMASTINQ',100,null,'=',null,'N','N','N',100,'SELECT ICCFCD VALUE,DESCRIPTION FROM ICCF WHERE MODCODE =''OD'' ORDER BY ICCFCD','ICCF code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (39,'EXQTTY','EX quantity','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'EX quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (38,'REJECTCD','Ly do huy','C','ODMASTINQ',100,null,'=',null,'Y','N','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''REJECTCD'' ORDER BY LSTODR','Reject type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (37,'REJECTQTTY','Khoi luong bi huy','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','N','N',100,null,'Reject quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (36,'STANDQTTY','KL chuyen thanh toan bu tru','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','N','N',100,null,'Stand quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (35,'LIMITPRICE','Gioi han gia','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','N','N',100,null,'Limit price','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (34,'STOPPRICE','Du tru','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','N','N',100,null,'Stop price','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (33,'TRADEPLACE','S�giao d�ch','C','ODMASTINQ',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''TRADEPLACE'' ORDER BY LSTODR','Trade place','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (32,'CLEARCD','Cach tinh lech','C','ODMASTINQ',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''CLEARCD'' ORDER BY LSTODR','Clear type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (31,'CLEARDAY','Chu ky thanh toan','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Clear Day','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (30,'MATCHTYPE','PL theo phuong thuc khop lenh','C','ODMASTINQ',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''MATCHTYPE'' ORDER BY LSTODR','Match type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (29,'NORK','PL theo tinh hoan chinh','C','ODMASTINQ',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''NORK'' ORDER BY LSTODR','All or none','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (28,'BRATIO','Ti le ky quy','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Secure ratio','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (27,'EXPDATE','Ngay het hieu luc','D','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Expire date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (26,'EXPRICE','EX price','N','ODMASTINQ',80,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',80,null,'EX price','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (25,'TIMETYPE','Lo�i h� l�nh theo th�i gian','C','ODMASTINQ',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''TIMETYPE'' ORDER BY LSTODR','Time type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (24,'ACTYPE','Lo�i h�','C','ODMASTINQ',100,null,'=',null,'Y','Y','N',150,'SELECT ACTYPE VALUE, TYPENAME DISPLAY FROM ODTYPE ORDER BY ACTYPE','Product type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (23,'OFFICER','Ngu�i duy�t l�nh','C','ODMASTINQ',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Officer','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (22,'MAKER','Ngu�i d�t l�nh','C','ODMASTINQ',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Maker','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (21,'VIA','Phuong th�c d�t l�nh','C','ODMASTINQ',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''VIA'' ORDER BY LSTODR','Via','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (20,'PRICETYPE','Loai lenh','C','ODMASTINQ',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''PRICETYPE'' ORDER BY LSTODR','Price Order type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (19,'TXDATE','Ngay dat lenh','D','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Tx. Date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (18,'TXNUM','So chung tu','C','ODMASTINQ',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Tx.Num','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (17,'SENDTIME','Gi� g�i l�nh','C','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Send time','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'APPRTIME','Gi� duy�t l�nh','C','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Approve time','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'MAKETIME','Gi� d�t l�nh','C','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Make time','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'ADJUSTQTTY','KL dieu chinh giam','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','N','N',100,null,'Adjust quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'CANCELQTTY','Khoi luung cho huy','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','N','N',100,null,'Cancel quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'REMAINQTTY','Khoi luong cho giao dich','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','N','N',100,null,'Remain quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'EXECQTTY','Khoi luong da khop','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Executed quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'REFORDERID','Lenh lien ket','C','ODMASTINQ',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Reference order','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'ORDERID','M�i�u l�nh','C','ODMASTINQ',100,null,'LIKE,=',null,'Y','Y','Y',100,null,'Order id','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'EDSTATUS','Trang thai sua','C','ODMASTINQ',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''EDSTATUS'' ORDER BY LSTODR','Correction status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'ORSTATUS','Tr�ng th�l�nh','C','ODMASTINQ',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''ORSTATUS'' ORDER BY LSTODR','Order status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'QUOTEPRICE','Gia dat lenh','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',180,null,'Place Order price','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'ORDERQTTY','So luong ban dau','N','ODMASTINQ',100,null,'<,<=,=,>=,>,<>',null,'Y','N','N',100,null,'Order quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'SYMBOL','Chứng khoán','C','ODMASTINQ',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'EXECTYPE','Phan loai thuc hien lenh','C','ODMASTINQ',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''EXECTYPE'' ORDER BY LSTODR','Exect type ','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CUSTODYCD','S� h�p d�ng','C','ODMASTINQ',120,'ccc.c.cccccc','LIKE,=','_','Y','Y','N',100,null,'Custody code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'AFACCTNO','S� h�p d�ng','C','ODMASTINQ',120,null,'LIKE,=','_','Y','Y','N',100,null,'Contract No','N',null,null,'N',null,null,null,'N');
COMMIT;
/
