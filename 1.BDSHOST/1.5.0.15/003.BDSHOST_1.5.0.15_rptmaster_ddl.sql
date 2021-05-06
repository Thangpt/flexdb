DELETE FROM rptmaster WHERE rptid = 'CFV051';

insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('CFV051', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Hủy đăng ký giao dịch qua Bloomberg (GD0051)', 'Y', 1, '1', 'P', null, 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'View Cancel Bloomberg trading register (wait for 0051)', null, 0, 0, 0, 0, 'N', 'N', 'Y');

COMMIT;

DELETE FROM rptmaster WHERE rptid = 'CFV052';

insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('CFV052', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Gán TraderID cho tiểu khoản GD Bloomberg (GD0052)', 'Y', 1, '1', 'P', null, 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'View Traderid to Bloomberg sub account assignment (wait for 0052)', null, 0, 0, 0, 0, 'N', 'N', 'Y');

COMMIT;

DELETE FROM rptmaster WHERE rptid = 'CFV053';

insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('CFV053', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Hủy gán TraderID cho tiểu khoản GD Bloomberg (GD0053)', 'Y', 1, '1', 'P', null, 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'View Cancel Traderid to Bloomberg sub account assignment (wait for 0053)', null, 0, 0, 0, 0, 'N', 'N', 'Y');

COMMIT;

DELETE FROM rptmaster WHERE rptid = 'OD3001';

insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('OD3001', 'HOST', 'OD', '12', '5', '5', '60', '5', '5', 'Báo cáo đăng ký và hủy đăng ký dịch vụ kết nối Bloomberg', 'Y', 1, '1', 'L', 'OD3001', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Báo cáo đăng ký và hủy đăng ký dịch vụ kết nối Bloomberg', null, 0, 0, 0, 0, 'N', 'N', 'Y');

COMMIT;
