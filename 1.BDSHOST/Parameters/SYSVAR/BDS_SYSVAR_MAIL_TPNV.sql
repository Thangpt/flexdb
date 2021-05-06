--
--
/
DELETE sysvar WHERE grname = 'SYSTEM' AND varname = 'MAIL_TPNV';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'MAIL_TPNV', NULL, 'Địa chỉ email của Trường phòng Nghiệp Vụ', 'Địa chỉ email của Trường phòng Nghiệp Vụ', 'Y');
COMMIT;
/
