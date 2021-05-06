﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'CA0022';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CA','POTXNUM','CA0022','POTXNUM','Số bảng kê','POTXNUM',2,'M','cccc.cccccc','_',10,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'PODETAILS_RP','CA',null,null,null,null,'Y','M');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CA','T_DATE','CA0022','T_DATE','Đến ngày','To date',1,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','N','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CA','F_DATE','CA0022','F_DATE','Từ ngày','From date',0,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','N','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
COMMIT;
/
