--
--
/
DELETE DEFERROR WHERE MODCODE = 'HT';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-107,'[H107]: Tên đăng nhập hoặc mật khẩu không đúng','[H107]: Username or password invalid','HT',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-109,'[H109]: Tài khoản này đã bị chặn','[H109]: Username status invalid','HT',null);
COMMIT;
/
