--
--
/
DELETE objmaster WHERE objname = 'SA.NAVMANAGE';
insert into objmaster (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS)
values ('SA', 'SA.NAVMANAGE', 'Khai báo kỳ đánh giá khách hàng', 'NAV management', 'N', 'N', 'NNNNYYY');
COMMIT;
--
--
/
DELETE grmaster WHERE objname = 'SA.NAVMANAGE';
insert into grmaster (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE)
values ('SA', 'SA.NAVMANAGE', 0, 'MAIN', 'N', 'NNNNNNNN', 'TT chung', 'Common', 'N', null);
COMMIT;
--
--
/
DELETE fldmaster WHERE objname = 'SA.NAVMANAGE';
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'NAVID', 'SA.NAVMANAGE', 'NAVID', 'Mã kỳ đánh giá', 'Nav id', 0, 'C', '9999', '9999', 4, null, null, null, 'Y', 'N', 'Y', null, null, 'N', 'C', 'NAVID', null, null, null, null, null, null, null, '[0000]', 'M', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'FRDATE', 'SA.NAVMANAGE', 'FRDATE', 'Từ ngày', 'from date', 3, 'C', '99/99/9999', 'dd/MM/yyyy', 10, null, null, '<$BUSDATE>', 'Y', 'N', 'Y', null, null, 'N', 'D', null, null, null, null, null, null, null, null, null, 'M', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'TODATE', 'SA.NAVMANAGE', 'TODATE', 'Đến ngày', 'To date', 6, 'C', '99/99/9999', 'dd/MM/yyyy', 10, null, null, '<$BUSDATE>', 'Y', 'N', 'Y', null, null, 'N', 'D', null, null, null, null, null, null, null, null, null, 'M', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'AVLNAV', 'SA.NAVMANAGE', 'AVLNAV', 'NAV trung bình', 'Avl nav', 12, 'N', '#,##0', '#,##0', 20, null, null, '0', 'Y', 'N', 'Y', null, null, 'N', 'N', null, null, null, null, null, null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'PRSTATUS', 'SA.NAVMANAGE', 'PRSTATUS', 'Trạng thái', 'Status', 14, 'C', null, null, 3, 'SELECT  CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''PRSTATUS'' ORDER BY LSTODR', null, 'A', 'Y', 'N', 'Y', null, null, 'N', 'C', null, null, null, null, null, null, null, null, null, 'C', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'STATUS', 'SA.NAVMANAGE', 'STATUS', 'Trạng thái duyệt', 'Status', 15, 'C', null, null, 3, 'SELECT  CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''STATUS'' ORDER BY LSTODR', null, 'P', 'Y', 'Y', 'Y', null, null, 'N', 'C', null, null, null, null, null, null, null, null, null, 'C', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', 'DESCRIPTION', 'SA.NAVMANAGE', 'DESCRIPTION', 'Diễn giải', 'Description', 18, 'C', null, null, 100, null, null, null, 'Y', 'N', 'Y', null, null, 'N', 'C', null, null, null, null, null, null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
COMMIT;
/
--
--
/
DELETE fldval WHERE objname = 'SA.NAVMANAGE';
insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('AVLNAV', 'SA.NAVMANAGE', 0, 'V', '>>', '@0', null, 'NAV trung bình phải lớn hơn 0!', 'Avk nav should be greater than zero!', null, null, 0);
insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('FRDATE', 'SA.NAVMANAGE', 3, 'V', '<=', 'TODATE', null, 'Từ ngày không được lớn hơn đến ngày!', 'To date should be greater than from date!', null, null, 0);
insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('FRDATE', 'SA.NAVMANAGE', 6, 'V', '==', '<$WORKDATE>', null, 'Từ ngày phải là ngày làm việc!', 'From date should be working date!', null, null, 0);
insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('TODATE', 'SA.NAVMANAGE', 9, 'V', '==', '<$WORKDATE>', null, 'Đến ngày phải là ngày làm việc!', 'To date should be working date!', null, null, 0);
insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('FRDATE', 'SA.NAVMANAGE', 12, 'V', '<=', '@<$BUSDATE>', null, 'Từ ngày phải nhỏ hơn hoặc bằng ngày hiện tại!', 'Begin date should be less than or equal current date!', null, null, 0);
insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('TODATE', 'SA.NAVMANAGE', 15, 'V', '<=', '@<$BUSDATE>', null, 'Đến ngày phải nhỏ hơn hoặc bằng ngày hiện tại!', 'To date should be less than or equal current date!', null, null, 0);
COMMIT;
/
