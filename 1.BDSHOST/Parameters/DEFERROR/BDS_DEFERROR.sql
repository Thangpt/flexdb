--
--
/
DELETE DEFERROR WHERE MODCODE is null;
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100809,'[-100809]: Giá trị tham số bắt buộc phải là số!','[-100809]: Value must be a number!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100810,'[-100810]: Giá trị số bắt buộc phải lớn hơn 0!','[-100810]: The number must be larger than 0!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100811,'[-100811]: Giá trị tham số bắt buộc không có phần thập phân!','[-100811]: The number must not be a decimal!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100812,'[-100812]: Giá trị số có độ dài tối đa 14 ký tự!','[-100812]: The length of number can not over 14 characters!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100813,'[-100813]: Giá trị tham số phải không bao bồm khoảng trắng!','[-100813]: Value can not be inclued blank characters!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100814,'[-100814]: Giá trị số phải không bao gồm ký tự phân cách phần ngàn (dấu phẩy)!','[-100814]: The number can not be formated by comma!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100815,'[-100815]: số ngày cho mỗi gia hạn không được phép vượt quá tổng chu kì món vay!','[-100815]: The max debt days must be larger than the debt days!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100816,'[-100816]: Giá trị tỉ lệ chứng khoán niêm yết không hợp lệ!','[-100816]: The max debt quantity rate is invalid!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100817,'[-100817]: Giá trị cho phép Margin không hợp lệ, Y: có cho phép, N: không cho phép!','[-100817]: Value allows Margin invalid , Y : whether to allow, N : not allowed!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100818,'[-100818]: Giá trị nhập vào phải nằm trong khoảng 0 -> 100!','[-100818]: The value entered must be between 0 - > 100 !',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100845,'[-100845]: Loại hình tiểu khoản đã được sử dụng, không cho phép chuyển đổi loại hình margin khác nhớm!','[-100845]: Sub-account type has been used , do not allow other margin type conversion group!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100847,'[-100847]: Giá trị nhập vào có độ dài phải nằm trong khoảng 1 -> 3!','[-100847]: Giá trị nhập vào có độ dài phải nằm trong khoảng 1 -> 3!',null,null);
INSERT INTO deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-180046, '[-180046]: Loại hình vay T0 phải để tham số nguồn công ty hoặc ngân hàng và không tuân thủ hệ thống!', '[-180046]: T0 type of loan to the company or bank to take the source and does not comply with the system !', null, null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180047,'[-180047]: Loại hình margin là CL phải chọn loại hình vay mặc định!','[-180047]: CL type of margin is to choose which type of loan default!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180048,'[-180048]: Loại hình margin không phải loại hình thường, tham số corebank yêu cầu đặt là NO!','[-180048]: Type of margin is not usually the type parameter set to NO corebank requirements!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200208,'[-200208]: CMT/HC/GPKD của Chủ tài khoản đã hết hạn!','[-200208]: CMT/HC/GPKD của Chủ tài khoản đã hết hạn!',null,null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200209,'[-200209]: CMT/HC/GPKD của Khách hàng yêu cầu giao dịch và Chủ tài khoản đã hết hạn!','[-200209]: CMT/HC/GPKD của Khách hàng yêu cầu giao dịch và Chủ tài khoản đã hết hạn!',null,null);
COMMIT;
/
