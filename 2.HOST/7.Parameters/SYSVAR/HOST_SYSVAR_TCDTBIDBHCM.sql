--
/
DELETE sysvar WHERE VARNAME='TCDTBIDVHCM';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'TCDTBIDVHCM', '101', 'Tài khoản chuyên thu tại BIDV chi nhánh HCM','Tài khoản chuyên thu tại BIDV chi nhánh HCM', 'Y');
COMMIT;
