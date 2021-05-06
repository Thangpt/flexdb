DELETE rptmaster WHERE rptid ='MR0017';
insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('MR0017', 'HOST', 'MR', '12', '5', '5', '60', '5', '5', 'Báo cáo tổng hợp dịch vụ ký quỹ sản phẩm tài chính', 'Y', 1, '1', 'L', 'MR0017', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Báo cáo tổng hợp dịch vụ ký quỹ sản phẩm tài chính', null, 0, 0, 0, 0, 'N', 'N', 'Y');

COMMIT;

DELETE rptmaster WHERE rptid ='MR0018';
insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('MR0018', 'HOST', 'MR', '12', '5', '5', '60', '5', '5', 'Báo cáo thống kê số liệu giao dịch sản phẩm tài chính', 'Y', 1, '1', 'L', 'MR0018', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Báo cáo thống kê số liệu giao dịch sản phẩm tài chính', null, 0, 0, 0, 0, 'N', 'N', 'Y');

COMMIT;
