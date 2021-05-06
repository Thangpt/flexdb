﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'CI0015';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CI','PV_CLEARDT','CI0015','PV_CLEARDT','Số ngày ứng tiền','Số ngày ứng tiền',5,'M','CCC','_',4,'
SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION, CDCONTENT EN_DESCRIPTION
FROM (SELECT ''ALL'' CDVAL, ''ALL'' CDCONTENT, 0 LSTODR FROM DUAL
UNION SELECT ''1'' CDVAL, ''1'' CDCONTENT, 1 LSTODR FROM DUAL
UNION SELECT ''2'' CDVAL, ''2'' CDCONTENT, 2 LSTODR FROM DUAL
UNION SELECT ''3'' CDVAL, ''3'' CDCONTENT, 3 LSTODR FROM DUAL
UNION SELECT ''4'' CDVAL, ''4'' CDCONTENT, 4 LSTODR FROM DUAL
UNION SELECT ''5'' CDVAL, ''5'' CDCONTENT, 5 LSTODR FROM DUAL
UNION SELECT ''6'' CDVAL, ''6'' CDCONTENT, 6 LSTODR FROM DUAL
UNION SELECT ''7'' CDVAL, ''7'' CDCONTENT, 7 LSTODR FROM DUAL
UNION SELECT ''8'' CDVAL, ''8'' CDCONTENT, 8 LSTODR FROM DUAL
UNION SELECT ''9'' CDVAL, ''9'' CDCONTENT, 9 LSTODR FROM DUAL
UNION SELECT ''10'' CDVAL, ''10'' CDCONTENT, 10 LSTODR FROM DUAL
UNION SELECT ''11'' CDVAL, ''11'' CDCONTENT, 11 LSTODR FROM DUAL
UNION SELECT ''12'' CDVAL, ''12'' CDCONTENT, 12 LSTODR FROM DUAL
) ORDER BY LSTODR
',null,'ALL','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CI','PV_ADVTYPE','CI0015','PV_ADVTYPE','Loại Ứng ','PV_ADVTYPE',5,'M','ccccccccccccc','_',16,'SELECT CDVAL VALUE,CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION
FROM
(
         SELECT ''ALL'' CDVAL, ''ALL'' CDCONTENT, -1 LSTODR FROM DUAL
     UNION SELECT ''N'' CDVAL, ''Thường'' CDCONTENT, 0 LSTODR FROM DUAL
     UNION SELECT ''B'' CDVAL, ''TT tiền mua'' CDCONTENT, 1 LSTODR FROM DUAL) ORDER BY LSTODR',null,'ALL','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CI','VIA','CI0015','VIA',' Kênh ','VIA',4,'M','cccc','_',5,'SELECT CDVAL VALUE,CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION
FROM (  SELECT CDVAL, CDCONTENT, LSTODR FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''VIA'' and cdval in (''O'',''F'') UNION SELECT ''ALL'' CDVAL, ''ALL'' CDCONTENT, -1 LSTODR FROM DUAL UNION SELECT ''A'' CDVAL, ''Auto'' CDCONTENT, 0 LSTODR FROM DUAL UNION SELECT ''FA'' CDVAL, ''AUTO,FLOOR'' CDCONTENT, 1 LSTODR FROM DUAL) ORDER BY LSTODR',null,'ALL','Y','N','Y',null,null,'Y','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y',null);
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CI','I_ADTYPE','CI0015','I_ADTYPE','Nguồn ứng trước','Advance payment bank',3,'M','cccc','_',4,'SELECT   actype VALUE, actype display, typename en_display, typename description
FROM (SELECT ad.actype, ad.typename, 1 lstodr FROM adtype ad UNION SELECT ''ALL'' actype, ''ALL'' typename, -1 lstodr FROM DUAL) ORDER BY lstodr
',null,'ALL','Y','N','Y',null,null,'Y','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CI','I_BRID','CI0015','I_BRID','Mã chi nhánh','Branch ID',2,'M','cccccccccc','_',10,'SELECT   brid VALUE, brid display, brname en_display, brname description FROM (SELECT brid, brname, 1 lstodr FROM brgrp UNION SELECT ''ALL'' brid, ''ALL'' brname, -1 lstodr FROM DUAL) ORDER BY lstodr',null,'ALL','Y','N','Y',null,null,'Y','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CI','T_DATE','CI0015','T_DATE','Đến ngày','To date',1,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','Y','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CI','F_DATE','CI0015','F_DATE','Từ ngày','From date',0,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','Y','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
COMMIT;
/
