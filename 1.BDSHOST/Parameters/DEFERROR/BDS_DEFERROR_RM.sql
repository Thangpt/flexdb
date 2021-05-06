﻿--
--
/
DELETE DEFERROR WHERE MODCODE = 'RM';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (0,'Thanh Cong','Successful','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-660001,'Tr?ng thái ngân hàng không h?p l?','Bank status invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-660002,'Tài kho?n không th? k?t n?i v?i ngân hàng','Account cannot connect to bank!','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-660003,'Ð?t k?t n?i t?i ngân hàng','Cannot connect to bank','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-660004,'Tr?ng thái thay d?i không dúng','Cannot revert bank status','RM',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-660005,'Tài kho?n Offline c?a ngân hàng không tìm th?y','Ofline bank account not found','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-660006,'S? du không d? d? phong t?a','BALANCE NOT ENOUGH TO BLOCK','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-660007,'S? du không d? d? gi?i t?a','BALANCE NOT ENOUGH TO UNBLOCK','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-660008,'S? ti?n ph?i là ki?u s?','AMOUNT IS NOT NUMBER','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-660009,'Ngày b?t d?u không dúng d?nh d?ng','BEGIN DATE TYPE INVALID','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-660010,'Ngày k?t thúc không dúng d?nh d?ng','End date type invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-660012,'[-660012] : Không tìm thấy ngân hàng','[-660012] : Bank not found','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-660013,'[-660013] : Trạng thái ngân hàng mới trùng với trạng thái cũ','[-660013] : Bank status duplicated','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-664444,'Khong tim thay ket noi den ngan hang','Not find connect to Bank','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-665555,'BankGWFss tam ngung de chay Batch ','BankGWFss tam ngung de chay Batch','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670001,'[-670001]: Bảng kê đang chờ duyệt!','[-670001]: Batch transfer is waitting','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670002,'[-670002]: Bảng kê đang duyệt','[-670002]: Batch transfer is confirming','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670003,'[-670003]: Bảng kê đang giải mã','[-670003]: List is decrypting','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670004,'[-670004]: Bảng kê đã duyệt','[-670004]: List was approved','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670005,'[-670005]: Bảng kê đã sửa','[-670005]: List was corrected','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670006,'[-670006]: Bảng kê đã huỷ','[-670006]: List canceled','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670007,'[-670007]: Bảng kê lỗi','[-670007]: List error','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670008,'[-670008] : File bảng kê không tồn tại','[-670008] : List file not found','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670009,'[-670009]: Chữ ký không đúng','[-670009]: Invalid signature','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670010,'[-670010]: Định dạng XML không đúng','[-670010]: Invalid XML format','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670011,'[-670011]: Bảng kê định dạng không đúng','[-670011]: Batch transfer invalid format','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670012,'[-670012]: Bảng kê trùng version','[-670012]: Duplicate version of batch transfer','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670013,'[-670013]: Loại bảng kê không đúng','[-670013]: Transfer type not found!','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670014,'[-670014] : Bảng kê không tồn tại','[-670014] : Batch transfer not found!','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670015,'[-670015]: ID của bàng kê không đúng','[-670015]: List ID invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670016,'[-670016]: ID của bàng kê không đúng','[-670016]: List ID invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670017,'[-670017]: Ngày chuyển bảng kê không phải là ngày hiện tại','[-670017]: Batch date not present','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670018,'[-670018]: Ngày thực hiện nhỏ hơn ngày hiện tại','[-670018]: Affected date not current date','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670019,'[-670019]: Mã TK chứng khoán không thuộc ngân hàng quản lý','[-670019]: Custody code invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670020,'[-670020]: Mã chuyển trùng','[-670020]: Transfer code duplicate','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670021,'[-670021]: Số tiền chuyển trong bảng kê lỗi','[-670021]: Amount in batch transfer invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670022,'[-670022]: Định dạng mã bảng kê không đúng','[-670022]: List code format invalid ','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670023,'[-670023]: Không thể giải nén','[-670023]: Cannot unzip','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670024,'[-670024] : Người ký chưa được đăng ký','[-670024] : Signer was not registered','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670025,'[-670025]: Ngân hàng không hỗ trợ chức năng này','[-670025]: This bank does not support this function','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670026,'[-670026]: Mã đầu vào không đúng','[-670026]: Parameter invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670027,'[-670027]: Số dư phong toả không đổi','[-670027]: Hold amount not change','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670028,'[-670028]: HoldID bị khoá','[-670028]: HoldID locked','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670029,'[-670029]: HoldID đã xoá','[-670029]: HoldID deleted','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670030,'[-670030]: Ngày phong toả không phải là ngày hiện tại','[-670030]: Hold date not current date','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670031,'[-670031]: Tài khoản không được phép truy cập','[-670031]: Account access permission deneied','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670032,'[-670032]: Tài khoản không đúng','[-670032]: Account invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670033,'[-670033]: Tài khoản không tồn tại','[-670033]: Account not found','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670034,'[-670034]: Tài khoản đã khoá','[-670034]: Account blocked','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670035,'[-670035]: Tài khoản đã đóng','[-670035]: Account closed','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670036,'[-670036]: Tài khoản không phong toả được','[-670036]: Account not holded','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670037,'[-670037]: Tài khoản không giải toả được','[-670037]: Account cannot unhold','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670038,'[-670038]: Gateway timeout','[-670038]: Gateway timeout','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670039,'[-670039]: Chữ ký không đúng','[-670039]: Signature invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670040,'[-670040]: Số dư không đủ để phong toả','[-670040]: Avail balance not enough to hold','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670041,'[-670041]: Số dư không đủ để thực hiện','[-670041]: Avail balance not engough to process','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670042,'[-670042]: Số dư giải toả lớn hơn số dư phong toả','[-670042]: Unhold balance greater than hold balance','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670043,'[-670043]: Ngoài giờ giao dịch','[-670043]: Out of transaction time','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670044,'[-670044]: Mật khẩu không đúng','[-670044]: Password invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670045,'[-670045]: Mã công ty chứng khoán không đúng','[-670045]: Securities Company CODE invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670046,'[-670046]: Không đúng định dạng ngày','[-670046]: invalid datetime format','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670047,'[-670047]: Không đúng số dư','[-670047]: Balance invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670048,'[-670048]: Có ký tự lạ trong file xml','[-670048]: invalid character in xml','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670049,'[-670049]: Mã tiền tệ không tồn tại','[-670049]: Currency code des not exist','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670050,'[-670050]: Bảng kê không tồn tại trong hệ thống ngân hàng','[-670050]: Report not founded','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670051,'[-670051]: Số tham chiếu bị trùng','[-670051]: RefCode duplicated','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670052,'[-670052]: Số tham chiếu không tìm thấy','[-670052]: Refcode not founded','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670053,'[-670053]: Mật khẩu mới không đúng','[-670053]: New password invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670054,'[-670054]: Mật khẩu mới trùng mật khẩu cũ','[-670054]: New password same old password','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670055,'[-670055]: Không đúng định dạng xml','[-670055]: Invalid xml format','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670056,'[-670056]: File đã gửi','[-670056]: File alreadty sent','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670057,'[-670057]: File không xử lý được','[-670057]: File cannot processed','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670058,'[-670058]: Hệ thống đang trong quá trình cuối ngày','[-670058]: System in batch','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670059,'[-670059]: Giao dịch bị huỷ','[-670059]: Transaction canceled','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670060,'[-670060]: Không tìm thấy giao dịch','[-670060]: Transaction not founded','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670061,'[-670061]: Lỗi hệ thống ngân hàng','[-670061]: Bank system error','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670062,'[-670062] : Ngân hàng không kết nối được','[-670062] : Bank cannot connected','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670063,'[-670063]:Lệnh tạm giữ hiện tại không thể chia','[-670063]: Hold ID cannot split','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670064,'[-670064]: Số dư phong toả không đủ để thực hiện','[-670064]: Hold balance not enough','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670065,'[-670065]: Số dư phong toả không có','[-670065]: Hold balance is zero','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670066,'[-670066]: Không lấy được chữ ký','[-670066]: Cannot get signature','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670067,'[-670067]: Sai định dạng ngày hệ thống','[-670067]: Date format invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670068,'[-670068]: Tài khoản đang được đăng ký với công ty khác','[-670068]: Account is registered in another company','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670069,'[-670069]: Định dạng truyền vào không hợp lệ','[-670069]: Import format invalid','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670070,'[-670070]: Không thể huỷ đăng ký tài khoản','[-670070]: Can not cancel registering','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670071,'[-670071]: Tài khoản không đăng ký uỷ quyền','[-670071]: Account not authorized','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670072,'[-670072]: Tài khoản chưa đăng ký với ngân hàng','[-670072]: Account  not registered with bank','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670073,'[-670073]: Lỗi chưa được định nghĩa','[-670073]: Non defined error','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670075,'[-670075]: Bảng kê đã được gửi trước đó, không thể gửi','[-670075]: Can not send, List sent already!','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670076,'[-670076] : Mã bảng kê không tồn tại, hoặc bản kê đã được duyệt rồi','[-670076] : Already approved or not exist','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670077,'[-670077] : Bảng kê không có nội dung','[-670077] : Empty list','RM',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-670100,'[-670100] : Bang ke xac nhan null','[-670100] : The list confirmed is null','RM',0);
COMMIT;
/
