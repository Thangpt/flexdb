--
/
DELETE rptmaster WHERE rptid='DNTKCK';
insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('DNTKCK', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Giấy đề nghị mở tài khoản chứng khoán', 'Y', 1, '1', 'P', 'DNTKCK', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Application For Opening Securities Trading Account', null, 0, 0, 0, 0, 'N', 'N', 'Y');
COMMIT;
/
