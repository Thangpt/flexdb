
delete from sysvar where varname = 'MAXRETRYCOUNT';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('BANK', 'MAXRETRYCOUNT', '3', 'Số lần lấy trạng thái chi hộ', 'Số lần lấy trạng thái chi hộ', 'N');
commit;

