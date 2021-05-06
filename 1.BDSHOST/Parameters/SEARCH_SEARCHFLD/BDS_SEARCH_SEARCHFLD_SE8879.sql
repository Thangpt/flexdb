﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SE8879';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('SE8879', 'Tra cứu giao dịch bán chứng khoán lô lẻ chỉ thanh toán chứng khoán', 'View match securities order retail', 'SELECT FN_GET_LOCATION(AF.BRID) LOCATION, CF.CUSTODYCD, B.DESACCTNO AFDDI , C.CODEID, C.SYMBOL, C.PARVALUE, A.AFACCTNO,
    to_char(B.TXDATE,''dd/mm/yyyy'') txdate,b.TXNUM,b.ACCTNO,b.PRICE,b.QTTY,b.STATUS,b.DESACCTNO,b.FEEAMT,b.TAXAMT,b.SDATE,b.VDATE,
    CF.IDCODE ,A4.CDCONTENT TRADEPLACE,CASE WHEN CI.COREBANK=''Y'' THEN 0 ELSE 1 END ISCOREBANK,
    ROUND(decode(afTY.VAT,''Y'',1,0)* B.QTTY*((case when b.price>=c.parvalue then b.price else 0 end))/100*(SELECT to_number(varvalue) FROM SYSVAR WHERE VARNAME =''ADVSELLDUTY'')) TAX,
    CI.DEPOLASTDT,fn_get_retailSell_caqtty(b.qtty, b.acctno) pitqtty,
    round(fn_get_retailSell_cavat(b.qtty, b.acctno) * (case when b.price>c.parvalue then c.parvalue else b.price end)/100) pitamt,cf.fullname,
    to_char(B.TXDATE,''dd/mm/yyyy'') || b.TXNUM ACCREF,
    (A.AFACCTNO||NVL(C.REFCODEID,C.CODEID)) DB_ACCTNO_UPDATECOST,
    (SUBSTR(B.DESACCTNO,1,10)||NVL(C.REFCODEID,C.CODEID)) CD_ACCTNO_UPDATECOST, cf.brid || '' - '' || brgrp.brname BRNAME, cf.careby || '' - '' || tlgroups.grpname CAREBY
FROM SEMAST A, SERETAIL B, SBSECURITIES C ,AFMAST AF , CFMAST CF ,ALLCODE A4,AFTYPE afTY,CIMAST CI,brgrp, tlgroups
WHERE A.ACCTNO = B.ACCTNO AND A.CODEID = C.CODEID AND B.QTTY > 0 AND B.STATUS=''S'' AND AF.ACCTNO =A.AFACCTNO AND AF.CUSTID =CF.CUSTID
AND A4.CDTYPE = ''SE'' AND A4.CDNAME = ''TRADEPLACE''  AND A4.CDVAL = C.TRADEPLACE
AND AF.ACTYPE=afty.actype and af.acctno=ci.acctno
AND cf.brid = brgrp.brid AND cf.careby = tlgroups.grpid', 'SEMAST', null, null, '8879', null, 50, 'N', 30, 'NYNNYYYNNN', 'Y', 'T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SE8879';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (200,'LOCATION','Khu vực','C','SE8879',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''LOCATION'' ORDER BY LSTODR','Location','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (34,'DEPOLASTDT','Ngày chuyển phí LK đến hạn gần nhất','D','SE8879',100,null,'<,<=,=,>=,>,<>',null,'N','N','N',150,null,'Last depository fee date','N','32',null,'N',null,null,null,'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (25, 'CAREBY', 'Careby', 'C', 'SE8879', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 150, null, 'CAREBY', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (24, 'BRNAME', 'Mã chi nhánh', 'C', 'SE8879', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 150, null, 'BRNAME', 'N', null, null, 'N', null, null, null, 'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (23,'ISCOREBANK','Là TK corebank','N','SE8879',100,null,'=','#,##0','N','N','N',80,null,'Core Bank','N','60',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (22,'FEEAMT','Phí GD lô lẻ','N','SE8879',100,null,'<,<=,=,>=,>','#,##0.##0','N','N','N',80,null,'Fee amount','N','22',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'IDCODE','IDCODE','C','SE8879',100,null,'=',null,'N','N','N',80,null,'IDCODE','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'AFDDI','MA CK','C','SE8879',100,null,'=',null,'N','N','N',80,null,'AFDDI','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'CD_ACCTNO_UPDATECOST','MA HD mua update giá vốn','C','SE8879',100,null,'=',null,'N','N','N',80,null,'AFDDI','N','28',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'PARVALUE','Par Value','N','SE8879',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',80,null,'Par Value','N','12',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'CODEID','Chứng khoán','C','SE8879',100,null,'=',null,'N','N','N',80,null,'Symbol','N','01',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'PRICE','Giá','N','SE8879',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',80,null,'PRICE','N','11',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'TRADEPLACE','Nơi giao dịch','C','SE8879',100,'cccccc','LIKE,=','_','Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SE'' AND CDNAME = ''TRADEPLACE'' ORDER BY LSTODR','Trade place','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'ACCREF','Số tham chiếu','C','SE8879',100,null,'LIKE,=',null,'N','N','N',150,null,'ACCREF','N','06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'TXNUM','Số chứng từ','C','SE8879',100,null,'LIKE,=',null,'Y','Y','N',150,null,'TRANSACTION NO','N','05',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'TXDATE','Ngày giao dịch','C','SE8879',100,null,'LIKE,=',null,'Y','Y','N',200,null,'TRADE DATE','N','04',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'TAX','Thuế chuyển nhượng','N','SE8879',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'VAT tax','N','14',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'TAXAMT','Thuế TNCN','N','SE8879',100,null,'<,<=,=,>=,>','#,##0','N','N','N',100,null,'TAX','N','15',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'QTTY','Số CK','N','SE8879',100,null,'<,<=,=,>=,>',null,'Y','Y','N',100,null,'QUANTITY','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'PITQTTY','Số CK quyền','N','SE8879',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'CA qtty','N','18',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'PITAMT','Thuế đầu tư vốn','N','SE8879',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'VAT CA sell','N','19',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'DB_ACCTNO_UPDATECOST','Mã HD bán update giá vốn','C','SE8879',100,'CCCCDCCCCCCDCCCCCC','=','_','N','N','N',100,null,'SE ACCOUNT','N','23',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'ACCTNO','Mã HD SE','C','SE8879',100,'CCCCDCCCCCCDCCCCCC','=','_','N','N','Y',100,null,'SE ACCOUNT','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'AFACCTNO','Mã Tiểu khoản','C','SE8879',100,null,'=','_','Y','Y','N',100,null,'CONTRAC NO','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'SYMBOL','Chứng khoán','C','SE8879',100,null,'LIKE,=',null,'Y','Y','N',80,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-9,'FULLNAME','Tên khách hàng','C','SE8879',200,null,'LIKE,=',null,'Y','Y','N',200,null,'Full Name','N','90',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-10,'CUSTODYCD','Số tài khoản lưu ký','C','SE8879',10,'ccc.c.cccccc','LIKE,=','_','Y','Y','N',100,null,'Custody code','N','88',null,'N',null,null,null,'N');
COMMIT;
/