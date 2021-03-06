--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CFLIMITEXT';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CFLIMITEXT','NH - Quản lý hạn mức riêng cho từng khách hàng','Common credit limit of the bank','SELECT MST.AUTOID, MST.BANKID, MST.LMAMT,
CF.FULLNAME, CFCUST.FULLNAME CUSTNAME, A.CDCONTENT STATUS, A0.CDCONTENT DESC_LMTYP, A1.CDCONTENT DESC_LMSUBTYPE, A2.CDCONTENT DESC_LMCHKTYP
FROM CFLIMITEXT MST, CFMAST CFCUST, CFMAST CF, ALLCODE A, ALLCODE A0, ALLCODE A1, ALLCODE A2
WHERE MST.BANKID=CF.CUSTID AND MST.CUSTID=CFCUST.CUSTID
AND A.CDTYPE=''SY'' AND A.CDNAME=''APPRV_STS'' AND A.CDVAL=MST.STATUS
AND A0.CDTYPE=''CF'' AND A0.CDNAME=''LMTYP'' AND A0.CDVAL=MST.LMTYP
AND A1.CDTYPE=''CF'' AND A1.CDNAME=''LMSUBTYPE'' AND A1.CDVAL=MST.LMSUBTYPE
AND A2.CDTYPE=''CF'' AND A2.CDNAME=''LMCHKTYP'' AND A2.CDVAL=MST.LMCHKTYP ','CFLIMITEXT','frmCFLIMITEXT',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CFLIMITEXT';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'DESC_LMCHKTYP','Căn cứ số dư','C','CFLIMITEXT',100,null,'LIKE,=',null,'Y','Y','N',80,null,'Balance type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'DESC_LMSUBTYPE','Nghiệp vụ','C','CFLIMITEXT',100,null,'LIKE,=',null,'Y','Y','N',80,null,'Sub type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'DESC_LMTYP','Loại','C','CFLIMITEXT',100,null,'LIKE,=',null,'Y','Y','N',80,null,'Type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'STATUS','Trạng thái','C','CFLIMITEXT',100,null,'LIKE,=',null,'Y','Y','N',80,null,'Status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'LMAMT','Hạn mức','N','CFLIMITEXT',100,null,'>=,<=,=','#,##0','Y','Y','N',100,null,'Limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CUSTNAME','Tên KH','C','CFLIMITEXT',100,null,'LIKE,=',null,'Y','Y','N',200,null,'Customer name','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'FULLNAME','Tên NH','C','CFLIMITEXT',100,null,'LIKE,=',null,'Y','Y','N',200,null,'Bank name','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Mã quản lý','C','CFLIMITEXT',100,null,'LIKE,=',null,'N','N','Y',80,null,'AutoID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
