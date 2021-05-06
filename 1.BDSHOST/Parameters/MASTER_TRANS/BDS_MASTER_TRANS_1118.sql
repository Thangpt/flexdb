--
--
-- 1.6.0.0- them trường TLID,READVANCE,RETRANFER

DELETE fldmaster WHERE objname = '1118';
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '01', '1118', 'AUTOID', 'Mã yêu cầu', 'Request ID', 0, 'C', null, null, 50, ' ', ' ', ' ', 'N', 'Y', 'N', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '02', '1118', 'AFACCTNO', 'Số tiểu khoản', 'Contract number sell', 2, 'C', '9999.999999', '9999.999999', 10, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, 'AFMAST_ALL', 'CF', null, 'M', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '14', '1118', 'AMOUNT', 'Số tiền chuyển ', 'Amount', 4, 'N', '#,##0', '#,##0', 20, ' ', ' ', '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '15', '1118', 'ADVAMT', 'Số tiền ứng trước cần chuyển', 'Avladvance', 5, 'N', '#,##0', '#,##0', 20, ' ', ' ', '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '16', '1118', 'CASHAMT', 'Số tiền mặt cần chuyển', 'Cash', 6, 'N', '#,##0', '#,##0', 20, ' ', ' ', '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '17', '1118', 'TOTALADVAM', 'Số tiền ứng đã chuyển', 'Total avladvance', 7, 'N', '#,##0', '#,##0', 20, ' ', ' ', '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '18', '1118', 'TOTALCASHAM', 'Số tiền mặt đã chuyển', 'Total cash', 8, 'N', '#,##0', '#,##0', 20, ' ', ' ', '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '19', '1118', 'ACTION', 'Loại thực hiện', 'Rate type', 15, 'C', null, null, 10, 'SELECT  CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY from ALLCODE WHERE CDTYPE=''CI'' AND CDNAME=''ACTION'' ORDER BY LSTODR', null, 'A', 'Y', 'N', 'Y', null, null, null, 'C', null, null, null, null, null, null, null, null, null, 'C', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '20', '1118', 'TLID', 'Người phê duyệt', 'Approver', 9, 'C', null, null, 10, null, null, null, 'Y', 'N', 'Y', null, null, 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'C', 'N', 'MAIN', '02', null, 'SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION
FROM (SELECT  af.acctno FILTERCD, E.TLID VALUE, E.TLID VALUECD,
     E.TLID || '': '' || E.TLNAME DISPLAY, E.TLID || '': '' || E.TLNAME EN_DISPLAY, E.Email DESCRIPTION
from  CFMAST CF, AFMAST AF,TLEMAILLIMIT E
WHERE  CF.Brid=E.Brid and CF.Custid=AF.Custid ) WHERE FILTERCD=''<$TAGFIELD>'' ORDER BY VALUE', 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '21', '1118', 'RETRANFER', 'Số tiền mặt CL được duyệt', 'The remaining transfer amount is approved', 11, 'N', '#,##0', '#,##0', 30, null, null, null, 'Y', 'Y', 'Y', null, null, 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '22', '1118', 'READVANCE', 'Số tiền ứng CL được duyệt', 'The remaining advance are approved', 10, 'N', '#,##0', '#,##0', 30, null, null, null, 'Y', 'Y', 'Y', null, null, 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '30', '1118', 'DESC', 'Diễn giải', 'Description', 16, 'C', ' ', ' ', 250, ' ', ' ', 'Giao dịch chuyển tiền ra ngân hàng vượt hạn mức', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CF', '31', '1118', 'FULLNAME', 'Họ tên', 'Customer name', 3, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '88', '1118', 'CUSTODYCD', 'Số tài khoản lưu ký', 'Custodycd code', 1, 'C', null, null, 10, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, 'CUSTODYCD_CF', 'CF', null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
COMMIT;

--
--
--1.6.0.0: 
/
DELETE FLDVAL WHERE OBJNAME = '1118';
insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('15', '1118', 2, 'V', '<=', '22', null, 'Vượt quá hạn mức ứng tiền còn lại của người duyệt!', 'Exceeds the approval limit of the approver!', null, null, 1);
insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('16', '1118', 3, 'V', '<=', '21', null, 'Vượt quá hạn mức chuyển tiền còn lại của người duyệt!', 'Exceeds the approval limit of the approver!', null, null, 1);
insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('22', '1118', 0, 'E', 'FX', 'fn_readvancelimit', '02##20', null, null, null, null, 0);
insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('21', '1118', 1, 'E', 'FX', 'fn_retotaltranlimit', '02##20', null, null, null, null, 0);
COMMIT;
/
--
--
--1.6.0.0: duyệt tai man hinh chinh
/
DELETE tltx WHERE tltxcd = '1118';
insert into tltx (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHKSINGLE)
values ('1118', 'Giao dịch chuyển tiền ra ngân hàng vượt hạn mức', 'Money transfer to the bank exceeds the limit', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'Y', ' ', 'Y', 'M', '1', 'Y', 'N', 'N', null, null, '14', '02', ' ', null, 0, 'Y', 'N', 'Y', 'N', null, '##', 'DB', 'N', null, null, null, 'N', '88', '31', 'Y', 'N');
COMMIT;
/
--
--
/
DELETE APPCHK WHERE TLTXCD = '1118';
COMMIT;
/
--
--
/
DELETE APPMAP WHERE TLTXCD = '1118';
COMMIT;
/
