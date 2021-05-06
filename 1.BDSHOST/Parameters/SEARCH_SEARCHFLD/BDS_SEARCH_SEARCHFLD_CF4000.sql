--
/
DELETE search WHERE searchcode='CF4000';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('CF4000', 'Tra cứu thông tin đăng ký mở tài khoản', 'Tra cứu thông tin mở tài khooản', 'select autoid, custodycd, customername, idcode, address from registeronline  where 0=0', 'CF4000', 'frm', null, null, 0, 50, 'N', 30, 'NYNNYYYNNN', 'Y', 'T');
COMMIT;


DELETE searchfld WHERE searchcode='CF4000';
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (1, 'AUTOID', 'Mã dang ký', 'N', 'CF4000', 100, null, '<,<=,=,>=,>', null, 'Y', 'Y', 'Y', 100, null, 'Auto id', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (2, 'CUSTODYCD', 'Số tài khoản LK', 'C', 'CF4000', 10, 'ccc.c.cccccc', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Custody code', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (3, 'CUSTOMERNAME', 'Tên khách hàng', 'C', 'CF4000', 200, null, 'LIKE,=', null, 'Y', 'Y', 'N', 200, null, 'CustomerName', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (4, 'IDCODE', 'Số CMND', 'C', 'CF4000', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'IDCODE', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (5, 'ADDRESS', 'Địa chỉ', 'C', 'CF4000', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Address', 'N', null, null, 'N', null, null, null, 'N');
COMMIT;
