DELETE FROM deferror WHERE errnum IN ('-200407','-200408');

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200408, '[-200408]: Gán trùng TraderID và tiểu khoản!', '[-200408]: Gán trùng TraderID và tiểu khoản!', 'CF', null);

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200407, '[-200407]: Một tiểu khoản chỉ được đăng ký giao dịch qua Bloomberg một lần!', '[-200407]: Một tiểu khoản chỉ được đăng ký giao dịch qua Bloomberg một lần!', 'CF', null);

COMMIT;

