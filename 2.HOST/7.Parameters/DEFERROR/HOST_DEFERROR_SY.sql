--
--
/
DELETE DEFERROR WHERE MODCODE = 'SY';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (1,'[1]: Mã sự kiện không tồn tại','[1]: Error execute in database.','SY',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-1,'[-1]: Lỗi hệ thống.','[-1]: System error.','SY',null);
COMMIT;
/
