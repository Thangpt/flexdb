﻿﻿--
--
/
DELETE rptmaster WHERE rptid = 'LN0030';
insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('LN0030', 'HOST', 'LN', '12', '5', '5', '60', '5', '5', 'DANH SÁCH TÀI KHOẢN VI PHẠM CẤP BẢO LÃNH', 'Y', 1, '1', 'P', 'LN0030', 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'LIST OF ACCOUNTS OF GUARANTEE VIOLATIONS', null, 0, 0, 0, 0, 'N', 'N', 'Y');
COMMIT;
/
