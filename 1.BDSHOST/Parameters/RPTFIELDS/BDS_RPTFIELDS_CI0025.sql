﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'CI0025';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CI','TXNUM','CI0025','TXNUM','Mã HD ứng trước','TxNum',1,'M','CCCCCCCCCCCCCCCCCC','_',20,null,null,null,'Y','N','Y',null,null,'Y','C',null,null,null,null,null,null,'CIADINQ','CI',null,null,null,null,'Y','T');
COMMIT;
/
