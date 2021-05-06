--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'LN0050';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','GUARANTYPE','LN0050','GUARANTYPE','Loại bảo lãnh','Service name',2,'M',null,null,20,'select ''ALL'' Value , ''ALL'' DISPLAY from dual
Union select ''0'' Value , ''T0'' DISPLAY from dual
Union select ''1'' Value , ''T1'' DISPLAY from dual
Union select ''2'' Value , ''T2'' DISPLAY from dual
Union select ''3'' Value , ''T3'' DISPLAY from dual
Union select ''4'' Value , ''T4'' DISPLAY from dual
Union select ''5'' Value , ''T5'' DISPLAY  from dual
Union select ''6'' Value , ''T6'' DISPLAY from dual
Union select ''7'' Value , ''T7'' DISPLAY from dual
Union select ''8'' Value , ''T8'' DISPLAY from dual ORDER by DISPLAY ',null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','I_DATE','LN0050','I_DATE','Ngày giao dịch','From date',0,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','Y','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'Y',null);
COMMIT;
/
