delete FROM DEFERROR WHERE ERRNUM = -901215;

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-901215, '[-901215]: Trạng thái tài khoản không hợp lệ', '[-901215]: Invalid status account', 'CF', null);

commit;
