DELETE sysvar WHERE varname = 'HNX_DEFAULT_TRADELOT';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'HNX_DEFAULT_TRADELOT', '100', 'Lô giao dịch sàn HNX', 'Lô giao dịch sàn HNX', 'N');
COMMIT;
