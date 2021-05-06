--
--
/
DELETE DEFERROR WHERE MODCODE = 'NFO';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90001,'[-90001] - Lỗi kết nối đến Database','[-90001]: Error connect to Database','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90002,'[-90002] - Lỗi chia cho 0','[-90002]: Divided by 0 errors','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90003,'[-90003]: Không đủ số dư tiền mặt','[-90003]: Available balance not enought','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90004,'[-90004] - Mã chứng khoán không tồn tại','[-90004]: Symbol not exist','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90005,'[-90005] - Định dạng message đầu vào không đúng','[-90005]: Input format incorrect message','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90006,'[-90006] - Không tìm thấy file chỉ định','[-90006]:Did not find the file specified','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90007,'[-90007] - Không đủ số dư chứng khoán','[-90007]: Not enough stock balance','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90008,'[-90008] - Không kết nối được đến Gateway','[-90008]: Not connect to Gateway','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90009,'[-90009] - Không kết nối được đến bank gateway','[-90009]: Not connect to bank gateway','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90010,'[-90010] - Giá chứng khoán không đúng','[-90010]: Price of securities not right','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90011,'[-90011] - Khối lượng chứng khoán không đúng','[-90011]: Quantity of securities not right','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90012,'[-90012] - Không đúng kiểu dữ liệu','[-90012]: Type of data not right','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90013,'[-90013] - Số quá lớn','[-90013]: Number too large','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90014,'[-90014] - Không đủ Pool','[-90014]: Pool not enough','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90015,'[-90015] - Không đủ Room','[-90015]: Room not enough','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90016,'[-90016]: Không đủ sức mua!','[-90016]: Buying power not enough!','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90017,'[-90017] - Tham số truyền vào không đúng giá trị','[-90017]: Incorrect parameter passed value','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90018,'[-90018]: Lỗi không xác định.','[-90018]: Error indefinite.','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90019,'[-90019] - Tài khoản không tồn tại','[-90019]: Account not exist','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90020,'[-90020] - Mã yêu cầu không đúng hoặc không tồn tại','[-90020]: Request code is incorrect or does not exist','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90021,'[-90021] - Yêu cầu không hợp lệ','[-90021]: Invalid Request','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90022,'[-90022] - Mã chứng khoán không hợp lệ','[-90022]: Symbol invalid','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90023,'[-90023] - Mã chứng khoán không được để trống','[-90023]: Symbol not null','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90024,'[-90024] - Mã chứng khoán không có trong danh mục','[-90024]: Symbol is not in the list','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90025,'[-90025] - Lỗi sai dữ liệu Master Data (dữ liệu không hợp lệ trong DB)','[-90025]: Data Master Data error ( invalid data in DB )','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90026,'[-90026] - Khối lượng chứng khoán không đúng cho bán tổng','[-90026]: Volume not right for selling securities total','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90027,'[-90027] - Lỗi không kết nối được đến Server (Server connection time out)','[-90027]: Not connect to Server (Server connection time out)','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90028,'[-90028] - Không đủ room nước ngoài','[-90028]: Not enough room abroad','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90029,'[-90029] - Trùng txnum+txdate','[-90029]: Duplicate txnum+txdate','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90030,'[-90030] - Đầu vào gọi store không đúng','[-90030]: Call store incorrect input','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90031,'[-90031] - Tài khoản bị cấm mua với mã chứng khoán vừa đặt.','[-90031]: Account get banned for buying the stocks just set.','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90032,'[-90032] - Tài khoản bị cấm bán với mã chứng khoán vừa đặt.','[-90032]: Account banned for stocks has placed.','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90033,'[-90033] - Khối lượng chứng khoán cần giải tỏa không hợp lệ','[-90033]: Stock volume should relieve invalid','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92000,'[-92000] - Số tiền nộp phải lớn hơn 0','[-92000]: The amount paid must be greater than 0','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92001,'[-92001] - Số tiền nộp không đúng định dạng','[-92001]: The amount paid is malformed ','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92002,'[-92002] - Số tiền nộp không được để trống','[-92002]: The amount paid should not be empty','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92003,'[-92003] - Ngày chứng từ không được để trống','[-92003]: Vouchers day should not be empty','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92004,'[-92004] - Ngày chứng từ không hợp lệ','[-92004]: Invalid vouchers days','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92005,'[-92005] - Ngày giao dịch không được để trống','[-92005]: Date of transaction should not be empty','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92006,'[-92006] - Ngày giao dịch không hợp lệ','[-92006]: Date of transaction is invalid','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92007,'[-92007] - Mã giao dịch để trống','[-92007]: Transaction code empty','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92008,'[-92008] - Mã giao dịch vượt quá độ dài qui định','[-92008]: Trading Code exceeds the length prescribed','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92009,'[-92009] - Số tiểu khoản để trống','[-92009]: Empty Account number','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92010,'[-92010] - Số tiểu khoản không tồn tại','[-92010]: Account not exist','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92011,'[-92011] - Trạng thái tiểu khoản không hợp lệ','[-92011] : Status account invalid','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-92012,'[-92012] - Số tiểu khoản đã tồn tại, không thể mở mới.','[-92012]: Account not exist, not open new.','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95000,'[-95000] - Chứng khoán này chỉ được đặt giá LO, ATC','[-95000]: Symbol are only pricing LO, ATC','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95001,'[-95001] - Chứng khoán này chỉ được đặt giá ATO, LO, MP, ATC','[-95001]: Symbol are only pricing ATO, LO, MP, ATC','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95002,'[-95002] - Chứng khoán này chỉ được đặt giá LO','[-95002]: Symbol are only pricing LO','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95003,'[-95003] - Không thể sửa lệnh do khối lượng không hợp lệ','[-95003]: Unable to fix the volume of orders due to invalid','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95004,'[-95004] - Không thể hủy lệnh do khối lượng không hợp lệ','[-95004]: Unable to cancel due to an invalid volume','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95005,'[-95005] - Không thể hủy lệnh do không tồn tại yêu cầu đặt lệnh','[-95005]: Can not cancel the request by the non-existent orders','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95006,'[-95006] - Trạng thái lệnh không hợp lệ, lệnh đang gửi lên sở','[-95006]: Status invalid command , the command is sent to the head','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95007,'[-95007] - Số lượng cổ phiếu đặt mua đặt bán tối thiếu, tối đa không hợp lệ','[-95007]: Number of shares The bid minimum , maximum invalid','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95008,'[-95008] - Bước giá (tick size) không hợp lệ','[-95008]: Tick size invalid','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95009,'[-95009] - Lô không hợp lệ','[-95009]: Trade lot invalid','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95010,'[-95010] - Giá không nằm trong khoảng trần sàn','[-95010]: Price is not between bare floor','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95011,'[-95011]: Loại giá (loại lệnh) không hợp lệ.','[-95011]: Type Price ( order types ) is invalid.','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95012,'[-95012] - Khách hàng nước ngoài khi đặt lệnh mua vượt room cho phép','[-95012]: Foreign customers when placing orders to buy exceeded room allows','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95013,'[-95013]: Tài khoản đang có lệnh đối ứng chưa khớp hết','[-95013]: Accounts are reciprocal unmatched command of all','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95014,'[-95014] - Không tìm thấy dữ liệu trong database','[-95014]: Not looking data in the database','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95015,'[-95015] - Lỗi không được hủy/sửa lệnh trong các phiên quy định.','[-95015]: Error not cancel / amend orders in the specified session.','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95016,'[-95016] - Khối lượng không được để trống','[-95016]: Volume can not be blank','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95017,'[-95017] - Khối lượng đặt vượt quá 19,990. Lệnh sẽ bị chia nhỏ. Tiếp tục?','[-95017]: Order volume exceeds 19.990 . The command will be split . Continue?','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95018,'[-95018] - Khối lượng đặt lệnh không hợp lệ','[-95018]: The volume of orders is invalid','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95019,'[-95019] - Khối lượng đặt lệnh vượt quá 100,000. Tiếp tục đặt lệnh?','[-95019]: The volume of orders exceeding 100,000 . Book orders?','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95020,'[-95020] - Khối lượng đặt lệnh vượt quá 999,900. Lệnh sẽ bị chia nhỏ. Tiếp tục?','[-95020]: The volume of orders exceeding 999.900 . The command will be split . Continue?','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95021,'[-95021] - Khối lượng không được vượt quá 20,000','[-95021]: The volume should not exceed 20,000','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95022,'[-95022] - Giá đặt lệnh không hợp lệ','[-95022]: Price invalid orders','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95023,'[-95023] - Trạng thái lệnh hủy/sửa không hợp lệ','[-95023]: Status of cancellations / repair invalid','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95024,'[-95024] - Không thể hủy/sửa lệnh thị trường','[-95024]: Unable to cancel / amend orders Market','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95026,'[-95026] - Mã CK bị ngưng giao dịch/hủy niêm yết/kiểm soát/cảnh báo…','[-95026]:  Ticker stopped trading / Delisting / control / warning','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95027,'[-95027] - Tài khoản mua không được trùng tài khoản bán','[-95027]: Account should not duplicate account purchase sale','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95028,'[-95028] - Mã CK lệnh TT base trên QC theo lệnh Quảng cáo','[-95028]: Ticker command base on the QC -ordered market Advertisement','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95029,'[-95029] - KL đặt lệnh TT base trên QC bằng KL đặt lệnh QC','[-95029]: The market volume of orders on the base in KL ordering QC','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95030,'[-95030] - Giá đặt lệnh TT base trên QC bằng giá đặt lệnh QC','[-95030]: The market command discounted price base on order QC','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95031,'[-95031] - Trạng thái lệnh QC ko đúng cho đặt lệnh TT','[-95031]: QC job status is not correct for market orders','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95032,'[-95032] - Không thể giải tỏa lệnh','[-95032]: Unable to relieve the command','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95033,'[-95033] - Số hiệu lệnh QC cho đặt lệnh TT không đúng','[-95033]: QC Order number for placing orders incorrectly market','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95034,'[-95034] - HSX không được đặt lệnh lô lẻ','[-95034]: HSX is not odd lot orders','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95035,'[-95035] - Không thể dùng tiền bảo lãnh để mua mã ck này','[-95035]: You can not use the money to buy stocks symbol guarantee this','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95036,'[-95036] - Lỗi trùng dữ liệu(quoteid) khi đặt lệnh tài khoản corebank','[-95036]: Duplicate data errors ( quoteid ) account when placing orders corebank','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95037,'[-95037] - Lệnh lô lẻ không đúng phiên','[-95037]: Odd lot orders incorrect versionn','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95038,'[-95038] - Lệnh sửa không truyền giá vào.','[-95038]: Edit order not passed on.','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95039,'[-95039]: Không thể sửa lệnh lô lẻ sang lô lớn, lô lớn sang lô lẻ','[-95039]: May not edit odd lot orders into large lots , large lots into odd lot','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95040,'[-95040] - Lệnh GTC tạm dừng do hệ thống đang nâng cấp','[-95040]: GTC order not support','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95041,'[-95041] - Lỗi do sở message khớp trùng nhau(lần 2)','[-95041] - Lỗi do sở message khớp trùng nhau(lần 2)','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95042,'[-95042] - Lỗi khớp lệnh do sở trả về giá không đúng','[-95042] - Lỗi khớp lệnh do sở trả về giá không đúng','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95043,'[-95043] - Ðóng cửa thị trường','[-95043] - Closing the market','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95046,'[-95046] - Vượt quá số lượng lệnh trùng nhau cho phép','[-95046] - Vượt quá số lượng lệnh trùng nhau cho phép','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95555,'[-95555] - Lệnh của tài khoản corebank đang ở trạng thái chờ hold tiền','[-95555]: Corebank is orders of accounts hold funds on hold','NFO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90035,'[-90035] - Khối lượng quyền không đủ để thực hiện giao dịch!','[-90035]: The volume of rights is not enough to execute the transaction!','NFO',null);
COMMIT;
/
