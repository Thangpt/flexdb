﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'RE0072_1';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('RE','PV_TLID','RE0072_1','PV_TLID','Ma giao dich vien','ma giao dich vien',7,'M','cccc','_',10,null,null,'<$TLID>','N','Y','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('RE','GROUPID','RE0072_1','GROUPID','Mã Nhóm','RE Group code',6,'M','cccccc',null,10,null,null,'ALL','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'REGRPLNK_RF','RE',null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('RE','C_DATE','RE0072_1','C_DATE','Mở đến ngày','Close date',5,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','N','N','N',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'N',null);
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('RE','O_DATE','RE0072_1','O_DATE','Mở từ ngày','Open date',4,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','N','N','N',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'N',null);
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('RE','T_AMOUNT','RE0072_1','T_AMOUNT','GT cao nhất','To Amount',3,'M','9999999999999','9999999999999',20,null,null,'1000000000000','N','N','N',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'N',null);
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('RE','F_AMOUNT','RE0072_1','F_AMOUNT','GT thấp nhất','From Amount',2,'M','9999999999999','9999999999999',20,null,null,'0','N','N','N',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'N',null);
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('RE','RECUSTID','RE0072_1','RECUSTID','Mã NV môi giới','Custody code',1,'M','cccc.cccccc','_',10,null,null,'ALL','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'RECFLNK_RF','RE',null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('RE','FREEORAMOUNT','RE0072_1','FREEORAMOUNT','Phân loại theo','Free or amount',0,'M',null,'_',50,'
SELECT ''0'' VALUECD, ''0'' VALUE, ''Tổng GT tài khoản'' DISPLAY FROM DUAL
UNION ALL
SELECT ''1'' VALUECD, ''1'' VALUE, ''Cổ phiếu'' DISPLAY FROM DUAL
UNION ALL
SELECT ''2'' VALUECD, ''1'' VALUE, ''Tiền mặt'' DISPLAY FROM DUAL
',null,null,'N','N','N',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'N','C');
COMMIT;
/
