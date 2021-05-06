DELETE deferror WHERE errnum = '-100847';
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100847, '[-100847]: Giá trị nhập vào có độ dài phải nằm trong khoảng 1 -> 3!', '[-100847]: Giá trị nhập vào có độ dài phải nằm trong khoảng 1 -> 3!', null, null);

COMMIT;
