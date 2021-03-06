--
--
/
DELETE DEFERROR WHERE MODCODE = 'OD';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-95049,'[-95049] Tài khoản Margin không được mua chứng quyền','[-95049] Margin account can not buy the certificate','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100128,'[-100128] Mã chứng quyền đã đáo hạn','[-100128] Code warrants have maturity','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100129,'[-100129] Chỉ cho phép mua chứng quyền trên tài khoản thường','[-100129] Chỉ cho phép mua chứng quyền trên tài khoản thường','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200013,'[-200013]: Trạng thái tiểu khoản không phù hợp !','Account status invalid!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200057,'Chua dang ky loai hinh','Invalid registration type!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700001,'[-700001]: gc_ERRCODE_OD_ACTYPE_DUPLICATED','[-700001]: gc_ERRCODE_OD_ACTYPE_DUPLICATED','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700002,'[-700002]: gc_ERRCODE_OD_GLGRP_NOTFOUND','[-700002]: gc_ERRCODE_OD_GLGRP_NOTFOUND','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700003,'[-700003]: ERR_OD_ODTYPE_NOTFOUND','[-700003]: ERR_OD_ODTYPE_NOTFOUND','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700011,'Sai lo giao dich','Trade lot invalid','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700012,'[-700012]:ERR_OD_LO_PRICE_ISNOT_FLOOR_CEILLING','[-700012]:ERR_OD_LO_PRICE_ISNOT_FLOOR_CEILLING','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700013,'[-700013]:Chưa khai báo thông tin bước giá cho chứng khoán','[-700013]:ERR_OD_TICKSIZE_UNDEFINED','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700014,'[-700014]: Bước giá không phù hợp','[-700014]: TICKSIZE INCOMPLIANT!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700015,'[-700015]: Không được MUA/BÁN cùng một chứng khoán trong ngày','[-700015]: BUY/SELL same symbol dur','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700016,'[-700016]: Đang có lệnh đối ứng chờ khớp  ','[-700016]: Corresponding order pending for mathcing','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700018,'[-700018]: Số lượng yêu cầu hủy không phù hợp','[-700018]: Cancel QTTY invalid','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700021,'[-700021]: ERR_OD_STSCHD_STATUSINVALID!','[-700021]: ERR_OD_STSCHD_STATUSINVALID!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700022,'[-700022]: ERR_OD_ODMAST_CANNOT_DELETE','[-700022]: ERR_OD_ODMAST_CANNOT_DELETE','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700023,'[-700023]: ERR_OD_LISTED_NEEDCUSTODYCD','[-700023]: ERR_OD_LISTED_NEEDCUSTODYCD','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700026,'[-700026]: ERR_OOD_STATUS_BLOCKED!','[-700026]: ERR_OOD_STATUS_BLOCKED!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700027,'[-700027]: ERR_OOD_STATUS_SENT!','[-700027]: ERR_OOD_STATUS_SENT!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700030,'[-700030]: Lenh dang trong qua trinh day vao san','[-700030]: Order is sending, try again later','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700035,'[-700035]: ERR_OD_ATO_ORDER_IN_LISTTING_DATE!','[-700035]: ERR_OD_ATO_ORDER_IN_LISTTING_DATE!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700036,'[-700036]: ERR_OD_ORDER_OVER_NUMBER_CORRECTION!','[-700036]: ERR_OD_ORDER_OVER_NUMBER_CORRECTION!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700037,'[-700037]: ERR_OD_ORDER_NOT_FOUND!','[-700037]: ERR_OD_ORDER_NOT_FOUND!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700038,'[-700038]:ERR_OD_ERROR_OVER_QTTY','[-700038]:ERR_OD_ERROR_OVER_QTTY','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700039,'[-700039]: Adv message status is invalid!','[-700039]: Adv message status is invalid: Cancel Or Deal !','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700043,'[-700043]: ERR_OD_ERROR_ORDER_MATCHED','[-700043]: ERR_OD_ERROR_ORDER_MATCHED','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700044,'[-700044]: ERR_OD_AMT_NOT_ENOUGHT!','[-700044]: ERR_OD_AMT_NOT_ENOUGHT!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700045,'[-700045]: ERR_OD_QTTY_NOT_ENOUGHT!','[-700045]: ERR_OD_QTTY_NOT_ENOUGHT!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700048,'[-700048]: ERR_OD_TRADERID_NOT_INVALID','[-700048]: ERR_OD_TRADERID_INVALID','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700049,'[-700049]: INCORRECT VOLUME','[-700049]: INCORRECT VOLUME','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700050,'[-700050]: ERROR_OD_INCORRECT_PRICE','[-700050]: ERROR_OD_INCORRECT_PRICE','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700051,'[-700051]: Không đủ ROOM cho khách hàng nước ngòai !','[-700051]: ERR_OD_ROOM_NOT_ENOUGH','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700052,'[-700052]: ERR_OD_TRADEPLACE_HOSE_NOT_AMEND','[-700052]: ERR_OD_TRADEPLACE_HOSE_NOT_AMEND','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700053,'[-700053]: ERR_OD_GTC_SL_NOT_AMEND','[-700053]: ERR_OD_GTC_SL_NOT_AMEND','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700054,'[-700054]: NOT_ENOUGHT_REMAIN_QUANTITY','[-700054]: NOT_ENOUGHT_REMAIN_QUANTITY','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700055,'[-700055]: ERR_OD_ORDER_UNDER_MIN_AMOUNT','[-700055]: ERR_OD_ORDER_UNDER_MIN_AMOUNT','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700062,'[-700062]: Hệ thống không cho phép mua trên tiểu khoản margin!','[-700062]: System not allow to buy on margin account','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700063,'[-700063]: Khách hàng không cho phép đặt mua trên tiểu khoản margin!','[-700063]: Customer not allow to buy on margin account','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700064,'[-700064]: CK đặt mua margin không nằm trên danh sách CK margin cho phép!','[-700064]: Symbol is not margin allowed','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700065,'[-700065]: Lệnh bán chứng khoán vượt quá hạn mức về tỉ lệ hoặc giá trị giao dịch!','[-700065]: Order exceed limit of transaction ','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700066,'[-700066]: Số ngày trả chậm phải nằm trong khoản 0 đến 2','[-700066]: Late payment  day from 0 to 2','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700067,'[-700067]: TL trả chậm phải nằm trong khoảng từ 0 đến 100 (đơn vị %)','[-700067]: Late payment  ratio from 0 to 100 (%)','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700068,'[-700068]: Số ngày trả chậm và tỉ lệ trả chậm đồng thời phải bằng 0 hoặc khác 0!','[-700068]: Bpth Late payment  day and ratio must be 0 or not 0','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700069,'[-700069]: Chứng khoán hạn chế giao dịch trên tiểu khoản hoặc loại hình tiểu khoản theo chính sách công ty!','[-700069]: Limited transfer SE or policy account','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700070,'[-700070]: Tiểu khoản kết nối ngân hàng phải khai báo tỉ lệ trả chậm là 100%!','[-700070]: Corebank require Late payment  ratio 100%','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700071,'[-700071]: Chứng khoán này chỉ được đặt trong phiên mở cửa','[-700071]: This symbol order only in Pre_Open session','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700072,'[-700072]: Chứng khoán này chỉ được đặt trong phiên liên tục','[-700072]: This symbol order only in Open session','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700073,'[-700073]: Chứng khoán này chỉ được đặt trong phiên đóng cửa','[-700073]: This symbol order only in Pre_Close session','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700081,'[-700081]: Lệnh còn giá trị ứng trước!','[-700081]: Order remains AD amount!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700082,'[-700082]: Chứng khoán chờ về của lệnh đã được cầm cố!','[-700082]: Receivable securities of order are mortgaged!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700083,'[-700083]: Lệnh sửa lỗi chưa được khớp hết!','[-700083]: Correcting orders not yet fully matched!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700084,'[-700084]: Tài khoản corebank đã thanh toán không được sửa số lượng khớp lệnh!','[-700084]: Core bank account already paid, can not adjust matched QTTY!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700085,'[-700085]: Chỉ có thể xác nhận các lệnh chưa xác nhận!','[-700085]: The order has been confirmed before!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700090,'[-700090]: Trùng mã định danh','[-700090]: Trùng mã định danh','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700100,'[-700100]: Lenh khong duoc phep huy sua ','-700100]: Order not allow cancel or edit','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700101,'[-700101]: Lenh duoc phep huy sua ','-700101]: Order allow cancel or edit','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700102,'[-700102]: Trang thai lenh khop hop le ','-700102]: Status of order not invalid','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700103,'[-700103]: Lenh huy sai phien ','-700103]: Cancel order wrong version ','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700104,'[-700104]: Lệnh lô chẵn chỉ được sửa thành lệnh lô chẵn','[-700104]: Round lot order can only changed to round lot order','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700105,'[-700105]: Lệnh lô lẻ chỉ được sửa thành lệnh lô lẻ','[-700105]: Odd lot order can only changed to odd lot order','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700106,'[-700106]: Lệnh sửa phải khác lệnh gốc','[-700106]: Adjust order must be different from original order','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700107,'[-700107]: Không được sửa từ lệnh thường sang MOK,MAK,MTL và ngược lại','[-700107]:  Can not adjust Normal order to MOK,MAK,MTL and conversely','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700108,'[-700108]: Lệnh không được phép sửa','[-700108]:  Order not allowed to adjust','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700109,'[-700109]: Order is sending to exchange, can not amend!','[-700109]: Order is sending to exchange, can not amend!','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700110,'[-700110]: TPDN không được đặt loại giá MTL, MOK, MAK, PLO!','[-700110]:  Corporate Bond do not user pricetype MTL, MOK, MAK, PLO!','OD',null);
INSERT INTO DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-700120, '[-700120]: Rule check giá không hợp lệ!', '[-700120]: Invalid price check type!', 'OD', null);
INSERT INTO DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-700121, '[-700121]: Lệnh đang có giao dịch liên quan!', '[-700121]: Order currently in transaction!', 'OD', null);
INSERT INTO DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-700122, '[-700122]: Không tìm thấy thông tin lệnh tổng hoặc trạng thái không hợp lệ!', '[-700122]: Manual Order not found or invalid status!', 'OD', null);
INSERT INTO DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-700123, '[-700123]: Khối lượng chờ xử lý không đủ!', '[-700123]: Waiting order quantity not enough!', 'OD', null);
INSERT INTO DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-700124, '[-700124]: Giá đặt không thỏa mãn điều kiện check giá!', '[-700124]: Order price not valid!', 'OD', null);
INSERT INTO DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-700125, '[-700125]: Không tìm thấy lệnh!', '[-700125]: Invalid order!', 'OD', null);
INSERT INTO DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-700126, '[-700126]: Chưa đến giờ giải tỏa lệnh!', '[-700126]: Not Done4day time yet!', 'OD', null);
INSERT INTO DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-700127, '[-700127]: Đang trong phiên giao dịch HOSE!', '[-700127]: Trading time on HSX!', 'OD', null);
INSERT INTO DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-700128, '[-700128]: Đang trong phiên giao dịch HNX!', '[-700128]: Trading time on HNX!', 'OD', null);
INSERT INTO DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-700129, '[-700129]: Lỗi khi sửa lệnh!', '[-700129]: Error when amend order!', 'OD', null);
INSERT INTO DEFERROR (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-700130, '[-700130]: Lệnh đã có plan thực hiện!', '[-700130]: Exists execute plan for this order!', 'OD', null);

INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700168,'[-700168] - Lệnh FO không hủy sửa được bằng kênh Flex','[-700168] - Lệnh FO không hủy sửa được bằng kênh Flex','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-701111,'[-701111]: KL sửa phải lớn hơn khối lượng đã khớp','[-701111]: Adjust QTTY must be greater than matched amount','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-707707,'[-707707]: Lệnh đã được thanh toán bù trừ','[-707707]: Lệnh đã được thanh toán bù trừ','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900005,'[-900005]: Khối lượng lệnh sửa vượt quá 999,900','[-900005]: Edited volume orders exceeding 999.900','OD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900006,'[-900006]: Lệnh đang chờ ký quỹ ngân hàng. Không được phép sửa','[-900006]: Orders pending bank deposit . Not allowed to edit','OD',null);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-700004, '[-700004]:Rổ lệnh vượt quá số lượng lệnh nháp cho phép!', '[-700004]:Rổ lệnh vượt quá số lượng lệnh nháp cho phép!', 'OD', 0);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-700005, '[-700005]: Tên nhóm không được trùng tên nhóm DEFAULT!', '[-700005]: Tên nhóm không được trùng tên nhóm DEFAULT!', 'OD', 0);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-700006, '[-700006]: Nhóm lệnh không thuộc user tuong ứng!', '[-700006]: Nhóm lệnh không thuộc user tuong ứng', 'OD', 0);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-700007, '[-700007]: Không cho phép xóa nhóm khi vẫn còn lệnh trong nhóm!', '[-700007]: Không cho phép xóa nhóm khi vẫn còn lệnh trong nhóm!', 'OD', 0);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-700091, '[-700091]: Với trái phiếu chính phủ thì bắt buộc phải có mã định danh', '[-700091]: Với trái phiếu chính phủ thì bắt buộc phải có mã định danh', 'OD', null);
COMMIT;
/
