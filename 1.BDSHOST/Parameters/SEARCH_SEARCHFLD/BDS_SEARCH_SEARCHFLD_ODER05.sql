﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'ODER05';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('ODER05','Sinh lệnh sửa lỗi (8848)','Generate new order (8848)','SELECT STS.TXDATE, STS.ORDERID, STS.CUSTODYCD, STS.AFACCTNO, STS.CODEID, STS.SYMBOL, STS.EXECTYPEVL, STS.EXECTYPE,
        STS.ORDERQTTY, STS.QUOTEPRICE, STS.MATCHQTTY, STS.MATCHAMT, STS.CLEARDATE,
        STS.TDCUSTODYCD, STS.TDAFACCTNO, NVL(TDSE.SEQTTY,0) TDSEQTTY, STS.TDPP, STS.MATCHQTTY MATCHQTTY2, STS.FULLNAME
FROM
(
    SELECT OD.TXDATE, OD.ORDERID, CF.CUSTODYCD, STS.AFACCTNO, SB.CODEID, SB.SYMBOL, OD.EXECTYPE EXECTYPEVL, A.CDCONTENT EXECTYPE,
        OD.ORDERQTTY, OD.QUOTEPRICE, STS.QTTY MATCHQTTY, STS.AMT MATCHAMT, STS.CLEARDATE,
        CF2.CUSTODYCD TDCUSTODYCD, AF2.ACCTNO TDAFACCTNO, GETAVLPP(AF2.ACCTNO) TDPP, CF.FULLNAME
    FROM STSCHD STS, ODMAST OD, CFMAST CF, AFMAST AF, SBSECURITIES SB, ALLCODE A, CFMAST CF2, AFMAST AF2
    WHERE STS.AFACCTNO = AF.ACCTNO AND CF.CUSTID = AF.CUSTID
        AND STS.CODEID = SB.CODEID AND STS.ORGORDERID = OD.ORDERID
        AND STS.DUETYPE IN (''RM'',''RS'') AND STS.DELTD = ''Y''
        AND OD.ERROD = ''Y'' AND OD.ERRSTS IN (''E'') AND OD.ERRREASON <> ''02''
        AND A.CDTYPE = ''OD'' AND A.CDNAME = ''EXECTYPE'' AND A.CDVAL = OD.EXECTYPE
        --AND STS.TXDATE >= FN_GET_PREVDATE(GETCURRDATE,1)
        AND CF2.CUSTID = AF2.CUSTID
        AND SUBSTR(CF2.CUSTODYCD,4,1) = ''P''
) STS
LEFT JOIN
(
    SELECT CF.CUSTODYCD, AF.ACCTNO, NVL(SE.CODEID,'''') CODEID, nvl(getavlsetrade(se.afacctno, se.codeid),0) SEQTTY
    FROM CFMAST CF, AFMAST AF, SEMAST SE
    WHERE CF.CUSTID = AF.CUSTID
        AND AF.ACCTNO = SE.AFACCTNO
        AND SUBSTR(CF.CUSTODYCD,4,1) = ''P''
        AND SE.TRADE >0
) TDSE
ON STS.TDAFACCTNO = TDSE.ACCTNO AND STS.CODEID = TDSE.CODEID
WHERE 0 = 0 ','ODMAST',null,'TXDATE DESC, CUSTODYCD, SYMBOL, ORDERID','8848',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'ODER05';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (18,'MATCHQTTY2','Khối lượng khớp','N','ODER05',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'Match quantity','N','12',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (17,'TDPP','Sức mua tự doanh','N','ODER05',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Buying power','N','17',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'TDSEQTTY','Số CK tự doanh','N','ODER05',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Securities quantity','N','16',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'TDAFACCTNO','Số tiểu khoản TD','C','ODER05',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Afacctno','N','05',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'TDCUSTODYCD','Số lưu ký TD','C','ODER05',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Custody code','N','04',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'CLEARDATE','Ngày thanh toán','D','ODER05',100,null,'=',null,'Y','Y','N',100,null,'Clear date','N','09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'MATCHAMT','Giá trị khớp','N','ODER05',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Match value','N','14',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'MATCHQTTY','Khối lượng khớp','N','ODER05',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Match quantity','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'QUOTEPRICE','Giá đặt','N','ODER05',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Quote price','N','11',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'ORDERQTTY','Khối lượng đặt','N','ODER05',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Order quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'EXECTYPE','Loại lệnh','C','ODER05',100,null,'LIKE,=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''EXECTYPE'' ORDER BY LSTODR','Order type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'EXECTYPEVL','Loại lệnh','C','ODER05',100,null,'LIKE,=',null,'N','N','N',100,null,'Order type','N','22',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'SYMBOL','Mã chứng khoán','C','ODER05',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'CODEID','Mã code CK','C','ODER05',100,null,'LIKE,=',null,'N','N','N',100,null,'Codeid','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'AFACCTNO','Số tiểu khoản','C','ODER05',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Afacctno','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'FULLNAME','Họ tên','C','ODER05',100,null,'LIKE,=',null,'N','N','N',100,null,'Fullname','N','90',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'CUSTODYCD','Số lưu ký','C','ODER05',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Custody code','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'ORDERID','Số hiệu lệnh','C','ODER05',100,null,'LIKE,=',null,'Y','Y','Y',120,null,'OrderId','N','01',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'TXDATE','Ngày giao dịch','D','ODER05',100,null,'<,<=,=,>=,>,<>',null,'Y','Y','N',100,null,'Txdate','N','08',null,'N',null,null,null,'N');
COMMIT;
/
