DELETE FROM deferror WHERE errnum ='670101'; 

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-670101, '[-670101] : Tài khoản kết nối NH không được thực hiện chức năng này', '[-670101] : Do not allow Bank Account do this transaction ', 'RM', 0);

COMMIT; 
