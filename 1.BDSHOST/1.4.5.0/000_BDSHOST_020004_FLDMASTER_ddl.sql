﻿--SELECT * FROM FLDMASTER WHERE OBJNAME ='SA.SBSECURITIES' AND fldname LIKE '011%';

DELETE FROM FLDMASTER WHERE OBJNAME ='SA.SBSECURITIES' AND fldname LIKE '011%';

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', '011COVEREDWARRANTTYPE', 'SA.SBSECURITIES', 'COVEREDWARRANTTYPE', 'Loại chứng quyền', 'Covered Warrant Type', 9.3, 'C', null, null, 5, 'SELECT  CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''CWTYPE'' ORDER BY LSTODR', null, null, 'Y', 'N', 'Y', null, null, 'N', 'C', null, null, null, null, null, null, null, null, null, 'C', 'N', 'MAIN', null, null, null, 'N', 'SECTYPE', 'Y', null, 'Y', '[011]', null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', '011CWTERM', 'SA.SBSECURITIES', 'CWTERM', 'Thời hạn CW theo tháng', 'Term CW (Month)', 9.65, 'T', null, '#,##0', 20, null, null, '6', 'Y', 'N', 'Y', null, null, 'N', 'N', null, null, null, null, null, null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'SECTYPE', 'Y', '0', 'Y', '[011]', null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', '011EXERCISEPRICE', 'SA.SBSECURITIES', 'EXERCISEPRICE', 'Giá thực hiện', 'Exercise Price', 9.5, 'T', null, '#,##0.###0', 20, null, null, '1', 'Y', 'N', 'Y', null, null, 'N', 'N', null, null, null, null, null, null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'SECTYPE', 'Y', '0', 'Y', '[011]', null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', '011EXERCISERATIO', 'SA.SBSECURITIES', 'EXERCISERATIO', 'Tỉ lệ thực hiện', 'Exercise Ratio', 9.6, 'T', null, '#,##0.###0', 20, null, null, '0', 'Y', 'N', 'Y', null, null, 'N', 'N', null, null, null, null, null, null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'SECTYPE', 'Y', null, 'Y', '[011]', null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', '011ISSUERNAME', 'SA.SBSECURITIES', 'ISSUERNAME', 'Tên TCPH CKCS', 'Issuer Name', 9.23, 'C', null, null, 100, null, null, null, 'Y', 'N', 'N', null, null, 'N', 'C', null, null, null, null, null, null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'SECTYPE', 'Y', null, 'Y', '[011]', null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', '011LASTTRADINGDATE', 'SA.SBSECURITIES', 'LASTTRADINGDATE', 'Ngày giao dịch cuối cùng', 'Last Trading Date', 9.8, 'D', '99/99/9999', 'dd/MM/yyyy', 10, null, null, '<$BUSDATE>', 'Y', 'N', 'Y', null, null, 'N', 'D', null, null, null, null, null, null, null, null, null, 'M', 'N', 'MAIN', null, null, null, 'N', 'SECTYPE', 'Y', null, 'Y', '[011]', null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', '011MATURITYDATE', 'SA.SBSECURITIES', 'MATURITYDATE', 'Ngày đáo hạn', 'Maturity Date', 9.7, 'D', '99/99/9999', 'dd/MM/yyyy', 10, null, null, '<$BUSDATE>', 'Y', 'N', 'Y', null, null, 'N', 'D', null, null, null, null, null, null, null, null, null, 'M', 'N', 'MAIN', null, null, null, 'N', 'SECTYPE', 'Y', null, 'Y', '[011]', null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', '011NVALUE', 'SA.SBSECURITIES', 'NVALUE', 'Hệ số nhân', 'Add Value', 9.9, 'T', '#,##0', '#,##0', 20, null, null, '1', 'Y', 'N', 'Y', null, null, 'N', 'N', null, null, null, null, null, null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'SECTYPE', 'Y', '0', 'Y', '[011]', null, null);

--insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
--values ('SA', '011SETTLEMENTPRICE', 'SA.SBSECURITIES', 'SETTLEMENTPRICE', 'Giá thanh toán', 'Settlement price', 9.41, 'C', null, null, 20, null, null, '1', 'Y', 'N', 'Y', null, null, 'N', 'N', null, null, null, null, null, null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'SECTYPE', 'Y', null, 'Y', '[011]', null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', '011SETTLEMENTTYPE', 'SA.SBSECURITIES', 'SETTLEMENTTYPE', 'Phương thức thanh toán', 'Settlement type', 9.4, 'C', null, null, 10, 'SELECT  CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''SETTLEMENTTYPE'' ORDER BY LSTODR', null, null, 'Y', 'N', 'Y', null, null, 'N', 'C', null, null, null, null, null, null, null, null, null, 'C', 'N', 'MAIN', null, null, null, 'N', 'SECTYPE', 'Y', null, 'Y', '[011]', null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', '011UNDERLYINGSYMBOL', 'SA.SBSECURITIES', 'UNDERLYINGSYMBOL', 'Mã CKCS', 'Underlying Symbol', 9.2, 'C', null, null, 10, null, null, null, 'Y', 'N', 'N', null, null, 'N', 'C', null, null, null, null, null, null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'SECTYPE', 'Y', null, 'Y', '[011]', null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('SA', '011UNDERLYINGTYPE', 'SA.SBSECURITIES', 'UNDERLYINGTYPE', 'Loại chứng khoán cơ sở', 'Underlying Type', 9.1, 'C', null, null, 4, 'SELECT  CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''UNDERLYINGTYPE'' ORDER BY LSTODR', null, null, 'Y', 'N', 'Y', null, null, 'N', 'C', null, null, null, null, null, null, null, null, null, 'C', 'N', 'MAIN', null, null, null, 'N', 'SECTYPE', 'Y', null, 'Y', '[011]', null, null);

COMMIT;
