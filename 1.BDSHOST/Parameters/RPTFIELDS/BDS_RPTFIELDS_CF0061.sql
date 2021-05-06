﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'CF0061';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CF','OPNDATE','CF0061','OPNDATE','Xem theo','View by',4,'M','cccc','_',20,'SELECT ''ALL'' VALUE, ''ALL'' VALUEcd, ''ALL khách hàng'' DISPLAY,
''ALL khách hàng'' EN_DISPLAY,''ALL khách hàng'' DESCRIPTION FROM DUAL
UNION ALL
SELECT ''NEW'' VALUE, ''NEW'' VALUECD, ''KH mở mới trong kỳ'' DISPLAY, ''KH mở mới trong kỳ'' EN_DISPLAY,''KH mở mới trong kỳ'' DESCRIPTION FROM DUAL',null,'ALL','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CF','I_BRIDGD','CF0061','I_BRIDGD','Chi nhánh','Branch',3,'M','cccccccccc','_',10,'SELECT brid VALUE, brid display, brname en_display, brname description FROM (SELECT brid, brname, 1 lstodr FROM brgrp UNION SELECT ''ALL'' brid, ''ALL'' brname, -1 lstodr FROM DUAL) ORDER BY lstodr',null,'ALL','Y','N','Y',null,null,'Y','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CF','GRCAREBY','CF0061','GRCAREBY','Careby','Group care by',2,'M','cccc','_',5,'SELECT GRPID VALUE, GRPID VALUEcd,GRPNAME DISPLAY,
GRPNAME EN_DISPLAY,GRPNAME DESCRIPTION FROM (SELECT
GRPID, GRPNAME,1 LSTODR FROM TLGROUPS WHERE GRPTYPE =''2''
UNION SELECT''ALL'' TLID, ''ALL'' TLFULLNAME, -1 LSTODR FROM
DUAL) ORDER BY LSTODR',null,'ALL','Y','N','Y',null,null,'Y','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CF','TMONTH','CF0061','TMONTH','Đến tháng','T Month',1,'M','99/9999','MM/yyyy',7,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y',null);
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CF','FMONTH','CF0061','FMONTH','Từ tháng','F Month',0,'M','99/9999','MM/yyyy',7,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y',null);
COMMIT;
/
