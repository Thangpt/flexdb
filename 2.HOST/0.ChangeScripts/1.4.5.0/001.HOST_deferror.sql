DELETE FROM deferror WHERE errnum ='-100128';

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100128, '[-100128] Mã chứng quyền đã đáo hạn', '[-100128] Code warrants have maturity', 'OD', null);

COMMIT;

DELETE FROM deferror WHERE errnum ='-100129';

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100129, '[-100129] Chỉ cho phép mua chứng quyền trên tài khoản thường', '[-100129] Chỉ cho phép mua chứng quyền trên tài khoản thường', 'OD', null);

commit;

DELETE FROM deferror WHERE errnum ='-95049';

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-95049, '[-95049] Tài khoản Margin không được mua chứng quyền', '[-95049] Margin account can not buy the certificate', 'OD', null);

commit;