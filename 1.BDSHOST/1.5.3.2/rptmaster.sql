DELETE FROM rptmaster WHERE rptid LIKE '%CF0061%';

insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('CF0061', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'BÁO CÁO KH VIP THEO GTGD TB THÁNG TRONG KỲ', 'Y', 1, '1', 'P', 'CF0061', 'Y', 'S', 'N', 'R', 'N', 'Y', 'M', '000', 'S', -1, 'BÁO CÁO KH VIP THEO GTGD TB THÁNG TRONG KỲ', null, 0, 0, 0, 0, 'N', 'N', 'Y');

COMMIT;

DELETE FROM rptmaster WHERE rptid LIKE '%CF0062%';

insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('CF0062', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'BÁO CÁO KH VIP THEO NAV TB TRONG KỲ', 'Y', 1, '1', 'P', 'CF0062', 'Y', 'S', 'N', 'R', 'N', 'Y', 'M', '000', 'S', -1, 'BÁO CÁO KH VIP THEO NAV TB TRONG KỲ', null, 0, 0, 0, 0, 'N', 'N', 'Y');

COMMIT;
