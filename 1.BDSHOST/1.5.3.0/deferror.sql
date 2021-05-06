DELETE deferror WHERE errnum IN ('-200309','-200310','-200311','-200312','-200313','-200314','-200315','-200316' );

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200309, '[-200309] Cần đăng ký hình thức xác thực cho kênh giao dịch All trước!', '[-200309] Cần đăng ký hình thức xác thực cho kênh giao dịch All trước!', 'CF', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200310, '[-200310] Chứng thư số chỉ đăng ký cho kênh Online và Home!', '[-200310] Chứng thư số chỉ đăng ký cho kênh Online và Home!', 'CF', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200311, '[-200311] Token là bắt buộc nhập!', '[-200311] Token là bắt buộc nhập!', 'CF', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200312, '[-200312] Phải xóa các kênh Online/Home/Priceboard trước!', '[-200312] Phải xóa kênh Online/Home/Priceboard trước!', 'CF', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200313, '[-200313] Hình thức xác thực không trùng khớp với các tiểu khoản khác!', '[-200313] Hình thức xác thực không trùng khớp với các tiểu khoản khác!', 'CF', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200314, '[-200314] Kênh giao dịch trên chưa được khai báo trên tài khoản được ủy quyền', '[-200314] Kênh giao dịch trên chưa được khai báo trên tài khoản được ủy quyền', 'CF', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200315, '[-200315] Thông tin Serial Token không khớp với các kênh còn lại', '[-200315] Thông tin Serial Token không khớp với các kênh còn lại', 'CF', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200316, '[-200316] Thông tin Serial Token đã tồn tại của khách hàng khác.', '[-200316] Thông tin Serial Token đã tồn tại của khách hàng khác.', 'CF', null);


COMMIT;
