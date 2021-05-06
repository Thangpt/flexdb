--
/
DELETE sysvar WHERE VARNAME='TCDTVPBHN';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'TCDTVPBHN', '101', 'Tài khoản chuyên thu tại VPB','Tai Khoan chuyen thu VBP', 'Y');
COMMIT;
