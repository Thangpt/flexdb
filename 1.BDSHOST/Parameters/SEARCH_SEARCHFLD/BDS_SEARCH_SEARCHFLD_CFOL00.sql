--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CFOL00';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('CFOL00', 'Quản lý các tài khoản đăng ký từ online', 'Management online register', 'select REG.AUTOID,REG.CustomerType,A1.CDCONTENT CustomerTypeDesc,
       REG.CustomerName,REG.CustomerBirth,REG.IDType,
       REG.IDCode,REG.Iddate,REG.Idplace,REG.Expiredate,
     case when reg.Customertype = ''I'' then REG.contactAddress else reg.address end Address,REG.Taxcode,REG.PrivatePhone,
       REG.Mobile,REG.Fax,REG.Email,REG.Office,REG.Position,REG.Country,REG.CustomerCity,
       REG.TKTGTT, REG.SEX, reg.custodycd, a2.cdcontent ten_thanh_pho, --brgrp.description brid,
       reg.bankaccountnumber1  bankaccount, reg.bankname1 BANKNAME,  A3.CDCONTENT REREGISTER,
       reg.refullname, reg.retlid,br1.brname,
     case when substr(nvl(reg.REGISTERSERVICES, ''NNNNN''),1,1) = ''Y'' then ''GD Internet,'' else '''' end ||
       case when substr(nvl(reg.REGISTERSERVICES, ''NNNNN''),2,1)= ''Y''then ''GD Điện thoại,'' else '''' end  ||
       case when substr(nvl(reg.REGISTERSERVICES, ''NNNNN''),3,1)= ''Y''then ''UTTB tự động,'' else '''' end  ||
       case when substr(nvl(reg.REGISTERSERVICES, ''NNNNN''),4,1)= ''Y''then ''GD kỹ quỹ CK,'' else '''' end  ||
       case when substr(nvl(reg.REGISTERSERVICES, ''NNNNN''),5,1)= ''Y''then ''GD FDS'' else '''' end  GDCK,
       case when substr(nvl(reg.REGISTERNOTITRAN, ''NNN''),1,1) = ''Y'' then ''EMAIL,'' else '''' end ||
       case when substr(nvl(reg.REGISTERNOTITRAN, ''NNN''),2,1)= ''Y''then ''SMS,'' else '''' end  ||
       case when substr(nvl(reg.REGISTERNOTITRAN, ''NNN''),3,1)= ''Y''then ''Trực tuyến'' else '''' end TBKQGD,
       case when substr(nvl(reg.AUTHENTYPEONLINE, ''NN''),1,1) = ''Y'' then ''OTP,'' else '''' end ||
       case when substr(nvl(reg.AUTHENTYPEONLINE, ''NN''),2,1)= ''Y''then ''CA'' else '''' end  PTXT,
       case when nvl(reg.AUTHENTYPEMOBILE, ''N'')= ''Y''then ''OTP'' else '''' end PTXTMABLE,
       area.areaname
from REGISTERONLINE REG,ALLCODE A1, allcode a2, allcode a3, brgrp br1 ,area
where REG.AUTOID not in (select OLAUTOID from CFMAST where OPENVIA=''O'')
and A1.CDNAME = ''CUSTTYPE'' and a2.cdname = ''PROVINCE'' and reg.CustomerCity = a2.cdval
and A1.CDTYPE=''CF'' and A2.CDTYPE=''CF'' and reg.areaopenaccount = area.areaid (+)
And a3.cdtype  = ''SY'' and A3.CDNAME = ''AD_HOC'' and nvl(reg.reregister, ''N'') = A3.Cdval
and A1.CDVAL=REG.CustomerType AND reg.branchopenaccount=br1.brid(+)', 'ONLINERES', 'CFOL00', null, 'EXEC', null, 50, 'N', 30, 'NYNNYYYNNN', 'Y', 'T');

COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CFOL00';

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (1, 'AUTOID', 'AUTOID', 'C', 'CFOL00', 10, null, 'LIKE,=', null, 'Y', 'Y', 'N', 80, null, 'AUTOID', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (1, 'CUSTOMERTYPE', 'Loại khách hàng', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'N', 'N', 'N', 80, null, 'CustomerType', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (2, 'CUSTODYCD', 'Số luu ký', 'C', 'CFOL00', 10, 'CCC.C.CCCCCC', 'LIKE,=', null, 'Y', 'Y', 'N', 80, null, 'CUSTODYCD', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (2, 'CUSTOMERTYPEDESC', 'Loại khách hàng', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'Y', 'N', 'N', 80, null, 'Customer Type', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (3, 'CUSTOMERNAME', 'Tên khách hàng', 'C', 'CFOL00', 200, null, 'LIKE,=', null, 'Y', 'Y', 'N', 200, null, 'CustomerName', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (4, 'CUSTOMERBIRTH', 'Ngày sinh', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'Y', 'N', 'N', 80, null, 'CustomerBirth', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (5, 'CUSTOMERCITY', 'Thành phố', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'N', 'N', 'N', 80, null, 'CUSTOMERCITY', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (5, 'IDTYPE', 'Loại giấy tờ', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'N', 'N', 'N', 80, null, 'IDType', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (5, 'TEN_THANH_PHO', 'Thành phố', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 80, null, 'City', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (5, 'SEX', 'Giới tính', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'N', 'N', 'N', 80, null, 'SEX', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (6, 'IDCODE', 'Số giấy tờ', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 80, null, 'IDCode', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (7, 'IDDATE', 'Ngày cấp', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'Y', 'N', 'N', 80, null, 'Iddate', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (8, 'IDPLACE', 'Nơi cấp', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'Y', 'N', 'N', 80, null, 'Idplace', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (9, 'EXPIREDATE', 'Ngày hết hạn', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'N', 'N', 'N', 80, null, 'Expiredate', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (10, 'ADDRESS', 'Địa chỉ', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'Y', 'N', 'N', 80, null, 'Address', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (11, 'TAXCODE', 'Mã số thuế', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'N', 'N', 'N', 80, null, 'Taxcode', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (12, 'PRIVATEPHONE', 'Số điện thoại nhà riêng', 'C', 'CFOL00', 200, null, 'LIKE,=', null, 'Y', 'N', 'N', 100, null, 'PrivatePhone', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (13, 'MOBILE', 'Số điện thoại di động', 'C', 'CFOL00', 200, null, 'LIKE,=', null, 'Y', 'N', 'N', 100, null, 'Mobile', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (14, 'FAX', 'Fax', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'N', 'N', 'N', 80, null, 'Fax', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (15, 'EMAIL', 'Email', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 80, null, 'Email', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (16, 'OFFICE', 'Cơ quan', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'N', 'N', 'N', 80, null, 'Office', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (17, 'POSITION', 'Chức vụ', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'N', 'N', 'N', 80, null, 'Position', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (18, 'COUNTRY', 'Nước', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'N', 'N', 'N', 80, null, 'Country', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (20, 'TKTGTT', 'TKGTT', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'N', 'N', 'N', 80, null, 'TKTGTT', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (21, 'BANKACCOUNT', 'Số tài khoản NH', 'C', 'CFOL00', 20, null, 'LIKE, =', null, 'Y', 'N', 'N', 100, null, 'BANKACCOUNT', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (22, 'BANKNAME', 'Mở tại', 'C', 'CFOL00', 100, null, 'LIKE, =', null, 'Y', 'N', 'N', 150, null, 'BANKNAME', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (23, 'REREGISTER', 'Ðăng ký MG tư vấn', 'C', 'CFOL00', 20, null, 'LIKE, =', null, 'Y', 'N', 'N', 80, null, 'REREGISTER', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (25, 'REFULLNAME', 'Họ và tên MG tư vấn', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'Y', 'N', 'N', 150, null, 'REFULLNAME', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (26, 'RETLID', 'Mã ID MG tư vấn', 'C', 'CFOL00', 20, null, 'LIKE,=', null, 'Y', 'N', 'N', 80, null, 'RETLID', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (28, 'AREANAME', 'Khu vực', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'Y', 'N', 'N', 100, null, 'AREANAME', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (29, 'BRNAME', 'Chi nhánh', 'C', 'CFOL00', 100, null, 'LIKE,=', null, 'Y', 'N', 'N', 120, null, 'BRNAME', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (30, 'GDCK', 'Dịch vụ CK', 'C', 'CFOL00', 200, null, 'LIKE, =', null, 'Y', 'N', 'N', 350, null, 'Service', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (31, 'TBKQGD', 'Thông báo kết quả', 'C', 'CFOL00', 200, null, 'LIKE, =', null, 'Y', 'N', 'N', 150, null, 'Service', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (32, 'PTXT', 'Xác thực', 'C', 'CFOL00', 200, null, 'LIKE, =', null, 'Y', 'N', 'N', 80, null, 'Service', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (33, 'PTXTMABLE', 'Xác thực (Mable)', 'C', 'CFOL00', 200, null, 'LIKE, =', null, 'Y', 'N', 'N', 150, null, 'Service', 'N', null, null, 'N', null, null, null, 'N');

COMMIT;
/
