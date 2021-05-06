DELETE search WHERE searchcode='TYPENAME';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('TYPENAME', 'Danh sách sản phẩm', 'Danh sách sản phẩm', 'select distinct(typename) typename, a0.cdcontent apprv_sts from aftype af, allcode a0  where af.apprv_sts=''A'' and af.apprv_sts=a0.cdval and a0.cdname=''STATUS'' and a0.cdtype=''SA''', 'TYPENAME', 'frmTYPENAME', null, null, 0, 50, 'N', 30, null, 'Y', 'T');
COMMIT;


DELETE searchfld WHERE searchcode='TYPENAME';
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (1, 'TYPENAME', 'Tên loại hình', 'C', 'TYPENAME', 200, null, 'LIKE,=', null, 'Y', 'Y', 'Y', 400, null, 'Type name', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (3, 'APPRV_STS', 'Trạng thái', 'C', 'TYPENAME', 200, null, 'LIKE,=', null, 'Y', 'Y', 'N', 200, 'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''STATUS'' ORDER BY LSTODR', 'Status', 'N', null, null, 'N', null, null, null, 'N');
COMMIT;
