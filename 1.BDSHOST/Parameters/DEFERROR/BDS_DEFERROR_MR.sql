--
--
/
DELETE DEFERROR WHERE MODCODE = 'MR';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180001,'[-180001]: Loại hình margin đã tồn tại!','[-180001]:Margin type duplicate!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180002,'[-180002]: Biên độ dao động tỷ lệ ban đầu không hợp lệ!','[-180002]:Invalid initial rate amplitude !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180003,'[-180003]: Biên đội dao động tỷ lệ duy trì không hợp lệ!','[-180003]:Invalid maintanance rate amplitude !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180004,'[-180004]: Biên độ dao động tỷ lệ thanh khoản không hợp lệ!','[-180004]:Invalid liquidity rate amplitude !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180005,'[-180005]: Tỷ lệ cảnh báo phải < Tỷ lệ an toàn!','[-180005]: Call ratio  < Safe ratio!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180006,'[-180006]: Tỷ lệ xử lý phải < Tỷ lệ cảnh báo!','[-180006]: Force sell raito  < Call ratio!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180007,'[-180007]: Tỷ lệ margin chứng khoán không hợp lệ!','[-180007]:Invalid securities margin rate !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180008,'[-180008]: Tỷ lệ vay chứng khoán không hợp lệ!','[-180008]:Invalid securities loan rate !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180009,'[-180009]: Tài khoản không thuộc loại hình margin!','[-180009]:Account is not margin type !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180010,'[-180010]: Tỷ lệ an toàn CL nằm ngoài khoảng quy định!','[-180010]: Safe ratio is out of range permitted!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180011,'[-180011]: Tỷ lệ cảnh báo CL nằm ngoài khoảng quy định!','[-180011]: Call ratio is out of range permitted!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180012,'[-180012]: Tỷ lệ xử lý CL nằm ngoài khoảng quy định!','[-180012]: Force sell ratio is out of range permitted!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180013,'[-180013]: Tỷ lệ margin tâng hệ thống thấp hơn tầng loại hình!','[-180013]:System margin rate is lower than defined margin rate of type !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180014,'[-180014]: Tỷ lệ vay tầng hệ thống thấp hơn tầng loại hình!','[-180014]:System loan rate is lower than defined loan rate of type !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180015,'[-180015]: Giá vay margin tầng hệ thống thấp hơn tầng loại hình!','[-180015]:System margin price rate is lower than defined margin price rate of type !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180016,'[-180016]: Giá vay tầng hệ thống thấp hơn tầng loại hình!','[-180016]:System loan price rate is lower than defined loan price rate of type!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180017,'[-180017]: Tỷ lệ margin tài khoản thấp hơn tỷ lệ an toàn ','[-180017]:Account margin rate is lower than initial rate of type !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180018,'[-180018]: Số lượng chứng khoán margin vượt quá quy định của hệ thống ','[-180018]:Margin quantity over system defined !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180019,'[-180019]: Giá margin không hợp lệ ','[-180019]:Margin price invalid !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180020,'[-180020]: Giá vay không hợp lệ ','[-180020]:Loan price invalid !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180021,'[-180021]: Hạn mức margin khách hàng thấp hơn hạn mức margin hợp đồng  ','[-180021]:Customer margin limit is lower than account limit !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180022,'[-180022]: Thành viên đã tham gia vào nhóm  ','[-180022]:Member has been joined a group !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180023,'[-180023]: Chủ nhóm đã thuộc nhóm khác  ','[-180023]:Leader has been joined a group !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180024,'[-180024]: Loại hình margin đã được dùng ','[-180024]:Margin type in used!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180025,'[-180025]: Loại hình margin không hợp lệ','[-180025]:Margin type invalid!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180026,'[-180026]: Tài khoản có dư nợ quá hạn','[-180026]:Account contains overdue amount','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180027,'[-180027]: Loại hình margin không được phép customize','[-180027]:Margin type not allow to customize!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180028,'[-180028]: Vượt quá hạn mức margin','[-180028]:Exceed margin limit!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180029,'[-180029]: Vượt quá hạn mức margin của nhóm','[-180029]:Exceed group margin limit!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180030,'[-180030]: Hạn mức bảo lãnh T0 của user chưa khai báo','[-180030]:T0 limit of user is not difined!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180031,'[-180031]: Hạn mức bảo lãnh T0 của user không đủ','[-180031]:T0 limit of user is not enough!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180032,'[-180032]: Quá hạn mức tối đa được cấp cho khách hàng','[-180032]:Exceed max limit allocated!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180033,'[-180033]: Bảo lãnh T0 không đủ','[-180033]:Underwrite T0 not enough!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180034,'[-180034]: Bảo lãnh T0 không đủ để giải toả','[-180034]:Underwrite T0 not enough to release!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180035,'[-180035]: Vượt quá hạn mức bảo lãnh T0 mà user được cấp','[-180035]:Exceed allocated Underwrite limit of user!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180036,'[-180036]: Loại hình margin không tồn tại','[-180036]:Margin type not found!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180037,'[-180037]: Không thể đổi dịch vụ tài khoản margin','[-180037]:Can not change service of margin account!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180038,'[-180038]: Vượt quá hạn mức vay đa cấp','[-180038]:Over margin limit!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180039,'[-180039]: Không được cấp bảo lãnh cho tài khoản Margin','[-180039]:Can not allocate Underwrite for Margin account!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180040,'[-180040]: Giá trị hạn mức bảo lãnh tối đa phải lớn hơn tổng hạn mức đã cấp cho tiểu khoản!','[-180040]: Underwrite max limit must be greater than total limit allocated to sub account!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180041,'[-180041]: Tiểu khoản Margin không được phép tham gia nhóm liên thông!','[-180041]: Margin acccount not allowed to join inter group!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180042,'[-180042]: Tỷ lệ k.quỹ ban đầu UBCK phải >= Mức tối thiểu theo quy định!','[-180042]: Margin ratio SSC >= minimum level!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180043,'[-180043]: Tỷ lệ k.quỹ duy trì UBCK phải >= Mức tối thiểu theo quy định và < Tỷ lệ k.quỹ ban đầu UBCK!','[-180043]: Maintain ratio SSC >= minimum level and < margin ratio SSC','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180044,'[-180044]: Tỷ lệ k.quỹ xử lý UBCK phải >= Mức tối thiểu theo quy định và < Tỷ lệ k.quỹ duy trì UBCK!','[-180044]: Force sell ratio SSC must be >= minimum level and < maintain ratio SSC!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180049,'[-180049]: Tỷ lệ k.quỹ tối thiểu UB vi phạm mức quy định tối thiểu!','[-180049]: Minimum margin ratio do not comply with permitted level!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180050,'[-180050]: Tỷ lệ k.quỹ duy trì UB vi phạm mức quy định tối thiểu!','[-180050]: Maitain margin ratio do not comply with permitted level!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180051,'[-180051]: Tỷ lệ k.quỹ xử lý UB vi phạm mức quy định tối thiểu!','[-180051]: Force sell margin ratio do not comply with permitted level!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180052,'[-180052]: Hạn mức bảo lãnh khách hàng thấp hơn hạn mức bảo lãnh hợp đồng  ','[-180052]:Customer creditline limit under account limit !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180055,'[-180055]: Giá trị bảo lãnh cấp quá lý thuyết đã thay đổi. Nhập lại để cập nhật số liệu mới nhất!','[-180055]: Value guarantee the theoretical level has changed . Reset to update to the latest data!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180056,'[-180056]: Tỷ lệ hoặc Hạn mức bảo lãnh đã thay đổi. Vui lòng nhập lại để cập nhật số liệu mới nhất!','[-180056]: The rate or guarantee limit has changed . Please log in again to update to the latest data!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180057,'[-180057]: Đã thay đổi thông tin Deal duyệt riêng!','[-180057]: Agreement to change!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180058,'[-180058]: Tỷ lệ NAV/(Nợ - Tiền) thấp hơn Tỷ lệ NAV/(Nợ - Tiền) hệ thống !','[-180058]: Tỷ lệ NAV/(Nợ - Tiền) thấp hơn Tỷ lệ NAV/(Nợ - Tiền) hệ thống !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180059,'[-180059]: Vượt quá hạn mức bảo lãnh toàn công ty !','[-180059]: Exceed the limit of the company guarantee !','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180061,'[-180061]: Ngày GD không phải ngày đến hạn, không được thay đổi lãi/phí đến hạn!','[-180061]: Trading date is not due date, can not change interest/fee due!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180062,'[-180062]: Ngày GD nhỏ hơn ngày đến hạn, không được thay đổi lãi/phí quá hạn!','[-180062]: Trading date is earlier than due date, can not change interest/fee due!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180063,'[-180063]: Ngày GD lớn hơn ngày đến hạn, không được thay đổi lãi/phí trong hạn!','[-180063]: Trading date is later than due date, can not change interest/fee due!','MR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200071,'[-200071]: Bảo lãnh tiền mua không đủ!','[-200071]:T0 Underwrite not enough!','MR',null);
COMMIT;
/
