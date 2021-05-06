DELETE sysvar WHERE varname = 'HSX_DEFAULT_TRADELOT';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'HSX_DEFAULT_TRADELOT', '100', 'Lô giao dịch sàn HSX', 'Lô giao dịch sàn HSX', 'N');
COMMIT;
