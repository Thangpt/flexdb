--
--
/
DELETE DEFERROR WHERE MODCODE = 'CI';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200070,'[-200070]: Tai khoan Margin ky han chua tra het no!','[-200070]:Margin term account remains outstanding','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400001,'[-400001]: Không tìm thấy loại hình của tiều khoản tiền!','[-400001]: ERR_CI_AFTYPE_NOTFOUND','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400002,'[-400002]: Tiểu khoản tiền đã tồn tại!','[-400002]: ERR_CI_CIMAST_ALREADY_EXIST','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400003,'[-400003]: Tiểu khoản tiền không tồn tại!','[-400003]: ERR_CI_CIMAST_NOTFOUND','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400004,'[-400004]: Trạng thái tài khoản không đúng!','[-400004]: ERR_CI_CIMAST_STATUS_INVALID','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400005,'[-400005]: Không đủ số dư tiền','[-400005]: Not enough balance','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400006,'[-400006]: Lãi tiền gửi cộng dồn không đủ','[-400006]: Not enough accrued interest.','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400007,'[-400007]: Lãi thấu chi cộng dồn không đủ để điều chỉnh. Thực hiện giao dịch 1171 để tra cứu số tiền lãi này.','[-400007]: Not enough overdraft accrual interest. Make transaction 1171 to know interest amount.','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400008,'[-400008]: ERR_CI_CIMAST_RAMT_NOTENOUGHT','[-400008]: ERR_CI_CIMAST_RAMT_NOTENOUGHT','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400009,'[-100009]: Mã loại hình bị trùng!','[-100009]: ACTYPE DUPLICATE!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400010,'[-400010]: Mã loại tiền không tồn tại!','[-400010]:Currency id not exist!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400011,'[-400011]: Mã nhóm kế toán không tồn tại!','[-400011]:GL group code not exist!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400012,'[-400012]: Không thể xoá loại hình tiền gửi do vẫn còn dữ liệu liên quan!','[-400012]: Cannot delete the Product type which contains related data!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400013,'[-400013]: Lỗi trùng tiểu khoản tiền!','[-400013]: ERR_CI_ACCTNO_DUPLICATED','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400014,'[-400014]: ERR_CI_AFACCTNO_NOTFOUND','[-400014]: ERR_CI_AFACCTNO_NOTFOUND','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400015,'[-400015]: Không tìm thấy loại hình tiểu khoản tiền!','[-400015]: ERR_CI_ACTYPE_NOTFOUND','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400016,'[-400016]: Không thể xoá số tài khoản tiền gửi do vẫn còn dữ liệu liên quan!','[-400016]: Cannot delete the CI account number  which contains related data!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400017,'[-400017]: Mã tài khoản GL không tồn tại!','[-400017]:GL master id  not exist!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400018,'[-400018]: Số tài khoản tiền gửi bị trùng!','[-400018]:CI account number is duplicated!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400019,'[-400019]: Mã loại hình tiền gửi không tồn tại!','[-400019]:Product type not exist!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400020,'[-400020]: Mã loại tiền không tồn tại!','[-400020]:Currency id not exist!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400021,'[-400021]: Mã hợp đồng của KH không tồn tại!','[-400021]:Contract number not exist!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400022,'[-400022]: Yêu cầu chuyển khoản đã hoàn tất hoặc đã bị từ chối!','[-400022]:  Transfer request is complete or rejected','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400023,'[-400023]:Tiểu khoản còn thấu chi','[-400023]:ERR_CI_BALANCE_NEGATIVE','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400024,'[-400024]: Tiểu khoản còn tiền chờ nhận về','[-400024]: ERR_CI_RM','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400025,'[-400025]: Tiểu khoản còn chứng khoán chờ nhận về','[-400025]: ERR_CI_RS','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400027,'[-400027]: Tiểu khoản còn ứng trước tiền bán','[-400027]: ERR_CI_AAMT','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400028,'[-400028]: ERR_CI_RAMT','[-400028]: ERR_CI_RAMT','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400029,'[-400029]: ERR_CI_BAMT','[-400029]: ERR_CI_BAMT','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400030,'[-400030]: ERR_CI_NAMT','[-400030]: ERR_CI_NAMT','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400031,'Vượt quá số tiền đang bị phong tỏa','Exceed block amount!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400032,'[-400032]: Vẫn còn tai khoản Margin','[-400032]: ERR_CI_MMARGINBAL','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400033,'[-400033]:Vẫn còn tai khoản Margin','[-400033]: ERR_CI_MARGINBAL','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400034,'[-400034]: Tiểu khoản tiền đã tồn tại!','[-400034]: ERR_CI_EXIST','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400036,'Vượt quá số dư đang bị phong tỏa','Exceed block amount!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400038,'[-400038]: Corebank account ','[-400038]: Corebank account','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400039,'[-400039]: Không đủ số dư!','[-400039]: Balance is not enough!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400040,'[-400040]: ERR_CI_HOLDBALANCE','[-400040]: ERR_CI_HOLDBALANCE','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400041,'[-400041]: ERR_CI_PENDINGHOLDBALANCE','[-400041]: ERR_CI_PENDINGHOLDBALANCE','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400042,'[-400042]: ERR_CI_PENDINGUNHOLDBALANCE','[-400042]: ERR_CI_PENDINGUNHOLDBALANCE','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400043,'[-400043]: Interest accure must be equal zero!','[-400043]:Interest accure must be equal zero!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400044,'[-400044]: Overdraft interest accure must be equal zero!','[-400044]: Overdraft interest accure must be equal zero!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400047,'[-400047]: Tài khoản còn khoản tiền trả chậm, không được phép thực hiện đóng!','[-400047]: Deferred amount still exist , can not close account','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400048,'[-400048]: Tiểu khoản có tồn tại nợ trả chậm chưa thanh toán mới được phép thực hiện giao dịch này!','[-400048]: Transaction can only process within account remain deferred outstanding','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400100,'[-400100]: Trạng thái tiểu khoản tiền không hợp lệ!','[-400100]:Invalid cash account status!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400101,'[-400101]: Số dư tiền không đủ!','[-400101]:Balance is not enough!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400102,'[-400102]: Vượt quá số lãi cộng dồn của tài khoản!','[-400102]:Accrued interest is not enough!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400103,'[-400103]: Vượt quá số lãi thấu chi cộng dồn của tài khoản!','[-400103]:Overdraft interest accure is not enough!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400104,'[-400104]: Vượt quá số tiền chỉ dùng để giao dịch!','[-400104]:Exceed trading amount','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400105,'[-400105]: Vượt quá hạn mức giao dịch của tiểu khoản!','[-400105]:Exceed trading limit','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400106,'[-400106]: Vượt quá số tiền ký quỹ của tiểu khoản!','[-400106]:Exceed money deposit amount ','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400107,'[-400107]: Vượt quá số tiền thấu chi của tiểu khoản!','[-400107]:Exceed overdraft amount','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400108,'[-400108]: Vượt quá số tiền phong tỏa của tiểu khoản!','[-400108]:Exceed blocked money amount','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400109,'[-400109]: Vượt quá số tiền chờ chuyển ra ngân hàng của tiểu khoản!','[-400109]:Exceed pending transfer amount to bank ','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400110,'[-400110]: Vượt quá số tiền khả dụng của tiểu khoản!','[-400110]:Exceed usable money amount','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400111,'[-400111]: Trạng thái corebank của tiểu khoản không hợp lệ!','[-400111]:Corebank status invalid','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400112,'[-400112]: Vượt quá số tiền phong tỏa của tiểu khoản!','[-400112]:Exceed blocked money amount','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400113,'[-400113]:Vượt quá số dư đã hold tại ngân hàng!','[-400113]:Exceed Hold balance','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400114,'[-400114]:Trạng thái corebank của tiểu khoản không hợp lệ!','[-400114]:Corebank status invalid!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400115,'[-400115]:Vượt quá số dư có thể rút của tiểu khoản!','[-400115]:Exceed withdrawable balance!!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400116,'[-400116]:Vượt quá sức mua của tiểu khoản!','[-400116]:Exceed purchase power!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400117,'[-400117]:Vượt quá hạn mức có thể giao dịch của tiểu khoản!','[-400117]: Exceed max trading limit on sub account!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400118,'[-400118]:Vượt quá hạn mức vay của tiểu khoản!','[-400118]:Exceed credit limit!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400119,'[-400119]:Không đủ hạn mức cho deal!','[-400119]:Not enough limit for deal','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400120,'[-400120]:Trả quá số tiền phải trả cho deal!','[-400120]:Exceed payable amount!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400121,'[-400121]:Thông tin deal lệnh bán không hợp lệ!','[-400121]:Information of deal sell order invalid!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400125,'[-400125]: Quá số tiền khoanh nợ!','[-400125]: Exceed block amount!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400130,'[-400130]: Số bảng kê này đã được sử dụng!','[-400130]: Payment order number is used!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400131,'[-400131]: Số phí ứng vượt quá phí ứng theo nguồn cũ!','[-400131]: Exceed fee of used source!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400132,'[-400132]: Loại hình ứng mới phải khác loại hình ứng cũ!','[-400132]: Duplicated with old type!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400133,'[-400133]: Ứng ngoài phạm vi giá trị tối thiểu tối đa của loại hình ứng mới!','[-400133]: Out of permitted range of new type','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400200,'[-400200]: Vượt quá số tiền ứng trước','[-400200]: Exceed AD amount','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400201,'[-400201]: Trạng thái bảng kê (UNC) không đúng','[-400201]: Payment order status invalid','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400202,'[-400202]: Trạng thái yêu cầu không cho phép từ chối','[-400202]: Request status not allow to reject','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400203,'[-400203]: Vượt quá phí lưu ký cộng dồn của tài khoản!','[-400203]:Exceed accrued depository fee of account','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400204,'[-400204]: Trạng thái bảng kê không đúng!','[-400204]:List Status invalid!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400205,'[-400205]: Tài khoản vẫn còn tiền phong tỏa !','[-400205]: Blocked amount still exist','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400206,'[-400206]: Tài khoản vẫn còn dư nợ !','[-400206]: outstanding still exist','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400207,'[-400207]: Tài khoản vẫn còn HM cho vay được cấp chưa thu hồi !','[-400207]: Credit limit still remain','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400208,'[-400208]: Tài khoản vẫn còn bảo lãnh T0 chưa thu hồi !','[-400208]: T0 limit still exist','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400209,'[-400209]: Nguồn ứng trước đã bị đổi !','[-400209]: AD source changed','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400210,'[-400210]: Giao dịch không thể xóa vì tiểu khoản nhận chuyển khoản không đủ tiền !','[-400210]: Transaction can not be deleted because receving account do not have enough money','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400211,'[-400211]: Giao dịch không thể xóa vì tiểu khoản không đủ lãi tiền gửi cộng dồn!','[-400211]: Transaction can not be deleted because account do not have enough TD accrual interest ','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400212,'[-400212]: Giao dịch không thể xóa vì tiểu khoản không đủ phí lưu ký cộng dồn!','[-400212]: Transaction can not be deleted because account do not have enough accrued depository fee','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400213,'[-400213]: Giao dịch không thể xóa vì tiểu khoản không đủ tiền!','[-400213]: Transaction can not be deleted because account do not have enough money','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-400214,'[-400214]: Giao dịch không được xóa vì đã gom bảng kê sang ngân hàng!','[-400214]: Transaction can not be deleted. Lists already sent to bank!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-401116,'[-401116]:Không bán được lô lẻ do không đủ thặng dư RTT!','[-401116]:May not sell retail securities, because Rtt not enough!','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-401117,'[-401117]:Bạn cần phải chọn mã ngân hàng !','[-401117]: You need to choose a bank code !','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-401180,'[-401180]: Số phí thu vượt quá số phí lưu ký cộng dồn !','[-401180]: Exceed accrual fee !','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900009,'[-900009]: ERR_SE_ACTYPE_CONSTRAINTS','[-900009]: ERR_SE_ACTYPE_CONSTRAINTS','CI',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900113,'[-900113]: Chỉ được chuyển nhượng tiền trong cùng một khách hàng !','[-900113]: Chỉ được chuyển nhượng tiền trong cùng một khách hàng !','CI',null);
INSERT INTO deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-400126, '[-400126]: Trạng thái yêu cầu không hợp lệ!', '[-400126]: Request status invalid!', 'CI', null);
INSERT INTO deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
VALUES (-400127, '[-400127]: Tiểu khoản nhận chưa được đăng ký chuyển tiền nội bộ!', '[-400127]: Sub-account has not been registered for internal transfer!', 'CI', null);
COMMIT;
/
