--
--
/
DELETE DEFERROR WHERE MODCODE = 'LN';
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-540245, 'Khách hàng này đang hưởng ưu đãi lãi suất bậc thang ! ', 'ERR_LN_LNINTSTEP_ERROR1', 'LN', null);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-540246, 'Level xoá không hợp lệ, đề nghị xoá level cao hơn! ', 'ERR_LN_LNINTSTEP_ERROR2', 'LN', null);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-540243, 'Loại hình đã áp dụng cho món vay không thể xóa! ', 'ERR_LN_LNTYPEXT_CONSTRAINT', 'LN', null);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-540242, 'Loại hình đã tồn tại! ', 'ERR_LN_LNTYPEXT_INVALID', 'LN', null);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-540244, 'Mức lãi bậc thang không hợp lệ! ', 'ERR_LN_LNINTSTEP_ERROR', 'LN', null);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-540241, 'Trùng khoảng thời gian áp dụng lãi suất bậc thang! ', 'ERR_LN_ACTYPE_DUPLICATED', 'LN', null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500020,'[-500020]: Lãi đã được điều chỉnh. Vui lòng nhập lại giao dịch','[-500020]: Interest has been changed. ','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-530000,'[-530000]: Số Dư nợ lãi được trả hộ đã thay đổi!','[-530000]: Balance household debt is paid has changed!','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540001,'Invalid status','Invalid status','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540002,'Over normal principal','Over normal principal','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540003,'Over overdue principal','Over overdue principal','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540004,'Over normal interest','Over normal interest','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540005,'Over due interest','Over due interest','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540006,'Over payable interest','Over payable interest','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540007,'Over overdue interest','Over overdue interest','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540008,'Invalid loan type','Invalid loan type','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540009,'Over overdue interest','Over overdue interest','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540010,'Inused amount must be zero','Inused amount must be zero','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540011,'Over T+0 normal principal','Over T+0 normal principal','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540012,'Over T+0 due interest','Over T+0 due interest','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540013,'Over due fee','Over due fee','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540109,'ERR_LN_APPLICATION_NOTFOUND','ERR_LN_APPLICATION_NOTFOUND','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540110,'ERR_LN_APPL_OVERLIMIT','ERR_LN_APPL_OVERLIMIT','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540111,'ERR_LN_RATEID_EMPTY','ERR_LN_RATEID_EMPTY','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540112,'ERR_LN_TRFACCTNO_EMPTY','ERR_LN_TRFACCTNO_EMPTY','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540113,'ERR_LN_PRINFRQCD_LESS_INTFRQCD','ERR_LN_PRINFRQCD_LESS_INTFRQCD','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540114,'ERR_LN_INTFRQCD_INVALID','ERR_LN_INTFRQCD_INVALID','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540115,'ERR_LN_MUST_AUTOPAY','ERR_LN_MUST_AUTOPAY','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540116,'ERR_LN_CUSTID_NOT_SAME','ERR_LN_CUSTID_NOT_SAME','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540117,'Loan type of loan account and contract account must be the same!','Loan type of loan account and contract account must be the same!','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540118,'ERR_LN_LNMAST_OVER_ALLOWED_NUMBER_LNMAST','ERR_LN_LNMAST_OVER_ALLOWED_NUMBER_LNMAST','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540119,'ERR_LN_LNSCHD_DUEDATE_DUPLICATED','ERR_LN_LNSCHD_DUEDATE_DUPLICATED','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540200,'ERR_LN_LNSCHD_DUEDATE_INVALID','ERR_LN_LNSCHD_DUEDATE_INVALID','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540201,'ERR_LN_LNMAST_NOT_FIXLOAN','ERR_LN_LNMAST_NOT_FIXLOAN','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540202,'ERR_LN_LNSCHD_DUEDATE_HOLIDAY','ERR_LN_LNSCHD_DUEDATE_HOLIDAY','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540203,'ERR_LN_LNSCHD_CANNOT_DELETE','ERR_LN_LNSCHD_CANNOT_DELETE','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540204,'ERR_LN_LNMAST_OVER_EXPDT_LNAPPL','ERR_LN_LNMAST_OVER_EXPDT_LNAPPL','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540205,'ERR_LN_INTFRQCD_NOT_IMMEDIATELY','ERR_LN_INTFRQCD_NOT_IMMEDIATELY','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540206,'ERR_LN_LNMAST_FIRSTDT_OVER_EXPDT_LNAPPL','ERR_LN_LNMAST_FIRSTDT_OVER_EXPDT_LNAPPL','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540207,'ERR_LN_LNMAST_FIRSTDT_OVER_ENDDATE_LNMAST','ERR_LN_LNMAST_FIRSTDT_OVER_ENDDATE_LNMAST','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540208,'Debt amount must be zero','Debt amount must be zero','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540209,'ERR_LN_LNMAST_NOT_FOUND','ERR_LN_LNMAST_NOT_FOUND','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540210,'ERR_LN_OVER_AVAILABLE_LIMIT','ERR_LN_OVER_AVAILABLE_LIMIT','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540211,'ERR_LN_ACTYPE_NOT_FOUND','ERR_LN_ACTYPE_NOT_FOUND','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540212,'[-540212] Ngày gia hạn phải là ngày làm việc','[-540212]  Renew date must be working day','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540213,'[-540213] Ngày chứng từ không được NULL','[-540213]  Date of voucher is not NULL','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540214,'[-540214] Ngày gia hạn phải sau ngày đến hạn','[-540214]  Renew date must after duedate','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540215,'[-540215]: Loại hình margin khai báo số ngày cho vay vượt quá giới hạn cho phép!','[-540215]: Exceed permitted day number on MR type','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540216,'[-540216]: Tài kho?n không thu?c nhóm margin','[-540216]: Account not in margin group','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540217,'[-540217]: Ngày gia hạn không vượt quá ngày gia hạn tối đa trong một lần gia hạn!','[-540217]: Days renew can not exceed maximum level in once renew','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540218,'[-540218]: Ngày gia hạn không vượt quá số ngày vay tối đa!','[-540218]: Days renew can not exceed maximum level','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540219,'[-540219]: Ngày gia hạn phải lớn hơn ngày quá hạn cũ!','[-540219]: Renew date must be greater than old duedate','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540220,'[-540220]: Nguồn giải ngân là ngân hàng, bắt buộc chọn ngân hàng giải ngân!','[-540220]: Drawdown from bank source, Bankname require!','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540222,'[-540222]: Khối lượng hủy vượt quá khối lượng đang được vay !','[-540222]: Cancel QTTY exceed loan QTTY','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540223,'[-540223]: Loại hình vay đã được sử dụng, không cho phép thay đổi thông tin nguồn vay!','[-540223]: LN type is in use, can not change LN information','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540224,'[-540224]: Loại hình vay có nguồn ngân hàng đã được sử dụng, không được phép thay đổi!','[-540224]: LN type with bank source is in use, can not change LN type','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540225,'[-540225]: Món vay có ngày hiện tại nằm trong khoảng tính lãi tối thiểu!','[-540225]: Current date of loan is in minimum period to callculate interest','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540226,'[-540226]: Tổng số ngày vay vượt quá quy định thời gian gia hạn tối đa. Bạn có chắc chắn muốn tái ký tiếp không?','[-540226]: Total loans exceeding the prescribed day time maximum extension . Are you sure you want to not re-sign?!','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540227,'[-540227]: Món vay này đã được thanh lý tái ký','[-540227]: This loan was liquidated re- signed!','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540229,'[-540229]: Xuất dữ liệu báo cáo ghi log không thành công!','[-540229]: Export report data to disburse not successful!','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540230,'[-540230]: Món vay thanh lý tái ký được giải ngân tại ngày hiện tại!','[-540230]: Loans drawdown on current date','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540231,'[-540231]: Số tiền thanh lý nhỏ hơn số tiền tái ký và số tiền khả dụng của tiểu khoản!','[-540231]: Disposal amount less than renew amount and usable amount','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540232,'[-540232]: Món vay không thuộc tiểu khoản thực hiện, kiểm tra lại thông tin món vay!','[-540232]: Loans do not belong to account, check again loan information','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540233,'[-540233]: Tỷ lệ thực tế của tiểu khoản dưới tỷ lệ cảnh báo. Giao dịch không được phép thực hiện!','[-540233]: Margin rate of the sub-account under the safety ratio , the transaction is not permitted to perform!','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540234,'[-540234]: Hạn mức bảo lảnh cấp không đủ cho giải ngân bảo lãnh!','[-540234]: Not enough T0 limit','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-540235,'[-540235]: Vượt quá hạn mức vay tuân thủ nguồn UBCK!','[-540235]: Exceed comply limit with SSC!','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-541113,'Số tiền trả nợ phải lớn hơn 0! ','Repayment amount must be greater than 0!','LN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-541114,'Số tiền CTY trả hộ đã thay đổi. Vui lòng nhập lại giao dịch để lấy số mới nhất! ','Company amount paid household has changed . Please re-enter the transaction to retrieve the latest score! ','LN',null);
COMMIT;
/
