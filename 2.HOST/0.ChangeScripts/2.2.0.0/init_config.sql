truncate table configsystem;
insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'showQuantityInsteadOfAmount', 'true', 'Đổi tên nhãn Amount thành Quantity trong phần đặt lệnh (Order ticket)');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportBalances', 'true', 'Có hỗ trợ tra cứu số dư /balance hay không.');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportBrackets', 'false', 'Có hỗ trợ lệnh brackets hay không.');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportClosePosition', 'true', 'Có hỗ trợ đóng vị thế mở mà không cần thao tác nhập lệnh đảo chiều hay không');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportDOM', 'false', 'Có cung cấp thông tin thị trường chờ khớp hay không.');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportDigitalSignature', 'false', 'Có yêu cầu chữ ký số khi gửi yêu cầu đặt lệnh không  ');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportEditAmount', 'true', 'Có hỗ trợ sửa khối lượng hay không');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportExecutions', 'false', 'Có hỗ trợ tra cứu lệnh khớp của 1 mã /executions hay không');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportLevel2Data', 'false', 'Cung cấp dữ liệu thị trường Level 2 hay không');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportMultiposition', 'false', 'Có hỗ trợ nhiều vị thế mở cùng 1 mã cùng 1 thời điểm không');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportOrderBrackets', 'false', 'Có hỗ trợ lệnh stopLoss hay takeProfit hay không.');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportOrdersHistory', 'true', 'Có hỗ trợ tra cứu lịch sử lệnh /ordersHistory hay không.');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportPLUpdate', 'true', 'Có cung cấp lãi lỗ chưa thực hiện hay không, nếu không thì giao diện tự tính');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportPositionBrackets', 'false', 'Có hỗ trợ sửa giá stopLoss hay takeProfit của vị thế hay không.');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportReducePosition', 'false', 'Reserved for future use.');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('ACCOUNTFLAG', 'supportStopLimitOrders', 'false', 'Hệ thống có hỗ trợ lệnh dừng hay không.');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('PULLINGINTERVAL', 'accountManager', '500', 'Thời gian tối thiểu giữa 02 lần yêu cầu lấy dữ liệu thông tin tài khoản. Đơn vị milliseconds.');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('PULLINGINTERVAL', 'history', '500', 'Thời gian tối thiểu giữa 02 lần yêu cầu lấy dữ liệu lịch sử giá. Đơn vị milliseconds. Mặc định 500ms.');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('PULLINGINTERVAL', 'orders', '500', 'Thời gian tối thiểu giữa 02 lần yêu cầu lấy dữ liệu sổ lệnh. Đơn vị milliseconds.');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('PULLINGINTERVAL', 'positions', '500', 'Thời gian tối thiểu giữa 02 lần yêu cầu lấy dữ liệu vị thế. Đơn vị milliseconds.');

insert into configsystem (GROUPNAME, VARNAME, VARVALUE, VARDESC)
values ('PULLINGINTERVAL', 'quotes', '500', 'Thời gian tối thiểu giữa 02 lần yêu cầu lấy dữ liệu giá. Đơn vị milliseconds. Mặc định 500ms.');

commit;
/