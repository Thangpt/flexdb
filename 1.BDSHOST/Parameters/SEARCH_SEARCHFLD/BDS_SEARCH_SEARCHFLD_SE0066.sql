﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SE0066';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SE0066','Danh sách bảng kê chứng khoán giao dịch lô lẻ','Create request transfer money of advanced payment to bank','
SELECT MST.OBJNAME, MST.TXDATE, MST.OBJKEY, FN_CRB_GETVOUCHERNO(LG.TRFCODE, LG.TXDATE, LG.VERSION) VOUCHERNO,  A0.CDCONTENT DESC_STATUS,
MST.AFACCTNO, MST.BANKCODE, MST.BANKACCT, MST.STATUS, MST.TXAMT, RF.*
FROM CRBTXREQ MST, CRBTRFLOG LG, CRBTRFLOGDTL LGDTL, ALLCODE A0,
(SELECT *
FROM   (SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
        FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE MST.REQID=DTL.REQID )
PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN
(''QTTY'' as QTTY, ''LICENSE'' as LICENSE, ''IDDATE'' as IDDATE,
''CUSTNAME'' as CUSTNAME, ''CUSTODYCD'' as CUSTODYCD, ''BOARD'' as BOARD, ''SYMBOL'' as SYMBOL))
ORDER BY REQID) RF
WHERE MST.REQID=RF.REQID
AND LG.AUTOID = LGDTL.VERSION
AND LGDTL.REFREQID = MST.REQID
AND A0.CDTYPE=''RM'' AND A0.CDNAME=''TRFLOGSTS'' AND A0.CDVAL=LG.STATUS
AND LG.TRFCODE = ''SEODDLOT''','AAAA',null,null,null,null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SE0066';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'DESC_STATUS','Trạng thái bảng kê','C','SE0066',80,null,'LIKE,=',null,'Y','Y','N',100,null,'Status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'OBJKEY','Số chứng từ','C','SE0066',100,null,'LIKE,=',null,'Y','Y','N',100,null,'TxNum','N','21',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'VOUCHERNO','Số REF','C','SE0066',150,null,'LIKE,=',null,'Y','N','Y',150,null,'Voucher No','Y',null,null,null,null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'TXDATE','Ngày tạo bảng kê','D','SE0066',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'REQID','Số hiệu yêu cầu','C','SE0066',100,null,'LIKE,=',null,'N','Y','N',100,null,'Request ID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
