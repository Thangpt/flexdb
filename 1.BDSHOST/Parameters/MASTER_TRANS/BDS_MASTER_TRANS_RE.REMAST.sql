﻿--
--
/
DELETE OBJMASTER WHERE OBJNAME = 'RE.REMAST';
INSERT INTO OBJMASTER (MODCODE,OBJNAME,OBJTITLE,EN_OBJTITLE,USEAUTOID,CAREBYCHK,OBJBUTTONS)
VALUES ('RE','RE.REMAST','Tài khoản đại lý/môi giới','Remiser account','N','N','NNNNYYY');
COMMIT;
/
--
--
/
DELETE GRMASTER WHERE OBJNAME = 'RE.REMAST';
INSERT INTO GRMASTER (MODCODE,OBJNAME,ODRNUM,GRNAME,GRTYPE,GRBUTTONS,GRCAPTION,EN_GRCAPTION,CAREBYCHK,SEARCHCODE)
VALUES ('RE','RE.REMAST','1','REAFLNK','G','ENENNNNN','Tiểu khoản khách hàng','Customer sub-account','N','REAFLNK');
INSERT INTO GRMASTER (MODCODE,OBJNAME,ODRNUM,GRNAME,GRTYPE,GRBUTTONS,GRCAPTION,EN_GRCAPTION,CAREBYCHK,SEARCHCODE)
VALUES ('RE','RE.REMAST','0','MAIN','N','NNNNNNNN','TT chung','Common','N',null);
COMMIT;
/
--
--
/
DELETE FLDMASTER WHERE OBJNAME = 'RE.REMAST';
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('RE','INDIRECTACR','RE.REMAST','INDIRECTACR','Doanh thu gián tiếp','InDirect',10,'T',null,'#,##0',20,null,null,'0','Y','Y','Y',null,null,'N','N',null,null,null,null,null,null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'N','0','N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('RE','DIRECTACR','RE.REMAST','DIRECTACR','Doanh thu trực tiếp','Direct amount',9,'T',null,'#,##0',20,null,null,'0','Y','Y','Y',null,null,'N','N',null,null,null,null,null,null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'N','0','N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('RE','BALANCE','RE.REMAST','BALANCE','Số dư','Balance',5,'T',null,'#,##0',20,null,null,'0','Y','Y','Y',null,null,'N','N',null,null,null,null,null,null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'N','0','N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('RE','STATUS','RE.REMAST','STATUS','Trạng thái','Status',4,'C',null,null,3,'SELECT  CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''RE'' AND CDNAME = ''STATUS'' ORDER BY LSTODR',null,'P','Y','Y','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,'C','Y','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('RE','CUSTID','RE.REMAST','CUSTID','Môi giới','Broker/Remiser',2,'C','9999.999999','9999.999999',10,null,null,null,'Y','Y','Y',null,null,'N','C',null,null,null,null,null,null,'CFMAST_RE','CF',null,'M','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('RE','ACCTNO','RE.REMAST','ACCTNO','Số tài khoản','Account number',1,'C','9999.999999','9999.999999',10,null,null,null,'Y','Y','Y',null,null,'N','C','REACCTNO',null,null,null,null,null,null,null,'<$BRID>[000000]','M','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('RE','ACTYPE','RE.REMAST','ACTYPE','Mã loại hình','Product',0,'C','9999','9999',4,'SELECT ACTYPE VALUECD, ACTYPE VALUE, TYPENAME DISPLAY,
TYPENAME EN_DISPLAY, TYPENAME DESCRIPTION, RATECOMM FROM
RETYPE WHERE APPRV_STS = ''A''',null,null,'Y','Y','Y',null,null,'Y','C',null,null,null,null,null,null,null,null,null,'M','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
COMMIT;
/