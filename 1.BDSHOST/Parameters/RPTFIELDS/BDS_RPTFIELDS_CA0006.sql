﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'CA0006';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CA','V_CACODE','CA0006','CACODE','Mã CA','CA Code',0,'M','cccc.cccccc.cccccc','_',20,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'CAMAST','CA',null,null,null,null,'Y',null);
COMMIT;
/
