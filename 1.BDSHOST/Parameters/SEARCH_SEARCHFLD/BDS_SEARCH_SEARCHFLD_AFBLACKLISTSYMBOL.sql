﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'AFBLACKLISTSYMBOL';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('AFBLACKLISTSYMBOL','Danh sách tài khoản được mua Blacklist có cấp bảo lãnh','Danh sách tài khoản được mua Blacklist có cấp bảo lãnh','
SELECT * FROM (SELECT RF.AUTOID, RF.REFSYMBOL, RF.AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TYP.TYPENAME AFTYPE
FROM AFBLACKLISTSYMBOL RF, CFMAST CF, AFMAST AF, AFTYPE TYP
WHERE RF.REFSYMBOL=''<$KEYVAL>'' AND RF.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND AF.ACTYPE=TYP.ACTYPE
ORDER BY CF.CUSTODYCD, RF.AFACCTNO) WHERE 0 = 0
','MR.AFBLACKLISTSYMBOL','frmAFBLACKLISTSYMBOL',null,null,null,50,'N',0,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'AFBLACKLISTSYMBOL';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'AFTYPE','Loại hình','C','AFBLACKLISTSYMBOL',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Product code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'AFACCTNO','Số tiểu khoản','C','AFBLACKLISTSYMBOL',100,null,'LIKE','_','Y','Y','N',100,null,'Account No','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'FULLNAME','Tên KH','C','AFBLACKLISTSYMBOL',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Customer name','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CUSTODYCD','Số TK lưu ký','C','AFBLACKLISTSYMBOL',100,null,'LIKE,=','_','Y','Y','N',120,null,'CUSTODYCD','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Mã quản lý','N','AFBLACKLISTSYMBOL',20,null,'=,<>,<,<=,>=,>',null,'N','Y','Y',100,null,'Auto ID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
