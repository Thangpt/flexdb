﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'OD8829';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('OD8829','Tra cứu giao dịch điều chỉnh trả chậm','Adjust transfer buy amoutn','SELECT CF.CUSTODYCD, CF.FULLNAME, AF.ACCTNO AFACCTNO, STS.AUTOID, STS.ORGORDERID, STS.CODEID, STS.amt - STS.aamt AMT, STS.QTTY - STS.aqtty qtty,SB.SYMBOL,
round(case when STS.QTTY = 0 then 0 else STS.amt/ STS.QTTY end,0) MATCHPRICE, STS.TRFBUYEXT, STS.TRFBUYRATE, sts.cleardate, sts.trfbuydt,
least((sts.amt - sts.trfexeamt) * sts.trfbuyrate/100 + sts.amt * greatest(od.bratio - 100,0)/100, af.advanceline - nvl(b.trft0amt,0)) trfbuyamt,
sts.amt - sts.trfexeamt + sts.amt * greatest(od.bratio - 100,0)/100
    - least(sts.trfbuyrate/100*(sts.amt - sts.trfexeamt) + sts.amt * greatest(od.bratio - 100,0)/100, af.advanceline - nvl(b.trft0amt,0)) TRFSECUREAMT,
least(sts.trfbuyrate/100*(sts.amt - sts.trfexeamt) + sts.amt * greatest(od.bratio - 100,0)/100, af.advanceline - nvl(b.trft0amt,0)) TRFT0AMT, cd1.cdcontent MATCHTYPE
FROM STSCHD STS, ODMAST OD, AFMAST AF, CFMAST CF, SBSECURITIES SB, v_getbuyorderinfo b, allcode cd1
WHERE STS.AFACCTNO = AF.ACCTNO AND STS.DUETYPE = ''SM'' and sts.deltd <> ''Y'' AND AF.CUSTID = CF.CUSTID and STS.orgorderid = OD.ORDERID
/*AND ((STS.TRFBUYEXT > 0 and sts.trfbuyrate > 0) or af.corebank = ''Y'')*/
AND STS.CODEID = SB.CODEID and af.acctno = b.afacctno(+)
AND STS.TXDATE = (SELECT TO_DATE(VARVALUE,''DD/MM/RRRR'') FROM SYSVAR WHERE VARNAME = ''CURRDATE'')
and od.matchtype = cd1.cdval and cd1.cdname = ''MATCHTYPE'' and cd1.cdtype = ''OD''','SEMAST',null,null,'8829',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'OD8829';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (70,'TRFT0AMT','Trả chậm bảo lãnh','N','OD8829',100,null,'<,<=,=,>=,>','#,##0','N','N','N',100,null,'TRFBUYEXT','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (65,'TRFSECUREAMT','Giá trị cọc trả chậm trong ngày','N','OD8829',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'TRFBUYEXT','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (64,'TRFBUYAMT','Giá trị bảo lãnh trả chậm trong ngày','N','OD8829',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'TRFBUYAMT','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (60,'TRFBUYDT','Ngày dự kiến giải ngân','D','OD8829',100,null,'<,<=,=,>=,>',null,'Y','Y','N',100,null,'TRFBUYDT','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (55,'CLEARDATE','Ngày TTBT','D','OD8829',100,null,'<,<=,=,>=,>',null,'Y','Y','N',100,null,'CLEARDATE','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (50,'TRFBUYEXT','Số ngày trả chậm','N','OD8829',100,null,'<,<=,=,>=,>',null,'Y','Y','N',100,null,'TRFBUYEXT','N','15',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (45,'TRFBUYRATE','TL trả chậm','N','OD8829',100,null,'<,<=,=,>=,>',null,'Y','Y','N',100,null,'TRFBUYRATE','N','14',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (40,'FULLNAME','Tên khách hàng','C','OD8829',100,null,'LIKE,=',null,'Y','N','N',80,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (35,'AUTOID','Mã lịch thanh toán','N','OD8829',100,null,'<,<=,=,>=,>',null,'N','N','Y',100,null,'QUANTITY','N','01',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (30,'CODEID','Chứng khoán','C','OD8829',100,null,'=',null,'N','N','N',80,null,'Symbol','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (25,'MATCHPRICE','Giá khớp','N','OD8829',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',80,null,'PRICE','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (20,'QTTY','Số lượng CK','N','OD8829',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'QUANTITY','N','09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'MATCHTYPE','Loại lệnh','C','OD8829',100,null,'LIKE,=','_','Y','Y','N',100,'select cdval value, cdval valuecd, cdcontent description from allcode where cdname = ''MATCHTYPE'' and cdtype = ''OD''','CONTRAC NO','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'ORGORDERID','Số hiệu lệnh','C','OD8829',100,null,'LIKE,=','_','Y','Y','N',100,null,'CONTRAC NO','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'AFACCTNO','Mã Tiểu khoản','C','OD8829',100,null,'LIKE,=','_','Y','Y','N',100,null,'CONTRAC NO','N','04',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'SYMBOL','Chứng khoán','C','OD8829',100,null,'LIKE,=',null,'Y','N','N',80,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'CUSTODYCD','Số tài khoản lưu ký','C','OD8829',10,'ccc.c.cccccc','LIKE,=','_','Y','Y','N',100,null,'Custody code','N','02',null,'N',null,null,null,'N');
COMMIT;
/
