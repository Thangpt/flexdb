DELETE templates WHERE CODE IN ('4000','4005');
insert into templates (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('4005', 'T4005', 'Thông báo khách hàng đăng ký mở tk online', 'E', 'T', 'P', 3, 'N', null, null, null, 'N');

insert into templates (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('4000', 'T4000', 'Xác nhận thông tin mở Tài khoản giao dịch Chứng khoán tại KBSV', 'E', 'T', 'P', 3, 'N', null, null, null, 'N');

COMMIT;
