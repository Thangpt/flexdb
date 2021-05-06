﻿DELETE searchfld WHERE SEARCHCODE = 'SE8815' AND FIELDCODE IN ('REFULLNAME','BRNAME','CAREBY');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (23, 'REFULLNAME', 'Tên môi giới', 'C', 'SE8815', 200, null, 'LIKE,=', null, 'Y', 'Y', 'N', 200, null, 'ReFullName', 'N', NULL, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (24, 'BRNAME', 'Mã chi nhánh', 'C', 'SE8815', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 150, null, 'BRNAME', 'N', NULL, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (25, 'CAREBY', 'Careby', 'C', 'SE8815', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 150, null, 'CAREBY', 'N', NULL, null, 'N', null, null, null, 'N');

COMMIT;