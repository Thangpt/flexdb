﻿--
/
DELETE rptfields WHERE objname='DNTKCK';
insert into rptfields (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE)
values ('CF', 'PV_AUTOID', 'DNTKCK', 'PV_AUTOID', 'Mã đăng ký', 'Auto Id', 1, 'M', 'cccccccccc', '_', 10, null, null, null, 'Y', 'N', 'Y', null, null, 'N', 'C', null, null, null, null, null, null, 'CF4000', 'CF', null, null, null, null, 'Y', 'T');
COMMIT;
