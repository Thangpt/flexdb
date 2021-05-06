﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'RM0048';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('RM','PV_TXNUM','RM0048','PV_TXNUM','Số hiệu bảng kê','Version',2,'T','ccccccccccccccc','_',10,'SELECT VERSION VALUE, VERSION DISPLAY, VERSION EN_DISPLAY, VERSION DISCRIPTION FROM vw_crbtrflog_all ORDER BY AUTOID',null,null,'Y','Y','N',null,null,'N','C',null,null,null,null,null,null,null,'RM',null,'AUTOID','SELECT DISTINCT VERSION  FILTERCD , VERSION VALUE, VERSION VALUECD, VERSION DISPLAY, VERSION EN_DISPLAY, VERSION DESCRIPTION  FROM vw_crbtrflog_all WHERE AUTOID = UPPER(''<$TAGFIELD>'')',null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('RM','AUTOID','RM0048','PV_AUTOID','Số AUTOID','AUTOID',1,'M','9999999999','9999999999',10,null,null,'ALL','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'RMNUMBERLIST_RPT','RM',null,null,null,null,'Y','T');
COMMIT;
/
