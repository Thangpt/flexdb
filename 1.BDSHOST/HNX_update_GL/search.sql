﻿DELETE FROM search WHERE searchcode LIKE 'OD4004';

insert into SEARCH (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('OD4004', 'Thông tin user-pass GDTT (HAGW)', 'User-pass onlinetraing', 'SELECT * FROM (SELECT sysvalue GWUSERNAME FROM ordersys_ha WHERE sysname =''GWUSERNAME'') US, (SELECT sysvalue GWPASSWORD FROM ordersys_ha WHERE sysname =''GWPASSWORD'') PAS WHERE 0=0 ', 'OD4004', null, null, null, 0, 50, 'N', 30, null, 'Y', 'T');

COMMIT; 

DELETE FROM searchfld WHERE searchcode ='OD4004';

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (1, 'GWUSERNAME', 'User', 'C', 'OD4004', 100, null, 'LIKE,=', null, 'Y', 'Y', 'Y', 100, null, 'Username', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (2, 'GWPASSWORD', 'Mật khẩu', 'C', 'OD4004', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Old Pass', 'N', null, null, 'N', null, null, null, 'N');

COMMIT; 


DELETE FROM search WHERE searchcode LIKE 'SY4000';

insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('SY4000', 'Quản lý thông tin user-pass GDTT (HAGW)', 'Manage user-pass onlinetraing', 'select USERREQUESTID, USERNAME, PASSWORD, NEWPASSWORD, DATE_TIME, TXDATE, TXNUM,al1.cdcontent STATUS,al.cdcontent ASETSTATUS, USERSTATUSTEXT from GWINFOR gw, allcode al, allcode al1 WHERE gw.asetstatus = al.cdval AND al.cdname=''ASETSTATUS''     AND   gw.status=al1.cdval AND al1.cdname =''OODSTATUS'' ', 'SY4000', null, 'TXDATE, TXNUM DESC ', null, null, 50, 'N', 30, null, 'Y', 'T');

COMMIT; 

DELETE FROM searchfld WHERE searchcode ='SY4000';

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (1, 'USERNAME', 'User', 'C', 'SY4000', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Username', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (2, 'PASSWORD', 'Mật khẩu cũ', 'C', 'SY4000', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Old Pass', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (3, 'NEWPASSWORD', 'Mật khẩu mới', 'C', 'SY4000', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'New Pass', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (4, 'TXDATE', 'Ngày GD', 'C', 'SY4000', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Date transaction', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (5, 'TXNUM', 'Số chứng từ', 'C', 'SY4000', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Code transaction', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (6, 'STATUS', 'Trạng thái Y/c', 'C', 'SY4000', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Status', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (7, 'ASETSTATUS', 'Trạng thái xử lý của Sở', 'C', 'SY4000', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Asset Status', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (8, 'USERSTATUSTEXT', 'Note từ Sở', 'C', 'SY4000', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Asset desc', 'N', null, null, 'N', null, null, null, 'N');

COMMIT; 



