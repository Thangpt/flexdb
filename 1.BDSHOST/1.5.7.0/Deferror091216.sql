delete from DEFERROR where ERRNUM in ('-901216','-901217');
insert into DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-901216, '[-901216]: Tiểu khoản đã đăng ký sản phẩm', '[-901216]: ERR_CF_REGISTER_PORODUC_NOT_EXIT', 'CF', 0);
insert into DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-901217, '[-901217]: Tiểu khoản đã hủy đăng ký sản phẩm', '[-901217]: ERR_CF_REGISTER_PORODUC_NOT_EXIT', 'CF', 0);
commit;