﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'AFSELIMITGRP';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('AFSELIMITGRP', 'Danh sách tiểu khoản', 'List of sub-account', 'SELECT RF.AUTOID, RF.REFAUTOID, RF.AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TYP.TYPENAME,GRP_PRINUSED
FROM AFSELIMITGRP RF, CFMAST CF, AFMAST AF, AFTYPE TYP,v_getsecprgrpinfo v
WHERE RF.REFAUTOID=<$KEYVAL> AND RF.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND AF.ACTYPE=TYP.ACTYPE 
and v.afacctno =af.acctno and rf.refautoid = v.grp_code
ORDER BY CF.CUSTODYCD, RF.AFACCTNO', 'SA.AFSELIMITGRP', 'frmAFSELIMITGRP', null, null, 0, 50, 'N', 30, null, 'Y', 'T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'AFSELIMITGRP';
INSERT INTO searchfld (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY) 
VALUES(5,'GRP_PRINUSED','Hạn mức đã dùng','N','AFSELIMITGRP',200,NULL,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,NULL,'Used Margin limit','N',NULL,NULL,'N',NULL,NULL,NULL,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'TYPENAME','Loại hình','C','AFSELIMITGRP',100,null,'=,LIKE',null,'Y','Y','N',100,null,'Product','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'AFACCTNO','Số tiểu khoản','C','AFSELIMITGRP',100,null,'=,LIKE',null,'Y','Y','N',100,null,'Sub-account','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'FULLNAME','Tên KH','C','AFSELIMITGRP',100,null,'=,LIKE',null,'Y','Y','N',100,null,'Fullname','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CUSTODYCD','Số TK lưu ký','C','AFSELIMITGRP',100,null,'=,LIKE',null,'Y','Y','N',100,null,'Custody code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Mã quản lý','N','AFSELIMITGRP',20,null,'=,<>,<,<=,>=,>',null,'N','Y','Y',100,null,'Auto ID','N',null,null,'N',null,null,null,'N');
COMMIT;
/