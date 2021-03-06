--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SE2282';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SE2282','Sinh chuyển chứng khoán lẻ giữa các tiểu khoản cùng tài khoản','View account transfer to other account(wait for 2282)','
SELECT TRF.SYMBOL,SB.CODEID,TRF.AFACCTNO, TRF.AFACCTNO || SB.CODEID ACCTNO, AFACCTNO2, AFACCTNO2 || SB.CODEID ACCTNO2, 0 DEPOBLOCK, 0 PRICE, QTTY AMT, PARVALUE,
QTTY, 0 TRADEWTF, ''001'' QTTYTYPE,  0 CIDFPOFEEACR, 0 DEPOBLOCK_CHK, TRF.AUTOID, 0 ORGAMT, 0 ORGTRADEWTF, TRF.DESCRIPTION , ''001'' TRTYPE, CF1.FULLNAME CUSTNAME,
CF1.ADDRESS, CF1.IDCODE LICENSE,  CF2.FULLNAME CUSTNAME2, CF2.ADDRESS ADDRESS2, CF2.IDCODE LICENSE2, 0 NEEDQTTY, least(trade -NVL(od.secureamt,0)+NVL(od.sereceiving,0),GETAVLSEWITHDRAW(SE.ACCTNO)) AMT_CHK

FROM TBLTRFSTOCK TRF, SBSECURITIES SB, AFMAST AF1, AFMAST AF2,CFMAST CF1, CFMAST CF2,SEMAST SE,
(SELECT SEACCTNO, SUM(SECUREAMT) SECUREAMT, SUM(SECUREMTG) SECUREMTG, SUM(RECEIVING) SERECEIVING
    FROM (SELECT OD.SEACCTNO,
            CASE WHEN OD.EXECTYPE IN (''NS'', ''SS'') AND OD.TXDATE =to_date(SY.VARVALUE,''DD/MM/YYYY'') THEN REMAINQTTY + EXECQTTY ELSE 0 END SECUREAMT,
            CASE WHEN OD.EXECTYPE = ''MS''  AND OD.TXDATE =to_date(SY.VARVALUE,''DD/MM/YYYY'') THEN REMAINQTTY + EXECQTTY ELSE 0 END SECUREMTG,
            CASE WHEN OD.EXECTYPE = ''NB'' THEN ST.QTTY ELSE 0 END RECEIVING
        FROM ODMAST OD, STSCHD ST, ODTYPE TYP, SYSVAR SY
        WHERE OD.DELTD <> ''Y''  AND OD.EXECTYPE IN (''NS'', ''SS'',''MS'', ''NB'')
            AND OD.ORDERID = ST.ORGORDERID(+) AND ST.DUETYPE(+) = ''RS''
            And OD.ACTYPE = TYP.ACTYPE
            AND SY.GRNAME = ''SYSTEM'' AND SY.VARNAME = ''CURRDATE''
            AND ((TYP.TRANDAY <= (SELECT SUM(CASE WHEN CLDR.HOLIDAY = ''Y'' THEN 0 ELSE 1 END)
            FROM SBCLDR CLDR
            WHERE CLDR.CLDRTYPE = ''000'' AND CLDR.SBDATE >= ST.TXDATE AND CLDR.SBDATE <= (select to_date(VARVALUE,''DD/MM/YYYY'') from sysvar where grname=''SYSTEM'' and varname=''CURRDATE'')) AND OD.EXECTYPE = ''NB'')
            OR OD.EXECTYPE IN (''NS'',''SS'',''MS'')))
    GROUP BY SEACCTNO ) od

