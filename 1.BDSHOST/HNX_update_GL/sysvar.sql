delete from sysvar where varname in ('PLOBYCLOSEPRICE','UPDPRICEPLO');
insert into sysvar(GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC, EDITALLOW)
values('SYSTEM','PLOBYCLOSEPRICE', 'N', 'Cho phép đặt lệnh PLO theo giá đóng cửa', 'Cho phép đặt lệnh PLO theo giá đóng cửa', 'N');



insert into sysvar(GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC, EDITALLOW)
values ('SYSTEM','UPDPRICEPLO','N','Cho phép cập nhật giá với những lệnh PLO trước phiên','Cho phép cập nhật giá với những lệnh PLO trước phiên', 'N');
commit;
