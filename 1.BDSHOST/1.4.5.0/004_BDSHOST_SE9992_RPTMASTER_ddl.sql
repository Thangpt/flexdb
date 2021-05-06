--select * from rptmaster where rptid like 'SE9992'
DELETE FROM RPTMASTER WHERE RPTID = 'SE9992';
insert into RPTMASTER (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('SE9992', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'Danh sách khách hàng sở hữu chứng quyền chưa thực hiện', 'Y', 1, '1', 'P', 'SE2242', 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Customer List warrants owned unrealized', null, 0, 0, 0, 0, 'N', 'N', 'Y');

COMMIT;