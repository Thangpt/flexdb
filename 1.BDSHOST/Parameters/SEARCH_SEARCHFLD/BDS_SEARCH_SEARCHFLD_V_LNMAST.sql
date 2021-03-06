--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'V_LNMAST';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('V_LNMAST','Quản lý Deal DF của khách hàng','DF Deal Management','select DF.ACCTNO DFACCTNO,
DF.FULLNAME,DF.SYMBOL, CHD.ACCTNO, DF.DFTYPE,CHD.OVERDUEDATE,DF.AFACCTNO AFACCTNO, DF.CUSTODYCD
from (select v_dfmast.*,(SELECT  varvalue FROM SYSVAR
WHERE GRNAME=''SYSTEM'' AND VARNAME=''CURRDATE'') CURRDATE
from v_dfmast) df,
(SELECT ACCTNO,OVERDUEDATE FROM LNSCHD WHERE
OVERDUEDATE IS NOT NULL
GROUP BY ACCTNO ,OVERDUEDATE
HAVING SUM(NML) + SUM(ovd) + SUM(intnmlacr) + SUM(fee) +
SUM(intdue) +
SUM(intovd) + SUM(intovdprin) + sum(feedue) +
sum(feeovd) >0 ) CHD
WHERE CHD.ACCTNO= DF.LNACCTNO and
OVERDUEDATE >= to_date
(CURRDATE,''DD/MM/YYYY'')','V_LNMAST','frmV_LNMAST','ACCTNO DESC',null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'V_LNMAST';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'DFTYPE','Loại sản phẩm','C','V_LNMAST',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Dftype','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'SYMBOL','Chứng khoán','C','V_LNMAST',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Symbol','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'FULLNAME','Tên đầy đủ','C','V_LNMAST',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Full name','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'OVERDUEDATE','Ngày CT','D','V_LNMAST',100,null,'LIKE,=',null,'Y','N','N',100,null,'Date of birth','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CUSTODYCD','Số TK lưu ký','C','V_LNMAST',100,null,'LIKE,=',null,'Y','Y','N',100,null,'CUSTODYCD','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'AFACCTNO','Số tiểu khoản','C','V_LNMAST',10,null,'LIKE,=','_','Y','Y','N',100,null,'Contract no','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'DFACCTNO','Số tiểu khoản DF','C','V_LNMAST',10,'cccdccccccccdccccc','LIKE,=','_','Y','Y','N',100,null,'DF Acctno','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-1,'ACCTNO','Số tiểu khoản LN','C','V_LNMAST',10,'cccdccccccccdccccc','LIKE,=','_','Y','Y','Y',100,null,'LN Acctno','N',null,null,'N',null,null,null,'N');
COMMIT;
/
