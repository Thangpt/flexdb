--
--
/
DELETE DEFERROR WHERE MODCODE = 'SE';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100600,'[-100600]: ERR_SA_CUSTID_NOT_SAME','[-100600]: ERR_SA_CUSTID_NOT_SAME','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200069,'[-200069]: Trạng thái khách hàng không đúng!','[-200069]: Customer status is invalid!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200100,'[-200100]: ERR_CFMAST_CAREBY_INVALID','[-200100]: ERR_CFMAST_CAREBY_INVALID','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200401,'[-200401]:Số lượng chứng khoán chờ chuyển không hợp lệ hoặc hồ sơ đã được chuyển!','[-200401]:Pending transfer QTTY invalid or Transfer profile already sent!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200402,'[-200402]:Số lượng chứng khoán chờ chuyển không hợp lệ hoặc hồ sơ đã được xác nhận!','[-200402]:Pending transfer QTTY invalid or Transfer profile already confirmed!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200403,'[-200403]:Số lượng chứng khoán chờ chuyển không hợp lệ!','[-200403]:Pending transfer QTTY invalid !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200404,'[-200404]:Giao dịch không thể xóa vì đã thực hiện các giao dịch tiếp theo của qui trình!','[-200404]:Transaction can not be deleted, other steps in processing !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200405,'[-200405]:Giao dịch không được backdate về trước ngày backdate của giao dịch 8879!','[-200405]:Transaction can not bacnkdate before transaction 8879 backdate!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200406,'[-200406]:Giao dịch không được backdate về trước ngày backdate của giao dịch 8815!','[-200406]:Transaction can not bacnkdate before transaction 8815 backdate !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260019,'[-260019]: Khách hàng này đã được gửi email cảnh báo !','[-260019]: EMAIL SENT  !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260153,'[-260153]: Số lượng chứng khoán giải tỏa phải theo lô quy định !','[-260153]: Release amount should be round lot','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260156,'[-260156]: Tài khoản vẫn còn chứng khoán cầm cố VSD !','[-260156]: Mortgage VSD still exist!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260157,'[-260157]: Tài khoản vẫn còn tài sản ngoài CK chưa giải chấp !','[-260157]: Collateral asset still exist','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-269009,'[-269009]: SL quyền mua chưa đăng kí không hợp lệ!','[-269009]: Right issue QTTY registered is invalid!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-269010,'[-269010]: SL Chứng khoán CA không hợp lệ!','[-269010]: CA QTTY is invalid','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-269011,'[-269011]:SLCK CA ghi giảm không hợp lệ!','[-269011]: Decreasing CA QTTY is invalid','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-269012,'[-269012]: Số tiền CA không hợp lệ!','[-269012]: CA money amount is invalid','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-269013,'[-269013]: Số quyền biểu quyết không hợp lệ!','[-269013]: Voting volume is invalid','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300048,'[-300048]:Vẫn còn tiểu khoản chưa được phân bổ chứng khoán hoặc tiền','[-300048]: Account is still unallocated securities or money!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400444,'[-400444]: Vượt quá số lượng giải ngân cho phép','[-400444]: BLOCK NOT enough','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400445,'[-400445]: Vượt quá số lượng cho phép','[-400445]: BLOCK NOT enough','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400446,'[-400446]: Số tiền ứng phải lớn hơn số tiền ứng tối thiểu','[-400446]: Advance amount must be greater than min Advance!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400447,'[-400447]: Giao dịch không thể xóa vì đã hoàn tất chuyển khoản ra ngân hàng','[-400447]: The transaction cant be deleted because it has been transfered completely to the bank','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400448,'[-400448]: Giao dịch không thể xóa vì đã làm giao dịch hủy ủy nhiệm chi','[-400448]:Transaction can not be deleted because of Calceling Payment order already done!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540999,'[-540999]: Tỷ lệ thực tế của tiểu khoản dưới tỷ lệ an toàn. Giao dịch không được phép thực hiện!','[-540999]: Real margin rate less than Init rate!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900001,'[-900001]: Số lưu ký không trùng với điện nhận về','[-900001]: Số lưu kí không trùng với điện nhận về','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900002,'[-900002]: Mã CK không trùng với điện nhận về','[-900002]: Mã CK không trùng với điện nhận về','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900003,'[-900003]: Số lượng không trùng với điện nhận về!','[-900003]: Số lượng không trùng với điện nhận về!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900004,'[-900004]: Không tìm thây chứng khoán tương ứng với số tiểu khoản','[-900004]: ERR_SE_AFACCTNO_NOTFOUND','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900008,'[-900008]: không cho phép thực hiện lưu ký cả 2 loại CK TDCN và HCCN trong cùng 1 GD lưu ký!','[-900008]: không cho phép thực hiện lưu ký cả 2 loại CK TDCN và HCCN trong cùng 1 GD lưu ký','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900010,'[-900010]: Mã niêm yết GDCK không hợp lệ!','[-900010]: ERR_SE_SYMBOL_NOTFOUND','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900011,'[-900011]: Ngày hiệu lực không hợp lệ','[-900011]: ERR_SE_TXDATE_INVALID','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900012,'[-900012]: ERR_SE_CODEID_DUPLICATE!','[-900012]:ERR_SE_CODEID_DUPLICATE!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900013,'[-900013]: ERR_SE_GLGRP_NOTFOUND!','[-900013]:ERR_SE_GLGRP_NOTFOUND!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900014,'[-900014]: Chứng khoán không bị Block !','[-900014]:ERR_SE_SEMASTDTL_NOT_ENOUGTH','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900016,'[-900016] Giá vốn đã khác 0!','[-900016] Cost price is not zero already!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900017,'[-900017] Vượt quá số dư chứng khoán trong tiểu khoản ','[-900017]:TRADE NOT enough!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900018,'[-900018]: Tài khoản vẫn còn tiền!','[-900018]: Money still exist!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900019,'[-900019]: Trạng thái tiểu khoản chưng khoán không hợp lệ','[-900019]: The status of this account is invalid','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900020,'Số dư cầm cố không đủ ','[-900020]: ERR_SE_MORTAGE','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900021,'[-900021]: ERR_SE_MARGIN','[-900021]: ERR_SE_MARGIN','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900022,'Vẫn còn số dư chứng khoán chờ thanh toán trong tiểu khoản','Clearing pending on stock balance on sub account!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900023,'[-900023]: ERR_SE_STANDING','[-900023]: ERR_SE_STANDING','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900024,'[-900024]: ERR_SE_SECURED','[-900024]: ERR_SE_SECURED','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900025,'[-900025]: ERR_SE_RECEIVING','[-900025]: ERR_SE_RECEIVING','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900026,'Vẫn còn số dư chờ rút trong tiểu khoản','Withdraw pending on sub account!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900027,'Vẫn còn số dư chứng khoán chờ lưu ký trong tiểu khoản','Deposit pending on sub account!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900028,'[-900028]: ERR_SE_LOAN','[-900028]: ERR_SE_LOAN','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900029,'[-900029]: ERR_SE_BLOCKED','[-900029]: ERR_SE_BLOCKED','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900030,'[-90030]: ERR_SE_REPO','[-90030]: ERR_SE_REPO','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900031,'[-900031]: ERR_SE_PENDING','[-900031]: ERR_SE_PENDING','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900032,'[-900032]: Chứng khoán OTC chờ chuyển','[-900032]: ERR_SE_TRANSFER','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900033,'[-900033]:Đang chờ gủi lưu ký ','[-900033]: ERR_SE_SENDDEPOSIT','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900038,'[-900038]: Tài khoản vẫn còn chứng khoán','[-900038]: SE still exist','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900040,'[-900040]: Không đủ số lượng chứng khoán để phong tỏa','[-900040]: BLOCK NOT ENOUGHT','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900041,'[-900041]: NETTING NOT ENOUGHT','[-900041]: NETTING NOT enough','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900042,'[-900042]: Tài khoản chứng khoán chưa được chuyển về active !','[-900042]: EXIST INACTIVE SE ACCOUNTS','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900043,'[-900043]: Chưa xác nhận xin rút chứng khoán (giao dịch 2292) !','[-900043]: NOT EXECUTE 2292','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900044,'[-900044]: Đã xác nhận xin rút chứng khoán nên không thể xóa !','[-900044]: EXECUTED 2292','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900045,'[-900045]: Trạng thái của giao dịch thực rút chứng khoán không hợp lệ !','[-900045]: INVALID STATUS 2201','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900046,'[-900046]: Trạng thái của giao dịch xin rút không hợp lệ !','[-900046]: CONFIRMED TRANSACTION !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900047,'[-900047]: Giao dịch đã được xóa hoặc 2201 đã thực hiện thành công !','[-900047]: DELETED OR EXCUTED 2201 !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900048,'[-900048]: Giao dịch đã được xóa trước đó !','[-900048]: DELETED BEFORE !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900049,'[-900049]: Hồ sơ đã được xác nhận rồi !','[-900049]: INVALID STATUS !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900050,'[-900050]: Vượt quá khối lượng cầm cố có thể giải tỏa !','[-900050]: AMOUNT OVER MORTAGE !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900051,'[-900051]: Đã xác nhận 2295 nên không thể xóa !','[-900051]: EXECUTED 2295 CANNOT DELETE !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900052,'[-900052]: Đã xác nhận 2296 nên không thể xóa !','[-900052]: EXECUTED 2296 CANNOT DELETE !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900053,'[-900053]: Số lượng giao dịch lô lẻ phải nhỏ hơn lô chẵn theo quy định từng sàn giao dịch !','[-900053]:  AMOUNT IS NOT RETAIL!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900054,'[-900054]: Khối lượng hủy phải nhỏ hơn khối lượng chứng khoán chờ về !','[-900054]: RECEIVING AMOUNT IS NOT enough !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900055,'[-900055]: Khối lượng chứng khoán giải tỏa không hợp lệ !','[-900055]: UNBLOCKQTTY NOT MATCH !','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900057,'[-900057]: Vượt qua chứng khoán cầm cố','[-900057]: ERR_SE_SENDDEPOSIT','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900060,'[-900060]: Ngày cầm cố phải lớn hơn ngày yêu cầu cầm cố','[-900060]: Mortgage date must be later than request date','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900061,'[-900061]: Ngày giải tỏa cầm cố phải lớn hơn ngày yêu cầu giải tỏa cầm cố','[-900061]: Mortgage release date must be later than request date','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900089,'[-900089]: Còn chứng khoán chưa làm 2244','[-900089]: Còn chứng khoán chưa làm 2244','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900090,'[-900090]: Còn số dư chứng khoán phong tỏa','[-900090]: ERR_SE_EMKQTTY','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900091,'[-900091]: Không được để trống trường mã đợt phát hành khi lưu ký CK chờ giao dịch!','[-900091]: Không được để trống trường mã đợt phát hành khi lưu ký CK chờ giao dịch','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900092,'[-900092]: Ngày giao dịch trở lại lớn hơn ngày hiện tại','[-900092]: Reactive date must be later than current date','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900093,'[-900093]: Còn chứng khoán chưa hoàn tất lưu ký','[-900093]: Pending for complete depository stocks exist!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900094,'[-900094]: Chứng khoán này được tính vào sức mua của tài khoản thành viên Tổ chức phát hành cần công bố thông tin!','[-900094]: This stock is calculated to PP0 of Issue member need to publish information! ','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900095,'[-900095]:Tài khoản vẫn còn chứng khoán phong tỏa!','[-900095]: Blocked stocks still exist','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900096,'[-900096]: Bạn phải nhập CMT/HC/GPKD của khách hàng trước khi làm giao dịch !','[-900096]: IDCODE/PP/Business certificate require!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900097,'[-900097]: Tài khoản KH vẫn còn chứng khoán quyền chờ thực hiện, !','[-900097]: CA QTTY pending for execution still exist','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900098,'[-900098]: Còn chuyển khoản tiền chưa làm 1104!','[-900098]: Still pending for1104!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900101,'[-900101]:Chỉ được chuyển nhượng chứng khoán trong cùng một khách hàng !','[-900101]: Transfer internal of 1 custody code only!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900102,'[-900102]:Không đủ số dư chứng khoán để tái lưu ký !','[-900102]: Not enough QTTY to re-deposit','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900103,'[-900103]:Không được backdate về trước ngày nhận yêu cầu rút chứng khoán!','[-900103]: Không được backdate về trước ngày nhận yêu cầu rút chứng khoán','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900104,'[-900104]:Không được backdate về trước ngày chuyển hồ sơ rút lên VSD!','[-900104]: Cannot backdate to the date before transfer withdraw file to VSD!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900105,'[-900105]:Không được backdate về trước ngày tạo hồ sơ VSD!','[-900105]: Can not backdate before date of creating VSD profile','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900106,'[-900106]: Còn chứng khoán chưa làm 2244','[-900106]: Còn chứng khoán chưa làm 2244','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900120,'Số dư chứng khoán không đủ ','[-900120]: ERR_SE_TRADE_NOT_ENOUGHT','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900121,'[-900121]: Khối lượng chứng khoán lô lẻ trên tài khoản không đủ ','[-900121]: Quantity retail securities not enough','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900136,'[-900136]: Giao dịch đã thực hiện!','[-900136]: Giao dịch đã thực hiện!','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900146,'[-900146]: Vào màn hình VSE2245 để thực hiện duyệt điện','[-900146]:  Vào màn hình VSE2245 để thực hiện duyệt điện','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900147,'[-900147]: Tất toán một phần/Chuyển khoản khác chủ sở hữu: chọn Chuyển quyền CA = Không!','[-900147]: Tất toán một phần/Chuyển khoản khác chủ sở hữu phải chọn Chuyển quyền CA = Không!','SE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900148,'[-900148]: Chuyển khoản tất toán: chọn Chuyển quyền CA = Có!','[-900148]: Chuyển khoản tất toán phải chọn Chuyển quyền CA = Có!','SE',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901202,'[-901202]: Trạng thái gửi hồ sơ không hợp lệ','[-901202]: Profile sent status invalid','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901203,'[-901203]: Thanh toán chứng khoán lô lẻ không hợp lệ','[-901203]: Odd lot securities payment invalid','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901204,'[-901204]: Thanh toán tiền lô lẻ không hợp lệ','[-901204]: Odd lot money payment invalid','SE',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-9010001,'[-9010001]:Chỉ được chuyển nhượng chứng khoán trong cùng một khách hàng !','[-9010001]: Stock can only be transferred within the same customer','SE',null);
COMMIT;
/
