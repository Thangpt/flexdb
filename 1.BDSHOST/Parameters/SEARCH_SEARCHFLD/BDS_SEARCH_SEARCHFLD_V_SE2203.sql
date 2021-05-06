﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'V_SE2203';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('V_SE2203','Danh sách import giao dịch giải tỏa phong tỏa chứng khoán (2203)','View pending unblock securities (wait for 2203)','
select mst.*, least(dtl_qtty,dfqtty ) dtl_dfqtty from
(
    SELECT TBL.AUTOID,SB.CODEID,SB.SYMBOL,TBL.AFACCTNO,TBL.ACCTNO,
    CF.FULLNAME CUSTNAME, CF.ADDRESS,CF.IDCODE LICENSE, TBL.QTTYTYPE,
    SE.BLOCKED AMT,SB.PARVALUE,TBL.DFAMT,TBL.TRADEAMT,TBL.DFAAMT,DTL.TXDATE,
    DTL.TXNUM,TBL.PRICE,TBL.DES,
    FN_2203_ALLOCATE(TBL.ACCTNO, TBL.QTTYTYPE,TBL.TRADEAMT,DTL.AUTOID) DTL_QTTY,
    DFQTTY, DTL.AUTOID DTL_AUTOID
    FROM TBLSE2203 TBL, SBSECURITIES SB, CFMAST CF, AFMAST AF, SEMAST SE,
    SEMASTDTL DTL
    WHERE  TBL.AFACCTNO = AF.ACCTNO AND TBL.SYMBOL = SB.SYMBOL
    AND TBL.ACCTNO = SE.ACCTNO AND CF.CUSTID =AF.CUSTID AND NVL(TBL.DELTD,''0'') <>''Y''
	/*
    AND TBL.AUTOID NOT IN (SELECT REFKEY FROM TLLOGEXT WHERE TLTXCD=''2203''
    AND DELTD=''N'' AND STATUS IN (''0'',''1'', ''3'',''4'') )
	*/
    AND TBL.ACCTNO = DTL.ACCTNO AND TBL.QTTYTYPE = DTL.QTTYTYPE
    AND DTL.DELTD <> ''Y'' AND DTL.QTTY>0
) MST WHERE DTL_QTTY>0 ','SEMAST','frmSEMAST',null,'2203',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'V_SE2203';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'DES','Mô tả','C','V_SE2203',250,null,'LIKE,=',null,'Y','Y','N',100,null,'Mô tả',null,'30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'PRICE','Giá','N','V_SE2203',9,null,'LIKE,=',null,'Y','Y','N',100,null,'Giá',null,'09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'TXNUM','Số chứng từ của GD Block CK','C','V_SE2203',10,null,'LIKE,=',null,'Y','Y','N',100,null,'Số chứng từ của GD Block CK',null,'07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'TXDATE','Ngày block chứng khoán','D','V_SE2203',10,null,'LIKE,=',null,'Y','Y','N',100,null,'Ngày block chứng khoán',null,'06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'DFAAMT','Số lượng DF','N','V_SE2203',9,null,'LIKE,=',null,'Y','Y','N',100,null,'Số lượng DF giải tỏa',null,null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'DTL_QTTY','Số lượng GD giải tỏa','N','V_SE2203',9,null,'LIKE,=',null,'Y','Y','N',100,null,'Số lượng GD giải tỏa',null,'10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'DTL_DFQTTY','Số lượng CK vay giai toa','N','V_SE2203',9,null,'LIKE,=',null,'Y','Y','N',100,null,'Số lượng CK vay',null,'15',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'PARVALUE','Mệnh giá','N','V_SE2203',9,null,'LIKE,=',null,'N','N','N',100,null,'Mệnh giá',null,'11',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'AMT','Số lượng phong toa','N','V_SE2203',9,null,'LIKE,=',null,'N','N','N',100,null,'Số lượng',null,null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'QTTYTYPE','Loại điều kiện','C','V_SE2203',15,null,'LIKE,=',null,'Y','Y','N',100,null,'Loại điều kiện',null,'12',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'LICENSE','Số giấy tờ','C','V_SE2203',50,null,'LIKE,=',null,'N','N','N',100,null,'Số giấy tờ',null,'92',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'ADDRESS','Địa chỉ','C','V_SE2203',50,null,'LIKE,=',null,'N','N','N',100,null,'Địa chỉ',null,'91',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'CUSTNAME','Họ tên','C','V_SE2203',50,null,'LIKE,=',null,'Y','Y','N',100,null,'Họ tên',null,'90',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'ACCTNO','Số tiểu khoản chứng khoán','C','V_SE2203',16,null,'LIKE,=',null,'N','N','N',100,null,'Số tiểu khoản chứng khoán',null,'03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'AFACCTNO','Số Tiểu khoản','C','V_SE2203',10,null,'LIKE,=',null,'Y','Y','N',100,null,'Số Tiểu khoản',null,'02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'SYMBOL','Symbol','C','V_SE2203',20,null,'LIKE,=',null,'Y','Y','N',100,null,'Symbol',null,null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'CODEID','Mã chứng khoán','C','V_SE2203',6,null,'LIKE,=',null,'Y','Y','N',100,null,'Mã chứng khoán',null,'01',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-1,'AUTOID','Số tự sinh','C','V_SE2203',20,null,'LIKE,=',null,'N','N','N',100,null,'Autoid',null,'00',null,'N',null,null,null,'N');
COMMIT;
/
