﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'OD8826';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('OD8826','Thanh toán lệnh bán OTC (8826)','OTC sell settlement(wait for 8826)','select * from (select od.orderid,max(se.costprice) costprice,
(case when sum(sts.AMT) > sum(sts.QTTY) * max(se.costprice) then sum(sts.AMT) - sum(sts.QTTY) * max(se.costprice) else 0 end ) PROFITAMT,
(case when sum(sts.AMT) < sum(sts.QTTY) * max(se.costprice) then sum(sts.QTTY) * max(se.costprice) - sum(sts.AMT) else 0 end ) lossamt,
max(sts.afacctno) afacctno,
max(sb.symbol) symbol,max(od.SEACCTNO) SEACCTNO ,sum(sts.AMT) AMT, sum(sts.QTTY) QTTY,
max(od.feeacr-od.feeamt) feeamt, 0 vat ,max(sb.parvalue) parvalue
from odmast od, stschd sts , sbsecurities sb, semast se
where od.orderid=sts.orgorderid  and od.codeid=sb.codeid and sb.tradeplace=''003''
and sts.duetype=''SS'' and sts.deltd <>''Y'' and sts.status =''N''
and od.deltd <>''Y'' and od.seacctno =se.acctno
group by orderid) where 0=0 ','ODMAST',null,null,'8826',null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'OD8826';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'PARVALUE','Mệnh giá','N','OD8826',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Parvalue','N','44',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'LOSSAMT','Số lỗ','N','OD8826',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Loss amount','N','15',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'PROFITAMT','Số lời','N','OD8826',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Profit amount','N','14',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'COSTPRICE','Costprice','N','OD8826',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Costprice','N','16',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'VAT','Thuế VAT','N','OD8826',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'VAT','N','13',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'FEEAMT','Phí','N','OD8826',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Fee amount','N','12',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'QTTY','Số lượng','N','OD8826',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Trading quantity','N','09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'AMT','Số tiền','N','OD8826',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Trading amount','N','08',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'SYMBOL','Chứng khoán','C','OD8826',100,null,'LIKE,=','_','Y','Y','N',100,null,'Symbol','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'AFACCTNO','Số Tiểu khoản','C','OD8826',100,null,'LIKE,=','_','Y','Y','N',100,null,'Contract number','N','04',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'SEACCTNO','Số tài khoản SE','C','OD8826',100,'9999.999999.999999','LIKE,=','_','N','N','N',100,null,'SE account number','N','06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'ORDERID','Số hiệu lệnh gốc','C','OD8826',100,'9999.999999.999999','LIKE,=','_','Y','Y','Y',100,null,'Original order ID','N','03',null,'N',null,null,null,'N');
COMMIT;
/
