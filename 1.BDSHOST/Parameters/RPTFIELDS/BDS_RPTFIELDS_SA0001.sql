﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'SA0001';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('SA','AUTHID','SA0001','AUTHID','Mã nhóm người sử dụng','GroupID',0,'M','cccc','_',4,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'TLGROUPS','SA',null,null,null,null,'Y','T');
COMMIT;
/
