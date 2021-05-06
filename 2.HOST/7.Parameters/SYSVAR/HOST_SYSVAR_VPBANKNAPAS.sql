delete from sysvar where varname = 'VPBANKNAPAS';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'VPBANKNAPAS', '300000000', 'Han muc napas VPBANK', 'Han muc napas VPBANK', 'N');
commit;
