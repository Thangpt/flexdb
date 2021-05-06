﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SEC_NAME';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SEC_NAME','Thông tin chứn khoán','Securities Info','SELECT SB.SYMBOL,SB.CODEID,ISS.FULLNAME  FROM SBSECURITIES SB, ISSUERS  ISS  WHERE  SB.ISSUERID = ISS.ISSUERID  ORDER BY SB.SYMBOL ','SA.SECURITIES_INFO','frmSECURITIES_TICKSIZE',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SEC_NAME';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'FULLNAME','Tên tổ chức phát hành','C','SEC_NAME',100,null,'LIKE,=',null,'Y','Y','N',180,null,'Fullname','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'SYMBOL','Chứng khoán','C','SEC_NAME',50,null,'LIKE,=',null,'Y','Y','N',100,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CODEID','Chứng khoán','C','SEC_NAME',50,null,'LIKE,=',null,'Y','Y','Y',100,null,'Symbol','N',null,null,'N',null,null,null,'N');
COMMIT;
/