--
DELETE rptmaster WHERE rptid='LN0014';
insert into rptmaster (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB)
values ('LN0014', 'HOST', 'LN', '12', '5', '5', '60', '5', '5', 'B?O C?O REVIEW KH?CH H?NG', 'Y', 1, '1', 'L', 'LN0014', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'CUSTOMER REVIEW REPORT', null, 0, 0, 0, 0, 'N', 'N', 'Y');
COMMIT;
