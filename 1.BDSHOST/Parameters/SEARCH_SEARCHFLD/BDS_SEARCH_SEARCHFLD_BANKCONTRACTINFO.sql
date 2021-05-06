﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'BANKCONTRACTINFO';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('BANKCONTRACTINFO', 'Quản lý đăng ký HĐ 3 bên với khách hàng', 'Register contract account with Bank', '
select b.autoid,cf.fullname, af.acctno, cf.custodycd,  b.contractno, b.bankacctno, b.bankcode,b.TYPECONT,b.txdate from cfmast cf, afmast af, bankcontractinfo b
where cf.custid = af.custid and b.acctno = af.acctno', 'BANKCONTRACTINFO', 'frmBANKCONTRACTINFO', null, null, null, 50, 'N', 30, null, 'Y', 'T');

COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'BANKCONTRACTINFO';

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (0, 'AUTOID', 'Autoid', 'C', 'BANKCONTRACTINFO', 100, null, 'LIKE,=', null, 'N', 'N', 'Y', 80, null, 'AutoID', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (1, 'CUSTODYCD', 'Số TK lưu ký', 'C', 'BANKCONTRACTINFO', 100, null, '=, LIKE', null, 'Y', 'Y', 'N', 80, null, 'Custody code', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (2, 'ACCTNO', 'Số tiểu khoản', 'C', 'BANKCONTRACTINFO', 100, '9999.999999', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Account No', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (3, 'FULLNAME', 'Tên khách hàng', 'C', 'BANKCONTRACTINFO', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Customer name', 'Y', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (4, 'CONTRACTNO', 'Số hợp đồng', 'C', 'BANKCONTRACTINFO', 100, '9999.999999', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Account No', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (5, 'BANKACCTNO', 'Số tk ngân hàng', 'C', 'BANKCONTRACTINFO', 100, '9999.999999', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Account No', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (6, 'BANKCODE', 'Mã ngân hàng', 'C', 'BANKCONTRACTINFO', 100, '9999.999999', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Account No', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (7, 'TYPECONT', 'Loại hợp đồng', 'C', 'BANKCONTRACTINFO', 100, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'TYPECONT', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (10, 'TXDATE', 'Ngày hiệu lực', 'D', 'BANKCONTRACTINFO', 100, null, '>=,<=,=', null, 'Y', 'Y', 'N', 80, null, 'TX.DATE', 'N', '  ', null, 'N', null, null, null, 'N');

COMMIT;
/
