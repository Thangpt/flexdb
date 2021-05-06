﻿update fldmaster set DATATYPE = 'P' where objname = '0047' and defname = 'RPIN';
commit;

delete from fldmaster where OBJNAME = '1130';
delete from fldmaster where OBJNAME = '1111';
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '87', '1130', 'AVLCASH', 'Số tiền có thể chuyển', 'Available withdraw', 0, 'N', '#,##0', '#,##0', 19, ' ', ' ', '0', 'Y', 'Y', 'N', ' ', ' ', 'N', 'N', null, null, null, null, '##########', '03AVLCASH', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_AMT', 'Y', '0', 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '03', '1130', 'DRACCTNO', 'Số tài khoản ghi Nợ', 'Debit Account', 0, 'C', '9999.999999', '9999.999999', 16, ' ', 'Y', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', null, null, null, 'ACCTNO', '##########', null, 'CIMAST_ALL', 'CI', null, 'M', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '90', '1130', 'CUSTNAME', 'Họ tên', 'Fullname', 1, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', null, null, null, ' ', '03CUSTNAME', '03FULLNAME', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '91', '1130', 'ADDRESS', 'Địa chỉ', 'Address', 2, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', null, null, null, ' ', '03ADDRESS#', '03ADDRESS', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '92', '1130', 'LICENSE', 'CMND/GPKD', 'License', 3, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', null, null, null, ' ', '03LICENSE#', '03LICENSE', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '05', '1130', 'CRACCTNO', 'Số tài khoản ghi Có', 'Credit Account', 4, 'C', '9999.999999', '9999.999999', 16, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', null, null, null, 'ACCTNO', '##########', null, 'AFMAST_ALL', 'CF', null, 'M', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '93', '1130', 'CUSTNAME2', 'Họ tên', 'Fullname', 5, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', null, null, null, ' ', '##########', '05FULLNAME', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '10', '1130', 'AMT', 'Số tiền', 'Amount', 8, 'N', '#,##0', '#,##0', 19, ' ', ' ', '0', 'Y', 'N', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '25', '1130', 'FEETYPE', 'Biểu phí chuyển khoản', 'Fee type', 15, 'C', null, null, 5, 'SELECT FE.FEECD VALUECD, FE.FEECD VALUE,FE.FEENAME  DISPLAY,FE.FEENAME  EN_DISPLAY,FE.FEENAME DESCRIPTION
FROM FEEMASTER FE, FEEMAP FM WHERE FE.FEECD = FM.FEECD AND FM.TLTXCD =''1130'' ', ' ', '00012', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', null, null, null, null, '##########', null, null, null, null, 'M', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '15', '1130', 'FEEAMT', 'Phí chuyển tiền', 'Fee Amount', 16, 'N', '#,##0', '#,##0', 19, ' ', ' ', '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '16', '1130', 'TOTALAMT', 'Tổng tiền', 'Total amount', 16, 'N', '#,##0', '#,##0', 19, ' ', ' ', '0', 'Y', 'N', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '30', '1130', 'DESC', 'Mô tả', 'Description', 9, 'C', ' ', ' ', 250, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);


insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '03', '1111', 'ACCTNO', 'Số tài khoản ghi Nợ', 'Debit CI Account No', 1, 'C', '9999.999999', '9999.999999', 16, ' ', 'Y', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', null, null, null, 'ACCTNO', '##########', null, 'CIMAST_ALL', 'CI', null, 'M', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '05', '1111', 'BANKID', 'Bank id', 'Bank id', 5, 'C', ' ', ' ', 50, null, ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '09', '1111', 'IORO', 'Kiểu phí', 'Fee type', 9, 'C', '999999', '999999', 6, 'SELECT  A.CDVAL VALUECD, A.CDVAL VALUE, A.CDCONTENT
DISPLAY, A.CDCONTENT EN_DISPLAY, A.CDCONTENT DESCRIPTION
FROM ALLCODE A WHERE A.CDTYPE=''SA'' AND A.CDNAME=''IOROFEE''
ORDER BY A.LSTODR DESC', ' ', '0', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', null, null, null, 'CODEID', '##########', null, null, null, null, 'C', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '10', '1111', 'AMT', 'Số tiền', 'Amount', 12, 'N', '#,##0', '#,##0', 15, ' ', ' ', '0', 'Y', 'N', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '15', '1111', 'FEEAMT', 'Phí chuyển tiền', 'Fee Amount', 14, 'N', '#,##0', '#,##0', 19, ' ', ' ', '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '16', '1111', 'TOTALAMT', 'Tổng tiền', 'Total amount', 15, 'N', '#,##0', '#,##0', 19, ' ', ' ', '0', 'Y', 'N', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '30', '1111', 'DESC', 'Diễn giải', 'Description', 36, 'C', ' ', ' ', 250, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '35', '1111', 'FEETYPE', 'Biểu phí chuyển khoản', 'Fee type', 13, 'C', null, null, 5, 'SELECT FE.FEECD VALUECD, FE.FEECD VALUE,FE.FEENAME  DISPLAY,FE.FEENAME  EN_DISPLAY,FE.FEENAME DESCRIPTION
FROM FEEMASTER FE, FEEMAP FM WHERE FE.FEECD = FM.FEECD AND FM.TLTXCD =''1111'' ', ' ', '00012', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', null, null, null, null, '##########', null, null, null, null, 'M', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '66', '1111', '$FEECD', 'Biểu phí', 'Fee code', 10, 'C', null, null, 5, 'SELECT FEECD VALUECD, FEECD VALUE, FEENAME DISPLAY, FEENAME EN_DISPLAY, FEENAME DESCRIPTION FROM FEEMASTER WHERE FEECD IN (SELECT DISTINCT FEECD FROM FEEMAP WHERE TLTXCD=''<$TLTXCD>'')', ' ', ' ', 'N', 'N', 'N', ' ', ' ', 'Y', 'C', null, null, null, 'ACNAME', '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '80', '1111', 'BENEFBANK', 'Tên ngân hàng', 'Bank Name', 6, 'C', ' ', ' ', 50, null, ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '81', '1111', 'BENEFACCT', 'Số tài khoản thụ huởng', 'Beneficiary account number', 3, 'C', ' ', ' ', 100, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '82', '1111', 'BENEFCUSTNAME', 'Tên khách hàng nhận', 'Beneficiary customer name', 2, 'C', ' ', ' ', 100, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '83', '1111', 'BENEFLICENSE', 'Số CMT/Hộ chiếu thụ huởng', 'Beneficiary license no', 4, 'C', ' ', ' ', 15, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '84', '1111', 'CITYBANK', 'Chi nhánh NH', 'City Bank', 7, 'C', ' ', ' ', 50, null, ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '85', '1111', 'CITYEF', 'Thành phố', 'City Name', 8, 'C', ' ', ' ', 50, null, ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '89', '1111', 'CASTBAL', 'Số tiền có thể chuyển', 'Available withdraw', 11, 'N', '#,##0', '#,##0', 15, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'N', null, null, null, null, '##########', '03AVLCASH', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_AMT', 'Y', '0', 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '95', '1111', 'BENEFIDDATE', 'Ngày cấp thụ huởng', 'Beneficiary Issue Date', 5, 'C', '99/99/9999', '99/99/9999', 15, null, null, null, 'Y', 'Y', 'N', null, null, 'N', 'D', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_BENEFIDDATE', 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '96', '1111', 'BENEFIDPLACE', 'Noi cấp thụ huởng', 'Beneficiary Issue Place', 26, 'C', null, null, 50, null, null, null, 'N', 'Y', 'N', null, null, 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_BENEFIDPLACE', 'Y', null, 'N', null, null, null);

commit;