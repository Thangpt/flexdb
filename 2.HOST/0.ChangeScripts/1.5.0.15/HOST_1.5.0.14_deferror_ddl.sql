DELETE FROM deferror WHERE errnum IN ('-200407','-200408','-200409','-200410');

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200408, '[-200408]: Gán trùng TraderID và tiểu khoản!', '[-200408]: Gán trùng TraderID và tiểu khoản!', 'CF', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200407, '[-200407]: Một tiểu khoản chỉ được đăng ký giao dịch qua Bloomberg một lần!', '[-200407]: Một tiểu khoản chỉ được đăng ký giao dịch qua Bloomberg một lần!', 'CF', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200409, '[-200409]: TraderID hoặc TK Bloomberg chỉ được khai chữ và số!', '[-200409]: TraderID hoặc TK Bloomberg chỉ được khai chữ và số!', 'CF', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200410, '[-200410]: Một tài khoản đặt lệnh tại Bloomberg chỉ được đăng ký một lần!', '[-200410]: Một tài khoản đặt lệnh tại Bloomberg chỉ được đăng ký một lần!', 'CF', null);

COMMIT;

