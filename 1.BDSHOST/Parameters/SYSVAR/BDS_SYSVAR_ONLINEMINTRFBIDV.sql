DELETE sysvar WHERE varname = 'ONLINEMINTRFBIDV';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'ONLINEMINTRFBIDV', '100000', 'Số tiền chuyển tiền nội bộ (khác tài khoản) tối thiểu', 'So tien chuyen tien noi bo (khac tai khoan) toi thieu', 'Y');
COMMIT;
