
DELETE deferror WHERE errnum IN (-700109);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-700109, '[-700109]: Order is sending to exchange, can not amend!', '[-700109]: Order is sending to exchange, can not amend!', 'OD', null);
COMMIT;
/
