--
--
/
DELETE search WHERE searchcode = 'CF0029';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('CF0029', 'Tra cứu hạn mức chuyển tiền riêng của KH', 'Look up your own transfer limit', 'select cf.custodycd, cf.fullname, lm.* from cftrflimit lm, cfmast cf where lm.custid = cf.custid and lm.status = ''A''', 'CF0029', 'frm', 'CUSTODYCD', '0022', null, 50, 'N', 30, 'NNNNYYYNNN', 'Y', 'T');
COMMIT;
/
--
--
/
DELETE searchfld WHERE searchcode = 'CF0029';
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (0, 'CUSTID', 'Mã khách hàng', 'C', 'CF0029', 10, '9999.999999', 'LIKE,=', '0###-#####0', 'N', 'N', 'N', 100, null, 'Customer id', 'N', '05', null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (3, 'CUSTODYCD', 'Số tài khoản lưu ký', 'C', 'CF0029', 10, 'ccc.c.cccccc', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Custody code', 'N', '88', null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (6, 'FULLNAME', 'Tên khách hàng', 'C', 'CF0029', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 150, null, 'Customer name', 'N', '31', null, 'N', NULL, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (9, 'MAXTOTALTRFAMT', 'Số tiền chuyển tối đa/ 1 ngày', 'N', 'CF0029', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 120, null, 'Maximum transfer amount per day', 'N', '14', null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (10, 'MAXTOTALTRFAMT_1', 'Số tiền chuyển khác chủ tối đa/ 1 ngày', 'N', 'CF0029', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 120, null, 'Maximum transfer amount per day', 'N', '23', null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (12, 'REMAXTRFAMT', 'Số tiền bán chờ về chuyển tối đa/ 1 ngày', 'N', 'CF0029', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 120, null, 'Maximum transfer wait amount per day', 'N', '15', null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (15, 'MAXTRFAMT', 'Số tiền chuyển tối đa/ 1 lần chuyển', 'N', 'CF0029', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 120, null, 'Maximum transfer amount / 1 transfer', 'N', '16', null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (18, 'MAXTRFCNT', 'Số lần chuyển tối đa/ 1 ngày', 'N', 'CF0029', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 120, null, 'The maximum number of money transfers per day', 'N', '17', null, 'N', null, null, null, 'N');
COMMIT;
/
