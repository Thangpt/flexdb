--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SASBFXRT';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SASBFXRT','Quan ly ty gia quy doi ngoai te','Currency exchange rate','SELECT DISTINCT AUTOID,SBCURRENCY.SHORTCD CCYCD, EDATE,A0.CDCONTENT RATENUM, RATEBCY, RATEUSD,RATELCY
FROM SBFXRT SBFXRT, ALLCODE A0,SBCURRENCY SBCURRENCY
WHERE A0.CDTYPE = ''SY'' and A0.CDNAME =''RATENUM'' AND A0.CDVAL = RATENUM and SBCURRENCY.CCYCD = SBFXRT.CCYCD and SBFXRT.CCYCD = ''<$KEYVAL>''','SA.SBFXRT','frmSBFXRT',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SASBFXRT';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'RATELCY','Tỷ giá tại bản địa','N','SASBFXRT',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',300,null,'Rate by local currency ','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'RATEUSD','Tỷ giá so với USD','N','SASBFXRT',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',80,null,'Rate by USD','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'RATEBCY','Tỷ giá so với loại tiền cơ sở','N','SASBFXRT',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',200,null,'Rate by based currency','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'RATENUM','Loại tỷ giá','C','SASBFXRT',100,'ccc','LIKE,=','_','Y','Y','N',100,null,'Rate type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'EDATE','Ngày cập nhật','D','SASBFXRT',100,'__/__/____','<,<=,=,>=,>,<>','##/##/####','Y','Y','N',150,null,'Effective date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CCYCD','Mã loại tiền','C','SASBFXRT',100,null,'LIKE,=',null,'Y','Y','N',100,'select CCYCD VALUE,SHORTCD DISPLAY from SBCURRENCY','Currency code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Trường tự sinh','C','SASBFXRT',100,null,'LIKE,=',null,'N','Y','Y',100,null,'Auto Id','N',null,null,'N',null,null,null,'N');
COMMIT;
/
