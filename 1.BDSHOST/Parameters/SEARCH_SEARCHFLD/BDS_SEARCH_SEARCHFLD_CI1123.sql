--
--
/
delete from rptmaster where rptid = 'CI1123';
insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('CI1123', 'HOST', 'CI', '12', '5', '5', '60', '5', '5', 'DANH SÁCH CÁC BÁO CÁO THÁNG', 'Y', 1, '1', 'P', 'CI1123', 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'DANH SÁCH CÁC BÁO CÁO THÁNG', null, 0, 0, 0, 0, 'N', 'N', 'Y');
commit;
/
delete from search where searchcode = 'CI1123';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('CI1123', 'Danh sách các báo cáo tháng', 'Danh sách các báo cáo tháng', 'select * from (
select a.id id, a.recordtype , a.refnum, a.bankid, a.transfertype, a.debitaccount, a.benaccount, a.benbankname, a.benname,
a.benbankcode, a.amount, to_char(to_timestamp(a.banktime,''rrrrmmddhh24miss'')) banktime, a.checksum, a.resultend,
a.customerstatus, a.vpbstatus, a.tranfee, a.txdate, a.filename, decode(a.verify,''Y'',''Có'',''Không'') verify, to_char(a.create_time) create_time
from comparelist a 
where a.transactiontype = ''7'' order by a.id desc) where 0 = 0', 'CIMAST', 'frmCIMAST', null, null, null, 50, 'N', 30, 'NYNNYYYNNN', 'Y', 'T');
commit;
/
delete from searchfld where searchcode = 'CI1123';
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (1, 'ID', 'ID', 'N', 'CI1123', 100, null, '<,<=,=,>=,>,<>', null, 'Y', 'Y', 'Y', 100, null, 'ID', 'Y', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (2, 'RECORDTYPE', 'Record Type', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Record Type', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (3, 'REFNUM', 'Mã GD', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Mã GD', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (4, 'BANKID', 'Số FT VPBANK', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Số FT VPBANK', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (5, 'TRANSFERTYPE', 'Loại giao dịch', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Loại giao dịch', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (6, 'DEBITACCOUNT', 'Số tài khoản chi hộ', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Số tài khoản chi hộ', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (7, 'BENACCOUNT', 'Số tài khoản thụ huởng', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Số tài khoản thụ huởng', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (8, 'BENNAME', 'Tên đơn vị thụ hưởng', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Tên đơn vị thụ hưởng', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (9, 'BENBANKNAME', 'Tên ngân hàng thụ hưởng', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Tên ngân hàng thụ hưởng', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (10, 'BENBANKCODE', 'Mã code', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Mã code', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (11, 'AMOUNT', 'Số tiền giao dịch', 'N', 'CI1123', 100, null, '<,<=,=,>=,>,<>', null, 'Y', 'Y', 'N', 100, null, 'Số tiền giao dịch', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (12, 'BANKTIME', 'Thời gian xử lý tại ngân hàng', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Thời gian xử lý tại ngân hàng', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (13, 'CHECKSUM', 'MD5 dữ liệu', 'C', 'CI1123', 500, null, 'LIKE,=', null, 'N', 'Y', 'N', 500, null, 'MD5 dữ liệu', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (14, 'RESULTEND', 'Trạng thái GD VPBank đối soát cuối cùng', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Trạng thái GD VPBank đối soát cuối cùng', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (15, 'CUSTOMERSTATUS', 'Trạng thái giao dịch tại flex', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Trạng thái giao dịch tại flex', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (16, 'VPBSTATUS', 'Trạng thái giao dịch tại VPBANK', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Trạng thái giao dịch tại VPBANK', 'N', null, null, 'N', null, null, null, 'N');
 
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (17, 'TRANFEE', 'Phí giao dịch', 'N', 'CI1123', 100, null, '<,<=,=,>=,>,<>', null, 'Y', 'Y', 'N', 100, null, 'Phí giao dịch', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (18, 'TXDATE', 'Ngày GD', 'D', 'CI1123', 100, null, '<,<=,=,>=,>,<>', null, 'Y', 'Y', 'N', 100, null, 'Ngày GD', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (19, 'FILENAME', 'Tên file', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Tên file', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (20, 'VERIFY', 'Xác thực thành công', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Xác thực thành công', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (21, 'CREATE_TIME', 'Thời gian tạo', 'C', 'CI1123', 100, null, 'LIKE,=', null, 'Y', 'N', 'N', 100, null, 'Thời gian tạo', 'N', null, null, 'N', null, null, null, 'N');
commit;
