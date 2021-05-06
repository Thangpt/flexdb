﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'CF1111';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CF','PLSENT','CF1111','PLSENT','Ðại diện MSBS','Place sent',3,'M',null,'_',50,'
select varname value, varname valuecd, varvalue || '' - '' || vardesc display, rownum lstord from sysvar where grname = ''REPRESENT'' and varname in (''KBSVREP01'',''KBSVREP02'',''KBSVREP03'') order by rownum
',null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CF','CFRELATION','CF1111','CFRELATION','UQ khách hàng','Sub account',2,'M','9999.999999','9999.999999',30,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,'##########',null,null,null,null,'CUSTODYCD','SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION FROM VW_CFRELATION_SUBACCOUNT WHERE FILTERCD=''<$TAGFIELD>'' ORDER BY VALUE',null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CF','PV_AFACCTNO','CF1111','PV_AFACCTNO','Số tiểu khoản','Sub account',1,'M','9999.999999','9999.999999',30,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,'AFACCTNO','##########',null,'CIMAST_ALL','CF',null,'CUSTODYCD','SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION FROM VW_CUSTODYCD_SUBACCOUNT WHERE FILTERCD=''<$TAGFIELD>'' ORDER BY VALUE',null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('CF','CUSTODYCD','CF1111','CUSTODYCD','Số tài khoản lưu ký','Custody code',0,'M','cccc.cccccc','cccc.cccccc',10,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,'CUSTODYCD','##########',null,'CUSTODYCD_CF','CF',null,null,null,null,'Y','T');
COMMIT;
/