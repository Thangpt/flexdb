--
--
/
DELETE SYSVAR WHERE VARNAME = 'VPBANKLIMIT';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'VPBANKLIMIT', '300000000', 'Han muc tcdt khac ngan hang cua VPBANK', 'Han muc tcdt khac ngan hang cua VPBANK', 'N');
COMMIT;
/
