﻿--
--
/
DELETE FLDMASTER WHERE OBJNAME = '1201';
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '88', '1201', 'CUSTODYCD', 'Số TK lưu ký chuyển', 'Debit custody code', -6, 'C', null, null, 10, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', null, null, null, 'CUSTODYCD', '##########', null, 'CUSTODYCD_CF', 'CF', null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_CUSTODYCD', 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '03', '1201', 'DACCTNO', 'Số tiểu khoản chuyển', 'Debit sub account', -1, 'C', '9999.999999', '9999.999999', 25, ' ', 'Y', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', null, null, null, 'AFACCTNO', '##########', null, 'CIMAST_ALL', 'CI', null, 'C', 'N', 'MAIN', '88', null, 'SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION FROM VW_CUSTODYCD_SUBACCOUNT WHERE STATUS<>''C'' AND FILTERCD=''<$TAGFIELD>'' ORDER BY VALUE', 'N', 'P_ACCTNO', 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '31', '1201', 'FULLNAME', 'Họ tên người yêu cầu', 'Fullname', 1, 'C', null, null, 50, null, null, null, 'Y', 'Y', 'N', null, null, 'N', 'C', null, null, null, null, '##########', '88FULLNAME', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_FULLNAME', 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '92', '1201', 'LICENSE', 'CMND/GPKD', 'License', 3, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', null, null, null, ' ', '##########', '88IDCODE', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_LICENSE', 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '96', '1201', 'IDDATE', 'Ngày cấp', 'Issue Date', 4, 'C', '99/99/9999', '99/99/9999', 10, null, null, null, 'Y', 'Y', 'N', null, null, 'N', 'C', null, null, null, null, '##########', '88IDDATE', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_IDDATE', 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '89', '1201', 'CUSTODYCD', 'Số TK lưu ký nhận', 'Credit custody code', 6, 'C', null, null, 10, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', null, null, null, 'CUSTODYCD', '##########', null, 'CUSTODYCD_CF', 'CF', null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_CUSTODYCD2', 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '05', '1201', 'CACCTNO', 'Số tiểu khoản nhận', 'Credit sub account', 7, 'C', '9999.999999', '9999.999999', 19, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', null, null, null, 'AFACCTNO', '##########', null, 'CIMAST_ALL', 'CF', null, 'C', 'N', 'MAIN', '89', null, 'SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION FROM VW_CUSTODYCD_SUBACCOUNT WHERE STATUS <> ''C'' AND FILTERCD=''<$TAGFIELD>'' ORDER BY VALUE', 'N', 'P_ACCTNO2', 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '93', '1201', 'CUSTNAME2', 'Họ tên người nhận', 'Fullname', 8, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', null, null, null, ' ', '##########', '89FULLNAME', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_BENEFCUSTNAME', 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '95', '1201', 'LICENSE2', 'CMND/GPKD', 'License', 10, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', null, null, null, ' ', '##########', '89IDCODE', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_LICENSE2', 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '98', '1201', 'IDDATE2', 'Ngày cấp', 'Issue Date', 11, 'C', '99/99/9999', '99/99/9999', 10, null, null, null, 'Y', 'Y', 'N', null, null, 'N', 'C', null, null, null, null, '##########', '89IDDATE', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_IDDATE2', 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '85', '1201', 'BALANCE', 'Tiền mặt', 'Available withdraw', 11, 'N', '#,##0', '#,##0', 19, ' ', ' ', '0', 'Y', 'Y', 'N', ' ', ' ', 'N', 'N', null, null, null, null, '##########', '03BALANCE', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_AMT', 'Y', '0', 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '86', '1201', 'AVLADVANCE', 'Số tiền ứng', 'Available withdraw', 12, 'N', '#,##0', '#,##0', 19, ' ', ' ', '0', 'Y', 'Y', 'N', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_AMT', 'Y', '0', 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '87', '1201', 'CASTBAL', 'Số tiền tối đa được chuyển', 'Available withdraw', 13, 'N', '#,##0', '#,##0', 19, ' ', ' ', '0', 'Y', 'Y', 'N', ' ', ' ', 'N', 'N', null, null, null, null, '##########', '03BALDEFOVD', null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_AMT', 'Y', '0', 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '10', '1201', 'AMT', 'Số tiền chuyển', 'Amount', 14, 'N', '#,##0', '#,##0', 19, ' ', ' ', '0', 'Y', 'N', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_AMT', 'Y', '0', 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '25', '1201', 'FEETYPE', 'Loại phí', 'Fee type', 15, 'C', null, null, 5, 'SELECT FE.FEECD VALUECD, FE.FEECD VALUE,FE.FEENAME  DISPLAY,FE.FEENAME  EN_DISPLAY,FE.FEENAME DESCRIPTION FROM FEEMASTER FE, FEEMAP FM WHERE FE.FEECD = FM.FEECD AND FM.TLTXCD =''1201'' ', ' ', '00015', 'Y', 'N', 'N', ' ', ' ', 'Y', 'C', null, null, null, null, '##########', null, null, null, null, 'M', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '15', '1201', 'FEEAMT', 'Phí chuyển tiền', 'Fee Amount', 16, 'N', '#,##0', '#,##0', 19, ' ', ' ', '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '16', '1201', 'TOTALAMT', 'Tổng tiền', 'Total amount', 16, 'N', '#,##0', '#,##0', 19, ' ', ' ', '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', '0', 'N', null, null, null);
INSERT into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '30', '1201', 'DESC', 'Diễn giải', 'Description', 35, 'C', ' ', ' ', 250, ' ', ' ', 'IAC <$89CUSTODYCD> <$93CUSTNAME2>', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', 'P_DESC', 'Y', null, 'N', null, null, null);
COMMIT;
/
--
--
/
DELETE FLDVAL WHERE OBJNAME = '1201';
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('30','1201',5,'E','FX','FN_GEN_DESC_1201','89##93##05',null,null,null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('16','1201',4,'E','EX','15++10',null,null,null,null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('15','1201',2,'E','FX','fn_getTransferMoneyFee','10##25',null,null,null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('10','1201',0,'V','>>','@0',null,'Số tiền phải lớn hơn 0','Amount should be greater than zero',null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('86','1201',5,'E','FX','getavladvance','03',null,null,null,null,'0');
COMMIT;
/
--
--
/
DELETE TLTX WHERE TLTXCD = '1201';
INSERT INTO TLTX (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHKSINGLE)
VALUES ('1201', 'Chuyển khoản tiền giữa 2 tài khoản lưu ký', 'Transfer money between 2 deposit accounts', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'Y', ' ', 'Y', 'T', '2', 'N', 'N', 'N', 'CI01', 'CITRFCI', '10', '03', ' ', null, 0, 'Y', 'N', 'Y', 'N', null, '##', 'DB', 'Y', null, null, 'TRANSFER', 'N', '##', '##', 'Y', 'Y');
COMMIT;
/
--
--
/
DELETE APPCHK WHERE TLTXCD = '1201';
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('1201','CI','03','01','@ANTC','ACCTNO','N','@1','0');
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('1201','CI','05','15','@Y','ACCTNO','N','@1','0');
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('1201','CI','03','15','@Y','ACCTNO','N','@1','0');
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('1201','CI','05','01','@ANT','ACCTNO','N','@1','0');
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('1201','CI','03','11','16','ACCTNO','N','@1','0');
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('1201','CF','03','07','@B','ACCTNO','N','@1','0');
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('1201','CF','03','31','@0','ACCTNO','N','@1','1');
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('1201','CF','03','32','@1','ACCTNO','N','@1','1');
COMMIT;
/
--
--
/
DELETE APPMAP WHERE TLTXCD = '1201';
INSERT INTO appmap (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM)
VALUES ('1201', 'CI', '0016', '03', '16', null, null, 'CI', 'ACCTNO', '@1', null, 0);
INSERT INTO appmap (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM)
VALUES ('1201', 'CI', '0011', '03', '10', null, null, 'CI', 'ACCTNO', '@1', '##', 0);
INSERT INTO appmap (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM)
VALUES ('1201', 'CI', '0028', '03', '15', null, null, 'CI', 'ACCTNO', '@1', 'Phi chuyen tien', 0);
INSERT INTO appmap (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM)
VALUES ('1201', 'CI', '0044', '03', '10', null, null, 'CI', 'ACCTNO', '@1', null, 0);
INSERT INTO APPMAP (TLTXCD,APPTYPE,APPTXCD,ACFLD,AMTEXP,COND,ACFLDREF,APPTYPEREF,FLDKEY,ISRUN,TRDESC,ODRNUM)
VALUES ('1201','CI','0030','03','<$BUSDATE>',null,null,null,'ACCTNO','@1',null,0);
COMMIT;
/
