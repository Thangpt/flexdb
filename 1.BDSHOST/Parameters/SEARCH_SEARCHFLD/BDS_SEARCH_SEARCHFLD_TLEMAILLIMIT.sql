 --1.6.0.0 - MSBS-2119: Them man hinh nguoi phe duyet
 
DELETE search where searchcode='TLEMAILLIMIT';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('TLEMAILLIMIT', 'Người phê duyệt', 'User
approver', 'SELECT tl.autoid, tl.tlid, tl.tlname, nvl(a1.cdcontent,tl.TLTITLE) tltitle, tl.email, tl.t_advancelimit, tl.f_advancelimit, tl.t_totaltranlimit, tl.f_totaltranlimit,tl.brid
FROM TLEMAILLIMIT tl, allcode a1  
WHERE tl.brid=<$KEYVAL> AND tl.tltitle = a1.cdval(+) and a1.cdname(+) = ''TLTITLE''
ORDER BY tl.tlname', 'SA.TLEMAILLIMIT', 'frmTLEMAILLIMIT', null, null, 0, 50, 'N', 30, null, 'Y', 'T');
COMMIT;



DELETE searchfld where searchcode='TLEMAILLIMIT';
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (0, 'TLID', 'Mã User', 'C', 'TLEMAILLIMIT', 50, null, 'LIKE,=', null, 'Y', 'Y', 'N', 50, null, 'User code', 'N', null, null, 'N', null, null, null, 'V');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (1, 'TLNAME', 'Tên User', 'C', 'TLEMAILLIMIT', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'User name', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (2, 'TLTITLE', 'Chức vụ', 'C', 'TLEMAILLIMIT', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Job title', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (3, 'EMAIL', 'Email', 'C', 'TLEMAILLIMIT', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Email', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (5, 'T_ADVANCELIMIT', 'Hạn mức tiền ứng ( Đến số tiền)', 'N', 'TLEMAILLIMIT', 20, null, '=,<>,<,<=,>=,>', null, 'Y', 'Y', 'N', 100, null, 'To Advance Limit', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (4, 'F_ADVANCELIMIT', 'Hạn mức tiền ứng ( Từ số tiền)', 'N', 'TLEMAILLIMIT', 20, null, '=,<>,<,<=,>=,>', null, 'Y', 'Y', 'N', 100, null, 'From Advance Limit', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (7, 'T_TOTALTRANLIMIT', 'Hạn mức tổng tiền chuyển (Đến số tiền)', 'N', 'TLEMAILLIMIT', 20, null, '=,<>,<,<=,>=,>', null, 'Y', 'Y', 'N', 100, null, 'To Total transfer limit', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (6, 'F_TOTALTRANLIMIT', 'Hạn mức tổng tiền chuyển ( Từ số tiền)', 'N', 'TLEMAILLIMIT', 20, null, '=,<>,<,<=,>=,>', null, 'Y', 'Y', 'N', 100, null, 'From Total transfer limit', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (-1, 'BRID', 'Mã chi nhánh', 'C', 'TLEMAILLIMIT', 50, null, 'LIKE,=', null, 'N', 'Y', 'N', 50, null, '
Branch code', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (-2, 'AUTOID', 'Auto Id', 'N', 'TLEMAILLIMIT', 50, null, '=', null, 'N', 'Y', 'Y', 50, null, 'Auto id', 'N', null, null, 'N', null, null, null, 'N');
COMMIT;
