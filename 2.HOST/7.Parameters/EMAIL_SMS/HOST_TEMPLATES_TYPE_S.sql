DELETE TEMPLATES WHERE TYPE = 'S'; 

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('0323', 'T0323', 'Mẫu SMS thông báo kết quả khớp lệnh', 'S', 'T', 'P', 3, 'Y', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('0326', 'T0326', 'Mẫu SMS nhắc việc trước 2 ngày cuối cùng của thời gian thực hiện quyền mua PHT', 'S', 'T', 'D', 3, 'N', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('0329', 'T0329', 'Mẫu SMS thông báo số dư đầu ngày', 'S', 'T', 'P', 3, 'Y', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('0330', 'T0330', 'Mẫu SMS thông báo mật khẩu giao dịch qua điện thoại', 'S', 'T', 'P', 3, 'N', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('0331', 'T0331', 'Mẫu SMS chúc mừng sinh nhật', 'S', 'T', 'P', 3, 'N', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('0332', 'T0332', 'Mẫu SMS thông báo món vay đến hạn x ngày', 'S', 'T', 'P', 3, 'N', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('0333', 'T0333', 'Mẫu SMS thông báo quyền được hưởng', 'S', 'T', 'P', 3, 'N', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('0334', 'T0334', 'Mẫu SMS thông báo mốc vận hành hệ thống', 'S', 'T', 'P', 3, 'N', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('0335', 'T0335', 'Mẫu SMS thông báo thay đổi mật khẩu online', 'S', 'T', 'P', 3, 'N', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('0555', 'T0555', 'SMS thông báo Monitor', 'S', 'T', 'P', 3, 'Y', null, null, 'Y', 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('0808', 'T0808', 'Thu thong bao cac moc van hanh', 'S', 'T', 'P', 3, 'N', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('0809', 'T0809', 'SMS gui thong bao voi noi dung tuy chon soan thao', 'S', 'T', 'P', 3, 'N', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('324A', 'T324A', 'Mẫu SMS thông báo phát sinh tăng số dư tiền trên tài khoản giao dịch', 'S', 'T', 'P', 3, 'Y', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('324B', 'T324B', 'Mẫu SMS thông báo phát sinh giảm số dư tiền trên tài khoản giao dịch', 'S', 'T', 'P', 3, 'Y', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('327A', 'T327A', 'Mẫu SMS thông báo bổ sung tài sản đảm bảo', 'S', 'T', 'P', 3, 'N', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('328A', 'T328A', 'Mẫu SMS thông báo đăng ký SMS thành công', 'S', 'T', 'P', 3, 'N', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('328B', 'T328B', 'Thông báo thông tin đăng nhập trực tuyến', 'S', 'T', 'P', 3, 'N', null, null, null, 'N');

insert into TEMPLATES (CODE, NAME, SUBJECT, TYPE, FORMAT, CYCLE, INTERVAL, REQUIRE_REGISTER, ATTACHMENT_ID, EXPORT_PATH, ALLOW_ZIP, AUTHENTICATION)
values ('4002', 'T4002', 'Mẫu SMS hướng dẫn nộp tiền', 'S', 'T', 'P', 3, 'N', null, null, null, 'N');

COMMIT;
