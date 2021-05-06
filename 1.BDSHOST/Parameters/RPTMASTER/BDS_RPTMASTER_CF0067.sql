--
--
/
DELETE rptmaster WHERE rptid = 'CF0067';
insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('CF0067', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Danh sách khách hàng có hạn mức chuyển tiền riêng', 'Y', 1, '1', 'L', 'CF0067', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Danh sách khách hàng có hạn mức chuyển tiền riêng', null, 0, 0, 0, 0, 'N', 'N', 'Y');
COMMIT;
/
