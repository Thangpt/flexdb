--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'TD0021';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('TD','LOANTYPE','TD0021','LOANTYPE','Kieu lai ','Loan type',3,'M','cc','_',3,'SELECT ''01'' VALUE , ''01'' VALUECD, ''Tinh den ngay loc bao cao'' DISPLAY, ''Tinh den ngay loc bao cao'' DESCRIPTION FROM dual union all SELECT ''02'' VALUE , ''02'' VALUECD, ''Tinh den ngay het ky han gui'' DISPLAY, ''Tinh den ngay het ky han gui'' DESCRIPTION FROM dual ',null,'01','Y','N','Y',null,null,'Y','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('TD','ACTYPE','TD0021','ACTYPE','Ma loai hinh','Product code',2,'M','cccc','_',4,'SELECT * FROM (SELECT TYP.ACTYPE VALUECD, TYP.ACTYPE VALUE, TYP.TYPENAME DISPLAY, TYP.TYPENAME EN_DISPLAY, TYP.DESCRIPTION
  FROM TDTYPE TYP, ALLCODE A0, ALLCODE A1, ALLCODE A2
  WHERE A0.CDTYPE=''TD'' AND A0.CDNAME=''TERMCD'' AND A0.CDVAL=TYP.TERMCD
  AND A1.CDTYPE=''TD'' AND A1.CDNAME=''SCHDTYPE'' AND A1.CDVAL=TYP.SCHDTYPE
  AND A2.CDTYPE=''TD'' AND A2.CDNAME=''TDSRC'' AND A2.CDVAL=TYP.TDSRC AND TYP.APPRV_STS = ''A''
      UNION ALL
 SELECT ''ALL'' VALUECD, ''ALL'' VALUE, ''Tat ca'' DISPLAY, ''All_product_code'' EN_DISPLAY, ''All_product_code'' DESCRIPTION FROM DUAL) ORDER BY VALUECD',null,'ALL','Y','N','Y',null,null,'Y','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('TD','AFACCTNO','TD0021','AFACCTNO','So hop dong ','Contract number',1,'M','cccccccccc','_',10,null,null,'ALL','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'AFMAST','CF',null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('TD','I_DATE','TD0021','I_DATE','Den ngay','In date',0,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','Y','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
COMMIT;
/
