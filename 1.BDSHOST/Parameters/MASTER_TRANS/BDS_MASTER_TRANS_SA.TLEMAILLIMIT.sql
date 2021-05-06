
-- 1.6.0.0 - MSBS-2119: Them man hinh nguoi phe duyet


DELETE objmaster WHERE OBJNAME='SA.TLEMAILLIMIT';
insert into objmaster (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS)
values ('SA', 'SA.TLEMAILLIMIT', 'Người phê duyệt', 'User
Approver', 'Y', 'N', 'NNNNYYY');
COMMIT;


DELETE grmaster where objname='SA.TLEMAILLIMIT';
insert into grmaster (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE)
values ('SA', 'SA.TLEMAILLIMIT', 0, 'MAIN', 'N', 'NNNNNNNN', 'TT chung', 'Common', 'N', null);
COMMIT;


DELETE FLDMASTER WHERE OBJNAME='SA.TLEMAILLIMIT';
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'BRID', 'SA.TLEMAILLIMIT', 'BRID', 'Mã chi nhánh', 'BRID', 0, 'C', null, null, 4, null, null, '<$PARENTID>', 'Y', 'Y', 'Y', null, null, 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'EMAIL', 'SA.TLEMAILLIMIT', 'EMAIL', 'Email', 'Email', 3, 'T', null, null, 100, null, null, null, 'Y', 'Y', 'Y', null, null, 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'C', 'N', 'MAIN', 'TLID', null, 'SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION
FROM (SELECT tl.tlid FILTERCD, tl.email VALUE, tl.email VALUECD,
    tl.email DISPLAY, tl.email EN_DISPLAY, tl.email DESCRIPTION
FROM tlprofiles tl) WHERE FILTERCD=''<$TAGFIELD>'' ORDER BY VALUE
', 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'F_ADVANCELIMIT', 'SA.TLEMAILLIMIT', 'F_ADVANCELIMIT', 'Hạn mức tiền ứng ( Từ số tiền)', 'From Advance Limit', 4, 'T', '#,##0', '#,##0', 100, null, null, '<$SQL> select NVL(max(tl.t_advancelimit),0) DEFNAME from tlemaillimit tl where tl.brid=<$PARENTID>', 'Y', 'N', 'Y', null, null, 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'F_TOTALTRANLIMIT', 'SA.TLEMAILLIMIT', 'F_TOTALTRANLIMIT', 'Hạn mức tiền chuyển ( Từ số tiền)', 'From Total transfer limit', 6, 'T', '#,##0', '#,##0', 100, null, null, '<$SQL> select NVL(max(tl.t_totaltranlimit),0) DEFNAME from tlemaillimit tl where tl.brid=<$PARENTID>', 'Y', 'N', 'Y', null, null, 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'READVANCELIMIT', 'SA.TLEMAILLIMIT', 'READVANCELIMIT', 'Số tiền ứng còn lại được duyệt', null, 8, 'T', '#,##0', '#,##0', 100, null, null, null, 'N', 'Y', 'N', null, null, 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'RETOTALTRANLIMIT', 'SA.TLEMAILLIMIT', 'RETOTALTRANLIMIT', 'Số tiền chuyển còn lại được duyệt', null, 9, 'T', '#,##0', '#,##0', 100, null, null, null, 'N', 'Y', 'N', null, null, 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'TLID', 'SA.TLEMAILLIMIT', 'TLID', 'Mã User', 'USER', 0, 'M', 'cccc', '_', 4, null, null, null, 'Y', 'N', 'Y', null, null, 'N', 'C', null, null, null, 'TLID', '##########', null, 'TLPROFILES', 'SA', null, 'M', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'TLNAME', 'SA.TLEMAILLIMIT', 'TLNAME', 'Tên User', 'User name', 1, 'T', null, null, 100, null, null, null, 'Y', 'Y', 'Y', null, null, 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'C', 'N', 'MAIN', 'TLID', null, 'SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION
FROM (SELECT tl.tlid FILTERCD, tl.tlname VALUE, tl.tlname VALUECD,
    tl.tlname DISPLAY, tl.tlname EN_DISPLAY, tl.tlname DESCRIPTION
FROM tlprofiles tl) WHERE FILTERCD=''<$TAGFIELD>'' ORDER BY VALUE', 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'TLTITLE', 'SA.TLEMAILLIMIT', 'TLTITLE', 'Chức vụ', 'Job title', 2, 'T', null, null, 100, null, null, null, 'Y', 'Y', 'Y', null, null, 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'C', 'N', 'MAIN', 'TLID', null, 'SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION
FROM (SELECT tl.tlid FILTERCD, tl.TLTITLE VALUE, tl.TLTITLE VALUECD,
    nvl(a1.cdcontent,tl.TLTITLE) DISPLAY, nvl(a1.cdcontent,tl.TLTITLE) EN_DISPLAY, nvl(a1.cdcontent,tl.TLTITLE) DESCRIPTION
FROM tlprofiles tl, allcode a1 where tl.tltitle = a1.cdval(+) and a1.cdname(+) = ''TLTITLE'') WHERE FILTERCD=''<$TAGFIELD>'' ORDER BY VALUE', 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'T_ADVANCELIMIT', 'SA.TLEMAILLIMIT', 'T_ADVANCELIMIT', 'Hạn mức tiền ứng( Đến số tiền)', 'To Advance Limit', 5, 'T', '#,##0', '#,##0', 100, null, null, '0', 'Y', 'N', 'Y', null, null, 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'T_TOTALTRANLIMIT', 'SA.TLEMAILLIMIT', 'T_TOTALTRANLIMIT', 'Hạn mức tiền chuyển ( Đến số tiền)', 'To Total transfer limit', 7, 'T', '#,##0', '#,##0', 100, null, null, '0', 'Y', 'N', 'Y', null, null, 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'AUTOID', 'SA.TLEMAILLIMIT', 'AUTOID', 'Auto Id', 'Auto Id', -1, 'T', null, null, 0, null, null, null, 'N', 'Y', 'N', null, null, 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
COMMIT;



DELETE FLDVAL WHERE OBJNAME='SA.TLEMAILLIMIT';
insert into fldVAL (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('T_TOTALTRANLIMIT', 'SA.TLEMAILLIMIT', 3, 'V', '>=', '@0', null, 'Hạn mức tổng tiền chuyển phải lớn hơn hoặc bằng 0!', 'Total tranfer can not less than 0!', null, null, 0);
insert into fldVAL (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('F_ADVANCELIMIT', 'SA.TLEMAILLIMIT', 0, 'V', '>=', '@0', null, 'Hạn mức tiền ứng phải lớn hơn hoặc bằng 0!', 'Advance limit can not less than 0!', null, null, 0);
insert into fldVAL (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('F_TOTALTRANLIMIT', 'SA.TLEMAILLIMIT', 2, 'V', '>=', '@0', null, 'Hạn mức tổng tiền chuyển phải lớn hơn hoặc bằng 0!', 'Total tranfer can not less than 0!', null, null, 0);
insert into fldVAL (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('T_ADVANCELIMIT', 'SA.TLEMAILLIMIT', 4, 'V', '>>', 'F_ADVANCELIMIT', null, ' Đến số tiền phải lớn hơn số tiền!', null, null, null, 0);
insert into fldVAL (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('T_ADVANCELIMIT', 'SA.TLEMAILLIMIT', 1, 'V', '>=', '@0', null, 'Hạn mức tiền ứng phải lớn hơn hoặc bằng 0!', 'Advance limit can not less than 0!', null, null, 0);
insert into fldVAL (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('T_TOTALTRANLIMIT', 'SA.TLEMAILLIMIT', 5, 'V', '>>', 'F_TOTALTRANLIMIT', null, ' Đến số tiền phải lớn từ số tiền!', null, null, null, 0);
insert into fldVAL (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('READVANCELIMIT', 'SA.TLEMAILLIMIT', 6, 'E', 'EX', 'T_ADVANCELIMIT', null, null, null, null, null, 0);
insert into fldVAL (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('RETOTALTRANLIMIT', 'SA.TLEMAILLIMIT', 7, 'E', 'EX', 'T_TOTALTRANLIMIT', null, null, null, null, null, 0);
COMMIT;
