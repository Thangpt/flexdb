--
--
/
DELETE OBJMASTER WHERE OBJNAME = 'SA.ICCFTYPESCHDMAP';
INSERT INTO OBJMASTER (MODCODE,OBJNAME,OBJTITLE,EN_OBJTITLE,USEAUTOID,CAREBYCHK,OBJBUTTONS)
VALUES ('SA','SA.ICCFTYPESCHDMAP','Gán lịch biểu lãi tiền gửi với loại hình tiền gửi','Gán lịch biểu lãi tiền gửi với loại hình tiền gửi','Y','N','NNNNYYY');
COMMIT;
/
--
--
/
DELETE GRMASTER WHERE OBJNAME = 'SA.ICCFTYPESCHDMAP';
INSERT INTO GRMASTER (MODCODE,OBJNAME,ODRNUM,GRNAME,GRTYPE,GRBUTTONS,GRCAPTION,EN_GRCAPTION,CAREBYCHK,SEARCHCODE)
VALUES ('SA','SA.ICCFTYPESCHDMAP','0','MAIN','N','NNNNNNNN','TT chung','Common','N',null);
COMMIT;
/
--
--
/
DELETE FLDMASTER WHERE OBJNAME = 'SA.ICCFTYPESCHDMAP';
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('SA','ACTYPE','SA.ICCFTYPESCHDMAP','ACTYPE','Loại hình','Business product type',2,'T',null,null,10,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'CITYPE','CI',null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('SA','REFID','SA.ICCFTYPESCHDMAP','REFID','Mã tham chiếu','Reference ID',1,'T',null,null,20,null,null,'<$PARENTID>','Y','Y','Y',null,null,'N','C',null,null,null,null,null,null,'ICCFTYPESCHD','SA',null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('SA','AUTOID','SA.ICCFTYPESCHDMAP','AUTOID','Mã quản lý','Auto ID',0,'T',null,null,10,null,null,null,'N','N','N',null,null,'N','C',null,null,null,null,null,null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
COMMIT;
/
