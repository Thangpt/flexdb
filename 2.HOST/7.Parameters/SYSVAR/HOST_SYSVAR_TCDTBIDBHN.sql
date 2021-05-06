--
/
DELETE sysvar WHERE VARNAME='TCDTBIDVHN';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'TCDTBIDVHN', '101', 'Tài khoản chuyên thu tại BIDV chi nhánh Hà Nội','Tài khoản chuyên thu tại BIDV chi nhánh Hà Nội', 'Y');
COMMIT;