WHERE TRF.SYMBOL=SB.SYMBOL AND TRF.AFACCTNO=AF1.ACCTNO AND TRF.AFACCTNO2=AF2.ACCTNO AND CF1.CUSTID = AF1.CUSTID
AND CF2.CUSTID=AF2.CUSTID AND NVL(TRF.STATUS,''N'') <>''A'' AND NVL(TRF.DELTD,''N'')<>''Y'' AND NVL(TRF.DELTD,''N'')<>''Y'' AND NVL(TRF.DELTD,''N'')<>''Y''
AND TRF.AFACCTNO || SB.CODEID = SE.ACCTNO
and SE.ACCTNO = OD.SEACCTNO (+)','SEMAST','frmSEMAST',null,'2242',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SE2282';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (27,'DESCRIPTION','DESCRIPTION','C','SE2282',100,null,'LIKE,=',null,'Y','Y','N',100,null,'DESCRIPTION','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (26,'NEEDQTTY','NEEDQTTY','N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'NEEDQTTY','N','96',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (25,'LICENSE2','LICENSE2','C','SE2282',100,null,'LIKE,=',null,'Y','Y','N',100,null,'ADDRESS2','N','95',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (24,'ADDRESS2','ADDRESS2','C','SE2282',100,null,'LIKE,=',null,'Y','Y','N',100,null,'ADDRESS2','N','94',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (23,'CUSTNAME2','CUSTNAME2','C','SE2282',100,null,'LIKE,=',null,'Y','Y','N',100,null,'CUSTNAME2','N','93',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (22,'LICENSE','LICENSE','C','SE2282',100,null,'LIKE,=',null,'Y','Y','N',100,null,'ADDRESS','N','92',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (21,'ADDRESS','ADDRESS','C','SE2282',100,null,'LIKE,=',null,'Y','Y','N',100,null,'ADDRESS','N','91',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (20,'CUSTNAME','CUSTNAME','C','SE2282',100,null,'LIKE,=',null,'Y','Y','N',100,null,'CUSTNAME','N','90',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (19,'TRTYPE','TRTYPE','C','SE2282',100,null,'LIKE,=',null,'Y','Y','N',100,null,'TRTYPE','N','31',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (18,'ORGTRADEWTF',null,'N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'ORGTRADEWTF','N','20',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (17,'ORGAMT',null,'N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'ORGAMT','N','19',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'AUTOID',null,'N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'AUTOID','N','18',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'DEPOBLOCK_CHK',null,'N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'DEPOBLOCK_CHK','N','17',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'CIDFPOFEEACR',null,'N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'CIDFPOFEEACR','N','15',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'QTTYTYPE','QTTYTYPE','C','SE2282',100,'c','LIKE,=','_','Y','Y','N',100,null,'QTTYTYPE','N','14',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'TRADEWTF',null,'N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'TRADEWTF','N','13',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'QTTY',null,'N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'QTTY','N','12',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'PARVALUE',null,'N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'PARVALUE','N','11',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'AMT','Số lượng','N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','Y','N','N',100,null,'AMT','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'AMT_CHK','Số lượng giao dịch','N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'AMT_CHK','N','21',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'PRICE','Giá','N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'PRICE','N','09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'DEPOBLOCK','Số dư bù trừ','N','SE2282',100,null,'<,<=,=,>=,>,<>','#,##0','N','N','N',100,null,'Netting','N','06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'ACCTNO2','Số tài khoản ghi Có','C','SE2282',100,'cccc.cccccc.cccccc','LIKE,=','_','Y','Y','Y',120,null,'Credit SE Account No','N','05',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'AFACCTNO2','Số Tiểu khoản ghi Có','C','SE2282',100,'cccc.cccccc','LIKE,=','_','Y','Y','N',100,null,'Credit contract','N','04',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'ACCTNO','Số tài khoản ghi Nợ','C','SE2282',100,'cccc.cccccc.cccccc','LIKE,=','_','Y','Y','N',120,null,'Debit SE Account No','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'AFACCTNO','Số Tiểu khoản ghi Nợ','C','SE2282',100,null,'LIKE,=','_','Y','Y','N',100,null,'Debit contract','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CODEID','Mã chứng khoán','C','SE2282',100,'cccccc','LIKE,=','_','N','N','N',100,null,'CODEID','N','01',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'SYMBOL','Chứng khoán','C','SE2282',100,'ccccccccccccccc','LIKE,=','_','Y','Y','N',100,null,'SYMBOL','N',null,null,'N',null,null,null,'N');
COMMIT;
/
