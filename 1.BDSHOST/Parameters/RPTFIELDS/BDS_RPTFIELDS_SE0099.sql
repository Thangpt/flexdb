﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'SE0099';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('SE','VERSION','SE0099','VERSION','Số chứng từ','Voucher no',1,'C','CCCCCCCCCC','_',10,null,null,null,'Y','N','Y',null,null,'Y','C',null,null,null,null,null,null,'CRBTRFLOG','SA',null,null,null,null,'Y','T');
COMMIT;
/
