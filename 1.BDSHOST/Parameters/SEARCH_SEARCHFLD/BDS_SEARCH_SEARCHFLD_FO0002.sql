﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'FO0002';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('FO0002','Sổ phụ tài khoản tiền','Cash account statement','SELECT DISTINCT LG.TXDATE, LG.TXNUM, LG.TXTIME, LG.TLTXCD, LG.TXDESC, LG.MSGAMT, LG.MSGACCT
FROM AFMAST AF, CIMAST MST, CITRAN TRF, TLLOG LG, APPTX TX
WHERE AF.ACCTNO=MST.AFACCTNO AND MST.ACCTNO=TRF.ACCTNO AND TRF.TXDATE=LG.TXDATE AND TRF.TXNUM=LG.TXNUM AND LG.DELTD<>''Y''
AND TX.APPTYPE=''CI'' AND TX.FIELD=''BALANCE'' AND TX.TXCD=TRF.TXCD AND AF.ACCTNO=''<$AFACCTNO>''
UNION ALL
SELECT DISTINCT LG.TXDATE, LG.TXNUM, LG.TXTIME, LG.TLTXCD, LG.TXDESC, LG.MSGAMT, LG.MSGACCT
FROM AFMAST AF, CIMAST MST, CITRANA TRF, TLLOGALL LG, APPTX TX
WHERE AF.ACCTNO=MST.AFACCTNO AND MST.ACCTNO=TRF.ACCTNO AND TRF.TXDATE=LG.TXDATE AND TRF.TXNUM=LG.TXNUM AND LG.DELTD<>''Y''
AND TX.APPTYPE=''CI'' AND TX.FIELD=''BALANCE'' AND TX.TXCD=TRF.TXCD AND AF.ACCTNO=''<$AFACCTNO>''','USERLOGIN',null,'TXDATE, TXNUM',null,null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'FO0002';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'MSGAMT','Số tiền','N','FO0002',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'Amount','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'MSGACCT','Số tài khoản','C','FO0002',100,null,'=','_','Y','N','N',150,null,'Reference','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'TXDESC','Diễn giải','C','FO0002',100,null,'=','_','Y','N','N',150,null,'Description','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'TXTIME','Giờ giao dịch','C','FO0002',100,null,'=','_','Y','N','N',150,null,'Tx.Time','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'TXNUM','Số giao dịch','C','FO0002',100,'CCCCDCCCCCC','=',null,'Y','N','N',100,null,'Tx.Num','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'TXDATE','Ngày giao dịch','D','FO0002',100,null,'=',null,'Y','Y','N',100,null,'Tx.Date','N','  ',null,'N',null,null,null,'N');
COMMIT;
/