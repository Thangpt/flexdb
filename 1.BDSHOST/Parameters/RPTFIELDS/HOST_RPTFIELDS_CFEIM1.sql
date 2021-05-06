﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME='CFEIM1';
insert into rptfields (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE)
values ('CF', 'FROMDATE', 'CFEIM1', 'FROMDATE', 'Ngày', 'To date', 1, 'M', '99/99/9999', 'dd/MM/yyyy', 10, null, null, '<$BUSDATE>', 'Y', 'N', 'Y', null, null, 'N', 'D', null, null, null, null, null, null, null, null, null, null, null, null, 'Y', null);

insert into rptfields (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE)
values ('CF', 'CUSTODYCD', 'CFEIM1', 'pv_CUSTODYCD', 'Số TK luu ký', 'Custody code', 2, 'M', 'cccc.cccccc', '_', 10, null, null, null, 'Y', 'N', 'Y', null, null, 'N', 'C', null, null, null, null, null, null, 'CUSTODYCD_CF', 'CF', null, null, null, null, 'Y', 'T');
COMMIT;
/
