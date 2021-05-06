﻿--
--
/
DELETE OBJMASTER WHERE OBJNAME = 'CF.AFPOLICYDTL';
INSERT INTO OBJMASTER (MODCODE,OBJNAME,OBJTITLE,EN_OBJTITLE,USEAUTOID,CAREBYCHK,OBJBUTTONS)
VALUES ('CF','CF.AFPOLICYDTL','Chi tiết chính sách đầu tư','Detail of investment policy for sub-account','Y','N','NNNNYYY');
COMMIT;
/
--
--
/
DELETE GRMASTER WHERE OBJNAME = 'CF.AFPOLICYDTL';
INSERT INTO GRMASTER (MODCODE,OBJNAME,ODRNUM,GRNAME,GRTYPE,GRBUTTONS,GRCAPTION,EN_GRCAPTION,CAREBYCHK,SEARCHCODE)
VALUES ('CF','CF.AFPOLICYDTL','0','MAIN','N','NNNNNNNN','TT chung','Common','N',null);
COMMIT;
/
--
--
/
DELETE FLDMASTER WHERE OBJNAME = 'CF.AFPOLICYDTL';
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','MAXVALUE','CF.AFPOLICYDTL','MAXVALUE','Giá trị tối đa','Maximum value',9,'N',null,'#,##0.#0',15,null,null,'0','Y','N','Y',null,null,'N','N',null,null,null,null,null,null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','MAXRATIO','CF.AFPOLICYDTL','MAXRATIO','Tỷ lệ tối đa (%)','Maximum ratio (%)',8,'N',null,'#,##0.#0',15,null,null,'100','Y','N','Y',null,null,'N','N',null,null,null,null,null,null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','CCYCD','CF.AFPOLICYDTL','CCYCD','Loại tiền','Currency',6,'C',null,null,10,'SELECT CCYCD VALUECD, CCYCD VALUE, SHORTCD DISPLAY FROM SBCURRENCY ORDER BY CCYCD',null,'00','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,'C','N','MAIN','ATYPE','[FX]',null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','CODEID','CF.AFPOLICYDTL','CODEID','Chứng khoán','Symbol',5,'C',null,null,10,'SELECT CODEID VALUECD, CODEID VALUE, SYMBOL DISPLAY FROM SBSECURITIES WHERE SECTYPE IN (''000'',''001'',''003'',''006'') ORDER BY SYMBOL',null,null,'Y','N','N',null,null,'N','C',null,null,null,null,null,null,null,null,null,'C','N','MAIN','ATYPE','[SE]',null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','SECTOR','CF.AFPOLICYDTL','SECTOR','Nghành nghề','Economic sector',4,'C',null,null,3,'SELECT  CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''ECONOMIC'' ORDER BY LSTODR',null,'000','Y','N','N',null,null,'N','C',null,null,null,null,null,null,null,null,null,'C','N','MAIN','ATYPE','[SE]',null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','TRADEPLACE','CF.AFPOLICYDTL','TRADEPLACE','Nơi giao dịch','Exchange',3,'C',null,null,3,'SELECT  CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''TRADEPLACE'' ORDER BY LSTODR',null,'000','Y','N','N',null,null,'N','C',null,null,null,null,null,null,null,null,null,'C','N','MAIN','ATYPE','[SE]',null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','ATYPE','CF.AFPOLICYDTL','ATYPE','Loại','Type',2,'C',null,null,3,'SELECT  CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''ATYPE'' ORDER BY LSTODR',null,'N','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,'C','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','MSTID','CF.AFPOLICYDTL','MSTID','Tên','Name',1,'C',null,null,50,null,null,'<$PARENTID>','Y','Y','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','AUTOID','CF.AFPOLICYDTL','AUTOID','Mã','Code',0,'N',null,null,4,null,null,null,'Y','Y','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,'M','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
COMMIT;
/
--
--
/
DELETE FLDVAL WHERE OBJNAME = 'CF.AFPOLICYDTL';
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('MAXVALUE','CF.AFPOLICYDTL',1,'V','>=','@0',null,'Giá trị phải lớn hơn 0','Value should be greater than zero',null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('MAXRATIO','CF.AFPOLICYDTL',0,'V','>=','@0',null,'Tỷ lệ phải lớn hơn 0','Ratio should be greater than zero',null,null,'0');
COMMIT;
/