﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'OD1005';
insert into RPTFIELDS (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE)
values ('OD', 'I_DATE', 'OD1005', 'I_DATE', 'In date', 'In date', 0, 'M', '99/99/9999', 'dd/MM/yyyy', 10, null, null, '<$BUSDATE>', 'Y', 'N', 'Y', null, null, 'N', 'D', null, null, null, null, null, null, null, null, null, null, null, null, 'Y', null);
insert into RPTFIELDS (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE)
values ('OD', 'CUSTODYCD', 'OD1005', 'CUSTODYCD', 'CUSTODYCD', 'Custody code', 1, 'M', 'cccc.cccccc', '_', 10, null, null, null, 'Y', 'N', 'N', null, null, 'N', 'C', null, null, null, null, null, null, 'CUSTODYCD_TX', 'OD', null, null, null, null, 'Y', 'T');
insert into RPTFIELDS (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE)
values ('OD', 'PRICETYPE', 'OD1005', 'PRICETYPE', 'Kiểu giá', 'Price type', 2, 'M', null, '_', 20, '
SELECT ''01'' VALUECD, ''01'' VALUE, ''Trung Bình'' DISPLAY FROM DUAL
UNION ALL
SELECT ''02'' VALUECD, ''02'' VALUE, ''Chi Tiết'' DISPLAY FROM DUAL
', null, 'ALL', 'Y', 'N', 'N', null, null, 'N', 'C', null, null, null, null, null, null, null, null, null, null, null, null, 'Y', 'C');
insert into RPTFIELDS (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE)
values ('OD', 'TLID', 'OD1005', 'TLID', 'Mã giao dịch viên', 'Mã giao dịch viên', 21, 'M', 'cccc', '_', 8, null, null, '<$TLID>', 'N', 'Y', 'N', null, null, 'N', 'C', null, null, null, null, null, null, null, null, null, null, null, null, 'Y', null);
COMMIT;
/
