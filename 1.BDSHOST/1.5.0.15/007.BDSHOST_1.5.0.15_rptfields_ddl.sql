DELETE FROM rptfields WHERE objname = 'OD3001';

insert into rptfields (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE)
values ('OD', 'F_DATE', 'OD3001', 'F_DATE', 'Từ ngày', 'From date', 0, 'M', '99/99/9999', 'dd/MM/yyyy', 10, null, null, '<$BUSDATE>', 'Y', 'N', 'Y', null, null, 'N', 'D', null, null, null, null, null, null, null, null, null, null, null, null, 'Y', null);

insert into rptfields (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE)
values ('OD', 'T_DATE', 'OD3001', 'T_DATE', 'Ðến ngày', 'To date', 1, 'M', '99/99/9999', 'dd/MM/yyyy', 10, null, null, '<$BUSDATE>', 'Y', 'N', 'Y', null, null, 'N', 'D', null, null, null, null, null, null, null, null, null, null, null, null, 'Y', null);

insert into rptfields (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE)
values ('OD', 'PV_REGTYPE', 'OD3001', 'PV_REGTYPE', 'Đăng ký', 'Register type', 2, 'M', 'ccc', '_', 5, '
SELECT ''ALL'' VALUE,''ALL'' VALUECD, ''Tất cả'' DISPLAY, ''All'' EN_DISPLAY, ''Tất cả'' DESCRIPTION FROM dual
UNION ALL SELECT ''R'' VALUE,''R'' VALUECD, ''Đăng ký'' DISPLAY, ''Register'' EN_DISPLAY, ''Đăng ký'' DESCRIPTION FROM dual
union all SELECT ''C'' VALUE,''C'' VALUECD, ''Hủy đăng ký'' DISPLAY, ''Cancel register'' EN_DISPLAY, ''Hủy đăng ký'' DESCRIPTION from dual', null, 'ALL', 'Y', 'N', 'Y', null, null, 'Y', 'C', null, null, null, null, null, null, null, null, null, null, null, null, 'Y', null);

insert into rptfields (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE)
values ('OD', 'PV_CUSTODYCD', 'OD3001', 'PV_CUSTODYCD', 'Số TK lưu ký', 'Custody code', 3, 'M', 'cccc.cccccc', '_', 10, null, null, 'ALL', 'Y', 'N', 'N', null, null, 'N', 'C', null, null, null, null, null, null, 'CUSTODYCD_TX', 'CF', null, null, null, null, 'Y', 'T');

insert into rptfields (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE)
values ('OD', 'PV_AFACCTNO', 'OD3001', 'PV_AFACCTNO', 'Số tiểu khoản', 'Sub account', 4, 'T', 'cccc.cccccc', '_', 10, null, null, 'ALL', 'Y', 'N', 'N', null, null, 'N', 'C', null, null, null, null, null, null, 'AFMAST', 'CF', null, null, null, null, 'Y', 'T');

COMMIT;

