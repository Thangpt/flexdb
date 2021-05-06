DELETE sysvar WHERE varname IN ('ONLINEACCOPENNUMBER_HN','ONLINEACCOPENNUMBER_HCM','EMAIL_HN','EMAIL_HCM') ;

insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'ONLINEACCOPENNUMBER_HN', '001', 'Đầu số tài khoản mở Online tại Hội sở', 'Đầu số tài khoản mở Online tại Hội sở', 'Y');

insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'ONLINEACCOPENNUMBER_HCM', '002', 'Đầu số tài khoản mở Online tại HCM', 'Đầu số tài khoản mở Online tại HCM', 'Y');

insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'EMAIL_HN', 'emailhn@fss.com', 'Địa chỉ email BR Hà Nội', 'Địa chỉ email BR Hà Nội', 'Y');

insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'EMAIL_HCM', 'emailhcm@fss.com', 'Địa chỉ email BR HCM', 'Địa chỉ email BR HCM', 'Y');

COMMIT;


