﻿--
--
/
DELETE OBJMASTER WHERE OBJNAME = 'SA.AFDFBASKET';
INSERT INTO OBJMASTER (MODCODE,OBJNAME,OBJTITLE,EN_OBJTITLE,USEAUTOID,CAREBYCHK,OBJBUTTONS)
VALUES ('SA','SA.AFDFBASKET','Loại hình cầm cố/forward','InUsed mortage/forward product','Y','N','NNNNYYY');
COMMIT;
/
--
--
/
DELETE GRMASTER WHERE OBJNAME = 'SA.AFDFBASKET';
INSERT INTO GRMASTER (MODCODE,OBJNAME,ODRNUM,GRNAME,GRTYPE,GRBUTTONS,GRCAPTION,EN_GRCAPTION,CAREBYCHK,SEARCHCODE)
VALUES ('SA','SA.AFDFBASKET','0','MAIN','N','NNNNNNNN','TT chung','Common','N',null);
COMMIT;
/
--
--
/
DELETE FLDMASTER WHERE OBJNAME = 'SA.AFDFBASKET';
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('SA','EXPDATE','SA.AFDFBASKET','EXPDATE','Ngày hết hạn','Expired date',4,'C',null,null,20,null,null,'<$BUSDATE>','Y','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('SA','EFFDATE','SA.AFDFBASKET','EFFDATE','Ngày hiệu lực','Effective date',3,'C',null,null,20,null,null,'<$BUSDATE>','Y','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('SA','ACTYPE','SA.AFDFBASKET','ACTYPE','Loại hình cầm cố/forward','Mortgage/forward product type',2,'T',null,null,10,'SELECT ACTYPE VALUECD, ACTYPE VALUE, TYPENAME DISPLAY, TYPENAME EN_DISPLAY, TYPENAME DESCRIPTION FROM DFTYPE  WHERE STATUS=''Y'' ORDER BY ACTYPE',null,null,'Y','N','Y',null,null,'Y','C',null,null,null,null,null,null,null,null,null,'C','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('SA','BASKETID','SA.AFDFBASKET','BASKETID','Rổ chứng khoán','Basket ID',1,'C',null,null,20,null,null,'<$PARENTID>','Y','Y','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('SA','AUTOID','SA.AFDFBASKET','AUTOID','Mã quản lý','Auto ID',0,'T',null,null,10,null,null,null,'Y','N','N',null,null,'N','C',null,null,null,null,null,null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
COMMIT;
/
--
--
/
DELETE FLDVAL WHERE OBJNAME = 'SA.AFDFBASKET';
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('EFFDATE','SA.AFDFBASKET',0,'V','<<','EXPDATE',null,'Ngày hiệu lực phải sau ngày hết hạn!','Effective date should be before expired date!',null,null,'0');
COMMIT;
/
