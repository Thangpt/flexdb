﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'DF0046';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CI','PV_VOUCHER','DF0046','PV_VOUCHER','Chọn bảng kê','Voucher List',2,'M','CCCC/CC_CC/CCCCCC/CCC','_',21,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'CRBVOUCHER','CI',null,null,null,null,'Y','T');
COMMIT;
/
