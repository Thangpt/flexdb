--
/
DELETE rptmaster WHERE rptid='HDGDPS';
insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('HDGDPS', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Hợp đồng mở tài khoản chứng khoán giao dịch phái sinh', 'Y', 1, '1', 'P', 'HDGDPS', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Contract to open a derivative trading account', null, 0, 0, 0, 0, 'N', 'N', 'Y');
COMMIT;
/
