﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CUSTODYCD_VIP';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CUSTODYCD_VIP','Tra cứu nhanh thông tin khách hàng','Customer information','SELECT format_custid(CF.CUSTID) CUSTID, case when CF.CUSTODYCD is null then '''' else CF.CUSTODYCD end CUSTODYCD, AF.ACCTNO, AFT.TYPENAME, CF.FULLNAME, CF.ADDRESS, CF.PHONE, CF.MOBILE, CF.FAX, CF.EMAIL, CF.IDCODE, CF.IDDATE, CF.IDPLACE FROM CFMAST CF, AFMAST AF, AFTYPE AFT WHERE CF.CUSTID = AF.CUSTID AND AF.ACTYPE = AFT.ACTYPE','CUSTODYCD_VIP',null,null,null,0,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CUSTODYCD_VIP';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'EMAIL','Email','C','CUSTODYCD_VIP',100,null,'LIKE,=',null,'Y','Y','N',100,null,'EMAIL','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'ADDRESS','Địa chỉ','C','CUSTODYCD_VIP',100,null,'LIKE,=',null,'Y','Y','N',100,null,'ADDRESS','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'FULLNAME','Họ tên','C','CUSTODYCD_VIP',100,null,'LIKE,=',null,'Y','Y','N',100,null,'FULLNAME','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'ACCTNO','Số tiểu khoản','C','CUSTODYCD_VIP',100,null,'LIKE,=',null,'Y','Y','N',100,null,'ACCTNO','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CUSTODYCD','Số lưu ký','C','CUSTODYCD_VIP',100,null,'LIKE,=',null,'Y','Y','N',100,null,'CUSTODYCD','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CUSTID','Mã khách hàng','C','CUSTODYCD_VIP',100,null,'LIKE,=',null,'Y','Y','Y',100,null,'CUSTID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
