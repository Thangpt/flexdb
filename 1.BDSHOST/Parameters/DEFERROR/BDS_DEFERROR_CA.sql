
DELETE DEFERROR WHERE MODCODE = 'CA';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100704,'[-100704]: Mã file đã được sử dụng!','[-100704]: ERR_SA_FILEID_DUPLICATED','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300001,'[-300001]: ERR_CA_BDS_HAS_CHILD','[-300001]: ERR_CA_BDS_HAS_CHILD','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300002,'[-300002]: ERR_CA_CODEID_NOTFOUND','[-300002]: ERR_CA_CODEID_NOTFOUND','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300003,'[-300003]: ERR_CA_AUTOID_HAS_CONSTRAINT','[-300003]: ERR_CA_AUTOID_HAS_CONSTRAINT','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300004,'[-300004]: ERR_CA_CAMASTID_HAS_CONSTRAINT','[-300004]: ERR_CA_CAMASTID_HAS_CONSTRAINT','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300005,'[-300005]: CA ALREADY APPROVED, SENT OR COMPLETE','[-300005]: CA ALREADY APPROVED, SENT OR COMPLETE','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300006,'[-300006]: ERR_CA_CAMASTID_DUPLICATE','[-300006]: ERR_CA_CAMASTID_DUPLICATE','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300010,'[-300010]: Đợt thực hiện quyền đã lưu trong lịch nên không được phép xóa !','[-300010]: ERR_CA_CAMASTID_INVALIDSTATUS','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300011,'[-300011]: ERR_CA_CAMASTID_ALREADY_CREDITACCOUNT','[-300011]: ERR_CA_CAMASTID_ALREADY_CREDITACCOUNT','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300012,'[-300012]: ERR_CA_CASCHD_ALREADY_EXECUTED','[-300012]: ERR_CA_CASCHD_ALREADY_EXECUTED','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300013,'[-300013]: Trạng thái của sự kiện thực hiện quyền không hợp lệ !','[-300013]: ERR_CAMAST_STATUS_INVALID','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300014,'[-300014]: Trạng thái quyền không hợp lệ!','[-300014]: ERR_CASCHD_STATUS_INVALID','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300015,'[-300015]: ERR_REPORTDATE_INVALID','[-300015]: ERR_REPORTDATE_INVALID','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300016,'[-300016]: ERR_ACTIONDATE_INVALID','[-300016]: ERR_ACTIONDATE_INVALID','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300017,'[-300017]: Ngày thực hiện quyền phải là ngày làm việc !','[-300017]: ACTION DATE IS NOT VALID','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300018,'Ngày thực hiện giao dịch phải lớn hơn ngày ngày đăng ký cuối cùng của đợt thực hiện quyền !','[-300018]: ERR_CA_TXDATE_INVALID','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300019,'[-300019]:ERR_CA_CANNOT_RETAIL','[-300019]:ERR_CA_CANNOT_RETAIL','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300021,'[-300021]: Vượt qua số dư chứng khoán quyền','[-300021]: ERR_CA_QTTY_TRANSFER','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300024,'[-300024]: ERR_CA_SEMAST_NOTFOUND','[-300024]: ERR_CA_SEMAST_NOTFOUND','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300025,'[-300025]: Chứng khoán này đang bị tạm ngừng giao dịch !','[-300025]: ERR_SYMBOL_IS_HALTED_OR_SUSPENDED','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300026,'[-300026]: Vượt quá số lượng CK đăng ký','[-300026]: ERR_CA_CAQTTY_SMALLER','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300027,'[-300027]: ERR_CA_CODEID_CANNOT_EXECUTE','[-300027]: Exercise the right to not allow for this stock','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300028,'[-300028]: ERR_CA_BOND_PAY_INTEREST_MUSTBE_FINISHED','[-300028]: Must make a profit before performing bond principal payment','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300029,'[-300029]: Chưa đến ngày cho phép thực hiện chuyển nhượng quyền mua,','[-300029]: ERR_CA_DATE_CANNOT_EXECUTE','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300030,'[-300030]: Vượt quá số lượng hủy đăng ký cho phép.','[-300030]: ERR_CA_CASCHD_OVER_CANCELREGISTER_QTTY','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300031,'[-300031]: Quá ngày cho phép thực hiện chuyển nhượng quyền mua, ','[-300031]: ERR_CA_DATE_OUTOF_REGISTER','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300032,'[-300032]:  Thuế suất  phải từ 0 đến 100 ','[-300032]: ERR_NumberNotIn_1_100','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300033,'[-300033]:Không thể thay đổi thuế suất nếu phương thức thu thuế là không ','[-300033]: ERR_NotExchange_PitrateWhenNotSC','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300034,'[-300034]:Không đủ chứng khoán quyền để hủy giao dịch chuyển nhượng','[-300034]: Not enough CA QTTY to cancel transferring','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300035,'[-300035]: Ngày giao dịch trở lại phải là ngày làm việc !','[-300035]: Reactive day must be working day','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300036,'[-300036]:Ngày giao dịch trở lại phải lớn hơn ngày hiện tại !','[-300036]:Trading date must be greater than current date','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300037,'[-300037]: Chỉ được chọn một cách khai tỷ lệ !','[-300037]: You must choose only one ratio type','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300038,'[-300038]: Tỷ lệ tách phải nhỏ hơn 1 !','[-300038]:Split rate must be less than 1','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300039,'[-300039]: Tỷ lệ gộp phải lớn hơn 1 !','[-300039]: Pooled rate must be greater than 1','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300042,'[-300042]:Phải chọn một cách khai tỷ lệ nhận cổ tức !','[-300042]:Must choose one dividend type!','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300043,'[-300043]:Mã sự kiện quyền không tồn tại !','[-300043]: Events code not exist!','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300044,'[-300044]:Số lượng chứng khoán quyền bán vượt quá số lượng CK quyền còn lại !','[-300044]: Exceed CA QTTY remain!','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300045,'[-300045]: Quá ngày cho phép thực hiện đăng kí quyền mua, ','[-300045]: Late for registering right issue!','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300046,'[-300046]: Chưa đến ngày cho phép thực hiện đăng kí quyền mua,','[-300046]: Not yet to the register date for right issue !','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300047,'[-300047]:Vẫn còn tiểu khoản của đợt thực hiện quyền đã đăng ký quyền mua nhưng chưa thực hiện 3387','[-300047]: Account pending for 3387 execution still exist! ','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300048,'[-300048]:Vẫn còn tiểu khoản chưa được phân bổ chứng khoán hoặc tiền','[-300048]:Vẫn còn tiểu khoản chưa được phân bổ chứng khoán hoặc tiền!','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300049,'[-300049]:Vượt quá số quyền được chốt để có thể chuyển khoản cho khách hàng khác','[-300049]: Exceed reported amount to transfer to others!','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300050,'[-300050]:Giao dịch chuyển nhượng đã bị hủy từ trước','[-300050]: Transfer transaction is canceled before!','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300051,'[-300051]: Giao dịch không thể xóa vì đã chuyển chứng khoán thành giao dịch','[-300051]: Transaction can not be delelted due to completely converting to Trade','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300052,'[-300052]: Giao dịch không thể xóa vì không đủ số dư tiền','[-300052]: Transaction can not be deleted due to lack of money','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300053,'[-300053]: Giao dịch không thể xóa vì không đủ số dư chứng khoán','[-300053]: Transaction can not be deleted due to lack of SE','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300060,'[-300060]: Ngày đăng ký cuối cùng không được lớn hơn ngày thực hiện dự kiến!','[-300060]: Last register date must not be greater than expected executing day','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300061,'[-300061]: Ngày kết thúc chuyển nhượng quyền mua không được sau ngày thực hiện dự kiến!','[-300061]: Transfer closing date must be before expecting executing day','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300062,'[-300062]: Ngày đăng kí quyền mua cuối cùng không được sau ngày thực hiện dự kiến!','[-300062]: Last date of CA register must be before expecting executing day','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300063,'[-300063]: KL đăng kí chuyển đổi hoặc trạng thái của sự kiên không hợp lệ!','[-300063]: QTTY registered or CA status invalid','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300064,'[-300064]:Giao dịch không được phép xóa vì KL đã đăng kí chuyển đổi hoặc trạng thái của sự kiên không hợp lệ!','[-300064]: Transaction can not be deleted bue to QTTY registered or CA status invalid','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300065,'[-300065]:KL hủy nhở hơn số lượng đã đăng ký hoặc trạng thái của sự kiện không hợp lệ!','[-300065]: Cancel QTTY less than registered QTTY or CA status invalid','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300066,'[-300066]:Mã sư kiện quyền không phù hợp với chứng khoán và loại thực hiện quyền','[-300066]: CA code not match with SE symbol and CA type','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300067,'[-300067]:Số lưu ký đã được chốt sự kiện quyền này tại công ty','[-300067]: Custody code has been reported CA at company','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300068,'[-300068]:SL CK chờ về đăng kí thêm đã thay đổi','[-300068]: Receivable QTTY changed','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300069,'[-300069]:Chỉ user duyệt sự kiện mới được phép xóa','[-300069]: Only User approving this CA can delete!','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300070,'[-300070]:Khách hàng không sở hữu quyền này','[-300070]: Customer does not own this right','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-300071,'[-300071]:Không thể thực hiển phân bổ do thiếu thông tin','[-300071]: Khong the thuc hien phan bo do thieu thong tin ','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-301001,'[-301001]:Không thể nhận chuyển khoản sự kiện đã hoàn tất phân bổ','[-301001]: Can not receive transferred amount due to CA already close','CA',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-301002,'[-301002]: Sự kiện phải có xử lý hoặc thanh toán tiền hoặc cắt CK hoặc cả hai ','[-301002]: CA_NOT_VALID','CA',null);
COMMIT;
/
