
delete from sysvar where varname = 'BANK_MODE';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'BANK_MODE', 'PROD', 'BANK_MODE', 'BANK_MODE', 'N');
commit;

