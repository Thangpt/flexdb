--
--
/
DELETE DEFERROR WHERE MODCODE = 'RE';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200901,'[-200901] : CMND không được để trống!','[-200901] : IDCODE IS INVALID!','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540050,'[-540050] Tài khoản đã giải ngân','[-540050] Release amount already!','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540101,'[-540101] Trùng biểu lãi suất','[-540101] Rate ID is duplicate','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-560001,'Trùng biểu lãi suất của loại hình','Interest table is duplicated','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-560002,'Không tìm thông tin tham số sản phẩm','Product information not found','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-560003,'Loại tài khoản không hợp lệ','The type of remiser account is invalid','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-560004,'Trạng thái tài khoản không hợp lệ','The status of remiser account is invalid','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-560005,'Vượt số dư được phép rút','Exceed available balance!','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-560006,'Chưa thanh toán hoa hồng cho môi giới','Commission still unpaid!','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561001,'Trùng thông tin môi giới','ERR_DUPLICATE_REMISER','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561002,'Môi giới đã có tài khoản','ERR_REMISER_HAS_ACCOUNT','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561003,'Không tìm thấy môi giới','RE NOT FOUND','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561004,'Trùng loại hình môi giới được phép sử dụng','ERR_DUPLICATE_REMISER_RETYPE','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561005,'Loại hình đã có tài khoản được mở','ACTYPE ALREADY INUSE ','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561006,'Loại hình tiểu khoản không được phép sử dụng với loại hình môi giới này','THIS AFTYPE CANNOT USE FOR THIS RETYPE','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561007,'Môi giới không được phép dùng loại hình tiểu khoản này','REMISIER CANNOT USE THIS AFTYPE','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561008,'Môi giới chỉ được sử dụng một trong các vai trò Môi giới/Chăm sóc tài khoản/Quan hệ khách hàng','Remiser can only use one of these role: Remiser/Careby/Customer Relationship','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561009,'Nhóm gốc không được phép có nhóm cấp trên','ERR_ROOT_CANNOT_HAS_PARENT','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561010,'Trùng mã nhóm cấp trên với mã nhóm hiện tại','ERR_SAME_GROUPID_AND_PARENTID','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561011,'Thiếu mã nhóm cấp trên','ERR_PARENTID_ISEMPTY','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561012,'Không được khai báo trùng vai trò cho tiểu khoản KH','ERR_REAFLNK_DUPLICATE_RETYPE','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561013,'Đăng ký trùng vai trò của môi giới cho tiểu khoản KH','ERR_REAFLNK_DUPLICATE_REMISER_REROLE','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561014,'[-561014] Một môi giới chỉ thuộc một nhóm','[-561014] ERR_REAFLNK_REMISER_BELONG2ONCEGROUP','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561015,'[-561015] Trùng mã phí giảm trừ','[-561015] Dupplicate RERFEE ID','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561016,'[-561016] Trùng mã phí giảm trừ','[-561016]Duplicate rerfee code','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561017,'[-561017] : Loại hình môi giới hiện tại không đúng','[-561017] : Invalid current REtype','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561018,'[-561018] : Loại hình môi giới tương lai không đúng','[-561018] : Invalid future REtype','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561019,'[-561019] : Loại hình môi giới đang được sử dụng','[-561019] : REtype in used','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561020,'[-561020] : Trùng vai trò môi giới - chăm sóc hộ','[-561020] : ERR_REAFLNK_DUPLICATE_ROLE_DG','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561021,'Nhóm đã có môi giới','Group has remiser','RE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561022,'Chưa thanh toán hoa hồng cho trưởng nhóm','Leader has commision','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561023,'[-561023] : Các tiểu khoản của khách hàng phải được gán vào 1 môi giới','[-561023] : All account must be same remiser','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561024,'[-561024] : Trùng thứ tự ưu tiên hiệu lực','[-561024] : duplicate effective order','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561025,'[-561025] : Trùng tính chất phí giảm trừ','[-561025] : Duppliacte rerfee property','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561026,'[-561026] : Môi giới chuyển và nhận phải cùng vai trò','[-561026] : Remisers must be same role','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561027,'[-561027] : Tổng tỷ lệ nhận hoa hồng của các trường nhóm không được lớn hơn 100','[-561027] : Total group rate must be <= 100','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561028,'[-561028] : Mã user hệ thống Flex đã được gán cho MG trong hệ thống, không thể gán trùng!','[-561028] : Already have setup','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561029,'[-561029] : Không tồn tại mã User hệ thống Flex!','[-561029] : Tlid don''t exists!','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561030,'[-561030] : Mã file import không đúng!','[-561030] : FIELDID IS INVALID!','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561031,'[-561031] : Ngày chứng từ không được lớn hơn ngày hiệu lực !','[-561031] : TXDATE IS INVALID!','RE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-561110,'Mã nhóm cấp trên không hợp lệ (trỏ vòng tròn)','ERR_PARENTID_ISINVALID','RE',null);
COMMIT;
/
