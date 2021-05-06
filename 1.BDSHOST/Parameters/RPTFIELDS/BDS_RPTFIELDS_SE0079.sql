﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'SE0079';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('SE','TXNUM','SE0079','TXNUM','Mã chứng từ','TXNUM',4,'M','CCCCCCCCCCCCCCCCCCCCCCCCCCCCC','_',21,null,null,null,'Y','N','N',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('SE','PLSENT','SE0079','PLSENT','Noi gửi','Place sent',3,'M',null,'_',50,'
SELECT ''Trung tâm Lưu ký Chứng khoán Việt Nam'' VALUECD, ''Trung tâm Lưu ký Chứng khoán Việt Nam'' VALUE, ''Trung tâm Lưu ký Chứng khoán Việt Nam'' DISPLAY FROM DUAL
UNION ALL
SELECT ''Chi nhánh Trung tâm Lưu ký Chứng khoán Việt Nam'' VALUECD, ''Chi nhánh Trung tâm Lưu ký Chứng khoán Việt Nam'' VALUE, ''Chi nhánh Trung tâm Lưu ký Chứng khoán Việt Nam'' DISPLAY FROM DUAL',null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('SE','PV_VOUCHER','SE0079','PV_VOUCHER','Chọn bảng kê','Voucher List',2,'M','CCCC/CC_CC/CCCCCC/CCC','_',21,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'CRBVOUCHERSE','CI',null,null,null,null,'Y','T');
COMMIT;
/
