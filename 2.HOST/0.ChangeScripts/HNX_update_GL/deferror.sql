
DELETE FROM deferror WHERE ERRNUM='-100161';
 
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100161, '[-100161] Đang có yêu cầu thay đổi chưa xử lý hoàn tất!', '[-100161] Have pending request!', 'SA', null);

COMMIT; 

DELETE FROM deferror WHERE ERRNUM='-100162';
 
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100162, '[-100162] Mật khẩu mới tối thiểu 8 ký tự gồm chữ, số, ký tự đặc biệt, hoa thường!', '[-100162] Pls input new password!', 'SA', null);

COMMIT; 

DELETE FROM deferror WHERE ERRNUM='-100163';
 
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-100163, '[-100163] Không được thay đổi tên đăng nhập!', '[-100163] Pls do not change username !', 'SA', null);

COMMIT; 

