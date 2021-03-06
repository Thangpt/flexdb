--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SE2249';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SE2249','Tra c?u hoàn t?t dóng ti?u kho?n (2249)','View sub account ready for close  (wait for 2249)','SELECT MAX(FN_GET_LOCATION(AF.BRID)) LOCATION, AF.ACCTNO, CF.CUSTODYCD, MAX(CF.FULLNAME) FULLNAME, MAX(CF.IDCODE) IDCODE, MAX(TYP.TYPENAME) TYPENAME, MAX(SE.LASTDATE) SELASTDATE, MAX(AF.LASTDATE) AFLASTDATE, MAX(NVL(SE.LASTDATE,AF.LASTDATE)) LASTDATE
FROM AFMAST AF, CIMAST CI, SEMAST SE, CFMAST CF,
(SELECT * FROM CASCHD WHERE DELTD=''N'') CA, AFTYPE TYP, sbsecurities sb
WHERE TYP.ACTYPE=AF.ACTYPE AND AF.ACCTNO= CI.ACCTNO AND CF.CUSTID=AF.CUSTID AND  AF.ACCTNO =SE.AFACCTNO(+) AND sb.codeid = nvl(se.codeid,sb.codeid)
AND AF.STATUS=''N'' AND AF.ACCTNO = CA.AFACCTNO (+)
AND (CA.AFACCTNO IS NULL OR CA.STATUS NOT IN (''A'',''S'') or (ca.isse = ''Y'' AND ca.qtty > 0) or (ca.isci = ''Y'' and ca.amt > 0))
AND sb.sectype <> ''004''
GROUP BY AF.ACCTNO,CF.CUSTODYCD--,SE.LASTDATE,AF.LASTDATE ,NVL(SE.LASTDATE,AF.LASTDATE)
HAVING SUM(NVL(SE.DTOCLOSE,0))+SUM(NVL(SE.trade,0))=0','SEMAST',null,null,'2249',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SE2249';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (200,'LOCATION','Khu vực','C','SE2249',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''LOCATION'' ORDER BY LSTODR','Location','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'LASTDATE','Ngày thực hiện GD cuối cùng','D','SE2249',100,'__/__/____','<,<=,=,>=,>,<>','##/##/####','Y','N','N',150,null,'Last date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'TYPENAME','Loại hình','C','SE2249',100,'cccc.cccccc','LIKE,=','_','Y','N','N',200,null,'Product','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'ACCTNO','Số tiểu khoản','C','SE2249',100,'9999.999999','LIKE,=','_','Y','Y','N',150,null,'Contract number','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'IDCODE','Số CMT/hộ chiếu','C','SE2249',100,null,'LIKE,=','_','Y','Y','N',150,null,'Identification code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'FULLNAME','Tên khách hàng','C','SE2249',100,null,'LIKE,=','_','Y','N','N',200,null,'Customer name','N','90',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'CUSTODYCD','Số TK lưu ký','C','SE2249',100,'cccc.cccccc','LIKE,=','_','Y','Y','N',100,null,'Custody code','N','88',null,'N',null,null,null,'N');
COMMIT;
/
