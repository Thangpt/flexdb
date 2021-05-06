--
--
/
DELETE SYSVAR WHERE VARNAME = 'CASHLIMIT';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'CASHLIMIT', '1000000000', 'Han muc chuyen tien toi da', null, 'Y');
COMMIT;
/
