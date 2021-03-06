--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'RMBK01';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('RMBK01','Tạo bảng kê gửi sang ngân hàng','Create EOD Report send to bank','SELECT FN_GET_LOCATION(AF.BRID) LOCATION, MST.REQID,MST.OBJNAME, MST.TXDATE,MST.AFFECTDATE, MST.OBJKEY,MST.TRFCODE,
A1.CDCONTENT TRFNAME,MST.BANKCODE,CRB.BANKNAME, CF.CUSTODYCD,MST.AFACCTNO,
MST.BANKACCT BANKACCTNO,CF.FULLNAME BANKACCTNAME, RF.DESACCTNO_R DESACCTNO,
RF.DESACCTNAME_R DESACCTNAME,MST.TXAMT,MST.STATUS,MST.NOTES
FROM CRBTXREQ MST,AFMAST AF,CFMAST CF,CRBDEFBANK CRB,ALLCODE A1,
 (SELECT *
FROM   (SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
        FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE MST.STATUS IN (''P'',''A'',''C'',''E'') AND MST.REQID=DTL.REQID)
PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN
(''DESACCTNO'' as DESACCTNO,''DESACCTNAME'' as DESACCTNAME))
ORDER BY REQID) RF
WHERE MST.REQID=RF.REQID AND MST.AFACCTNO = AF.ACCTNO
AND AF.CUSTID=CF.CUSTID AND MST.BANKCODE=CRB.BANKCODE AND MST.STATUS=''P''
AND MST.TRFCODE = A1.CDVAL AND A1.CDNAME=''TRFCODE''
AND MST.TRFCODE NOT IN (''TRFADADV'',''TRFADPAID'') ','BANKINFO',null,null,'EXEC',0,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'RMBK01';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (200,'LOCATION','Khu vực','C','RMBK01',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''LOCATION'' ORDER BY LSTODR','Location','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'NOTES','Diễn giải','C','RMBK01',450,null,'LIKE,=',null,'Y','Y','N',450,null,'Description','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'TXAMT','Số tiền','N','RMBK01',100,null,'>=,<=,>,<,=','#,##0','Y','Y','N',100,null,'Amount','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'DESACCTNAME','Tên TK đích','C','RMBK01',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Destination account name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'DESACCTNO','TK đích','C','RMBK01',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Destination account','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'BANKACCTNAME','Tên TK ngân hàng','C','RMBK01',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Cust bank account name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'BANKACCTNO','TK ngân hàng','C','RMBK01',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Cust bank account','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'AFACCTNO','Số tiểu khoản','C','RMBK01',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Sub-account','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'CUSTODYCD','Số TK lưu ký','C','RMBK01',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Account','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'BANKNAME','Tên ngân hàng','C','RMBK01',100,null,'LIKE,=',null,'Y','Y','N',100,'SELECT CDCONTENT VALUE, CDCONTENT DISPLAY FROM ALLCODE
WHERE CDTYPE=''CF'' AND CDNAME = ''BANKNAME'' AND LSTODR>0
AND (CDVAL LIKE ''BIDV%'' OR CDVAL LIKE ''BVB%'' OR CDVAL LIKE ''DAB%'' OR CDVAL LIKE ''STB%'')
ORDER BY LSTODR','Bank Name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'BANKCODE','Mã ngân hàng ','C','RMBK01',100,null,'LIKE,=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDVAL DISPLAY FROM ALLCODE
WHERE CDTYPE=''CF'' AND CDNAME = ''BANKNAME'' AND LSTODR>0
AND (CDVAL LIKE ''BIDV%'' OR CDVAL LIKE ''BVB%'' OR CDVAL LIKE ''DAB%'' OR CDVAL LIKE ''STB%'')
ORDER BY LSTODR','Bank Code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'TRFNAME','Loại bảng kê','C','RMBK01',100,null,'LIKE,=',null,'Y','Y','N',100,'SELECT CDCONTENT VALUE, CDCONTENT DISPLAY FROM ALLCODE
WHERE CDTYPE = ''SY'' AND CDNAME = ''TRFCODE''
AND CDVAL IN (''TRFODBUY'',''TRFODSELL'',''TRFODBFEE'',''TRFODSFEE'',''TRFODBRK'',
''TRFODTAX'',''TRFCAREG'',''TRFCAUNREG'',''TRFSEFEE'',''TRFCACASH'',''TRFCATAX'',
''TRFODSRTL'',''TRFODSRTDF'',''TRFCIDAMT'',''TRFCICAMT'',''TRFADVAMT'',''TRFSECLSFEE'',''TRFRLSFEE'',''TRFRLSTAX'',''TRFRLSBUY'',''TRFRLSADV'',''FDSWITHDRAW'',''FDSDEPOSIT'')
ORDER BY LSTODR','Transfer Name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'TRFCODE','Mã bảng kê','C','RMBK01',100, null,'LIKE,=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDVAL DISPLAY FROM ALLCODE
WHERE CDTYPE = ''SY'' AND CDNAME = ''TRFCODE''
AND CDVAL IN (''TRFODBUY'',''TRFODSELL'',''TRFODBFEE'',''TRFODSFEE'',''TRFODBRK'',
''TRFODTAX'',''TRFCAREG'',''TRFCAUNREG'',''TRFSEFEE'',''TRFCACASH'',''TRFCATAX'',
''TRFODSRTL'',''TRFODSRTDF'',''TRFCIDAMT'',''TRFCICAMT'',''TRFADVAMT'',''TRFSECLSFEE'',''TRFRLSFEE'',''TRFRLSTAX'',''TRFRLSBUY'',''TRFRLSADV'',''FDSWITHDRAW'',''FDSDEPOSIT'')
ORDER BY LSTODR','Transfer Code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'OBJKEY','Số chứng từ','C','RMBK01',100,null,'LIKE,=',null,'Y','Y','N',100,null,'TxNum','N','21',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'AFFECTDATE','Ngày hiệu lực','D','RMBK01',100,null,'>=,<=,=',null,'Y','Y','N',100,null,'Affect date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'TXDATE','Ngày','D','RMBK01',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'REQID','Số hiệu yêu cầu','C','RMBK01',100,null,'LIKE,=',null,'N','Y','Y',100,null,'Request ID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
