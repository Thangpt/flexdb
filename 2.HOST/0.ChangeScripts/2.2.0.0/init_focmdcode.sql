truncate table FOCMDCODE;
-- BASE API
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fn_check_account_@', 'select corebank, ''N'' alternateacct from afmast where (acctno=:accountid)', 'Y', 'service', 'Check account @');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fn_get_check_bank_balance_info', 'select corebank, ''N'' alternateacct, bankname, bankacctno from afmast where (acctno=:accountid)', 'Y', 'service', 'Lấy thông tin bank acc của tiểu khoản ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fn_get_deferror', 'SELECT * FROM DEFERROR', 'Y', 'error', 'Lấy bảng mã lỗi');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fn_get_deferror_fds', 'SELECT * FROM DEFERROR WHERE MODCODE IN (''DO'', ''DA'', ''DT'', ''DC'')', 'Y', 'error', 'Lấy bảng mã lỗi phái sinh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_CreateTermDeposit', 'BEGIN fopks_api.pr_CreateTermDeposit(:afacctno,:tdactype,:amt,:auto,:desc,:err_code,:err_msg,:via,:ipaddress,:validationtype,:devicetype,:device); END;', 'Y', 'ultility', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetAdvancedPayment', 'BEGIN fopks_api.pr_GetAdvancedPayment(:ret,:afacctno,:f_date,:t_date,:status,:advplace,:custodycd); END;', 'Y', 'ultility', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetCashStatement', 'BEGIN fopks_api.pr_GetCashStatement(:ret,:afacctno,:f_date,:t_date); END;', 'Y', 'report', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetCashTransfer', 'BEGIN fopks_api.pr_GetCashTransfer(:ret,:custodycd,:afacctno,:f_date,:t_date,:status); END;', 'Y', 'ultility', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetDetailDFInfor', 'BEGIN fopks_api.pr_GetDetailDFInfor(:ret,:afacctno,:groupid); END;', 'Y', 'ultility', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetInfo4Margin', 'BEGIN fopks_api.pr_GetInfo4Margin(:ret,:strafacctno,:strcustodycd); END;', 'Y', 'acc', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetOrder', 'BEGIN fopks_api.pr_GetOrder(:ret,:custodycd,:afacctno,:f_date,:t_date,:symbol,:status,:exectype,:p_tlid); END;', 'Y', 'report', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetRightOffInfor', 'BEGIN fopks_api.pr_GetRightOffInfor(:ret,:custodycd,:afacctno,:f_date,:t_date); END;', 'Y', 'ultility', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetSecureRatio', 'BEGIN fopks_api.pr_GetSecureRatio(:ret,:accountid,:symbol,:exectype,:pricetype,:timetype,:quoteprice,:orderqtty,:via); END;', 'Y', 'order', 'Get secureratio cho luồng hold bank');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetSecuritiesStatement', 'BEGIN fopks_api.pr_GetSecuritiesStatement(:ret,:afacctno,:f_date,:t_date,:symbol); END;', 'Y', 'report', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_TermDepositRegister', 'BEGIN fopks_api.pr_TermDepositRegister(:afacctno,:tdacctno,:desc,:err_code,:err_msg,:via,:ipaddress,:validationtype,:devicetype,:device); END;', 'Y', 'ultility', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getAFAcountInfo', 'BEGIN fopks_inquiryApi.pr_getAFAcountInfo(:ret,:afacctno); END;', 'Y', 'user', 'Thông tin cá nhân /afacctnoInfor');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_get_PNL_executed', 'BEGIN fopks_api.pr_get_PNL_executed(:ret,:custodycd,:afacctno,:symbol,:f_date,:t_date); END;', 'Y', 'report', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_get_ci_transfer_amount', 'BEGIN fopks_api.pr_get_ci_transfer_amount(:ret,:afacctno,:type); END;', 'Y', 'ultility', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_get_ciacount', 'BEGIN fopks_api.pr_get_ciacount(:ret,:custodycd,:afacctno); END;', 'Y', 'ultility', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_get_seacount', 'BEGIN fopks_api.pr_get_seacount(:ret,:custodycd,:afacctno); END;', 'Y', 'order', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_authapi.pr_checkTradingPass', 'BEGIN fopks_authapi.pr_checkTradingPass(:username,:password,:err_code,:err_msg); END;', 'Y', 'auth', 'Kiểm tra mã xác thực');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_authapi.pr_getAuthType', 'BEGIN fopks_authapi.pr_getAuthType(:username,:via,:authtype,:mobile1,:mobile2,:email,:err_code,:err_msg); END;', 'Y', 'auth', 'Lấy hình thức xác thực của tài khoản');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_authapi.sp_login', 'BEGIN fopks_authapi.sp_login(:username,:password,:tlid,:tlfullname,:role,:err_code,:err_param); END;', 'Y', 'login', 'Hàm login LocalStrategy của sso');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_brokerapi.pr_getAccountByBroker', 'BEGIN fopks_brokerapi.pr_getAccountByBroker(:ret,:tlid,:custodycd,:err_code,:err_msg); END;', 'Y', 'broker', 'Lấy danh sách tiểu khoản của khách hàng careby bởi môi giới');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_brokerapi.pr_getBrokerInfo', 'BEGIN fopks_brokerapi.pr_getBrokerInfo(:ret,:tlid,:err_code,:err_msg); END;', 'Y', 'broker', 'Lấy thông tin môi giới');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_brokerapi.pr_getCustomerByBroker', 'BEGIN fopks_brokerapi.pr_getCustomersByBroker(:ret,:tlid,:custodycd,:fullname,:idcode,:mobile,:err_code,:err_msg); END;', 'Y', 'broker', 'Tìm customer môi giới careby');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_brokerapi.pr_getOrder', 'BEGIN fopks_brokerapi.pr_getOrder(:ret,:tlid,:accountid,:fromdate,:todate,:symbol,:exectype,:status,:err_code,:err_msg); END;', 'Y', 'broker', 'Lấy báo cáo lịch sử đặt lệnh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_brokerapi.pr_getOrderBuy', 'BEGIN fopks_brokerapi.pr_getOrderBuy(:ret,:tlid,:accountid,:txdate,:via,:err_code,:err_msg); END;', 'Y', 'broker', 'Phiếu lệnh mua');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_brokerapi.pr_getOrderSell', 'BEGIN fopks_brokerapi.pr_getOrderSell(:ret,:tlid,:accountid,:txdate,:via,:err_code,:err_msg); END;', 'Y', 'broker', 'Phiếu lệnh bán');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_datafeed.pr_get_depths', 'BEGIN fopks_datafeed.pr_get_depths(:ret,:symbol,:err_code,:err_msg); END;', 'Y', 'quotes', 'Lấy thông tin depth /depths');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_datafeed.pr_get_mapping', 'BEGIN fopks_datafeed.pr_get_mapping(:ret,:err_code,:err_msg); END;', 'Y', 'quotes', 'Lấy mapping mã ck và sàn /mapping');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_datafeed.pr_get_quotes', 'BEGIN fopks_datafeed.pr_get_quotes(:ret,:err_code,:err_msg); END;', 'Y', 'quotes', 'Lấy thông tin giá all mã /quotes');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_datafeed.pr_get_quotes_by_symbol', 'BEGIN fopks_datafeed.pr_get_quotes_by_symbol(:ret,:symbol,:err_code,:err_msg); END;', 'Y', 'quote', 'Lấy giá theo mã');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetAdvancedInfo', 'BEGIN fopks_inquiryApi.pr_GetAdvancedInfo(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'Các khoản vay ứng trước chưa hoàn ứng /inq/advancedInfo');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetInfoForAdvance', 'BEGIN fopks_inquiryApi.pr_GetInfoForAdvance(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'ultility', 'Lấy thông tin ứng trước /infoForAdvance');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetMortgageInfo', 'BEGIN fopks_inquiryApi.pr_GetMortgageInfo(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'Thông tin các khoản vay cầm cố chưa thanh toán /inq/mortgageInfo');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetOrder', 'BEGIN fopks_inquiryApi.pr_GetOrder(:ret,:accountid,:exectype,:symbol,:err_code,:err_msg); END;', 'Y', 'account', 'Sổ lệnh trong ngày /inq/order');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetRightOffList', 'BEGIN fopks_inquiryApi.pr_GetRightOffList(:ret,:custid,:accountid,:err_code,:err_msg); END;', 'Y', 'ultility', 'Lấy danh sách quyền mua /rightOffList');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetTransferAccountlist', 'BEGIN fopks_inquiryApi.pr_GetTransferAccountlist(:ret,:accountid,:transfertype,:err_code,:err_msg); END;', 'Y', 'ultility', 'Danh sách tài khoản thụ hưởng /inq/transferAccountList');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getActiveOrder', 'BEGIN fopks_inquiryApi.pr_getActiveOrder(:ret,:accountid,:exectype,:symbol,:err_code,:err_msg); END;', 'Y', 'account', 'Danh sách lệnh hoạt động /inq/activeOrder');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getAllocateAdvance', 'BEGIN fopks_inquiryApi.pr_getAllocateAdvance(:ret,:accountid,:advanceamt,:err_code,:err_msg); END;', 'Y', 'ultility', 'Lấy thông tin xác nhận ứng trước /allocateAdvance');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getAvailableTrade', 'BEGIN fopks_inquiryApi.pr_getAvailableTrade(:ret,:accountid,:symbol,:quoteprice,:err_code,:err_msg); END;', 'Y', 'account', 'Lấy thông tin sức mua, kl được mua, kl được bán của tài khoản /inq/getAvailableTrade');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getCIinfo', 'BEGIN fopks_inquiryApi.pr_getCIinfo(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'ord ticket', 'Lấy số dư CK có thể chuyển khoản nội bộ /inq/cashInfo');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getMarginInfo', 'BEGIN fopks_inquiryApi.pr_getMarginInfo(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'Các khoản vay kí quĩ /inq/marginInfo');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getSEAvlTransfer', 'BEGIN fopks_inquiryApi.pr_getSEAvlTransfer(:ret,:accountid,:symbol,:err_code,:err_msg); END;', 'Y', 'ultility', 'Lấy số dư CK có thể chuyển khoản nội bộ /inq/availableStockTransfer');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getSEList', 'BEGIN fopks_inquiryApi.pr_getSEList(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'ord ticket', 'CK hiện có thu gọn /inq/securities');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getSETransferList', 'BEGIN fopks_inquiryApi.pr_getSETransferList(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'ultility', 'Lấy ds tài khoản có thể chuyển khoản CK');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getSecuritiesPortfolio', 'BEGIN fopks_inquiryApi.pr_getSecuritiesPortfolio(:ret,:custid,:accountid,:symbol,:err_code,:err_msg); END;', 'Y', 'account', 'CK hiện có /inq/securitiesPortfolio');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getSummaryAccount', 'BEGIN fopks_inquiryApi.pr_getSummaryAccount(:ret,:custid,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'Tổng hợp tài khoản tiền /summaryAccount');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getTransferParam', 'BEGIN fopks_inquiryApi.pr_getTransferParam(:ret,:accountid,:transfertype,:err_code,:err_msg); END;', 'Y', 'ultility', 'Lấy tham số cho GD chuyển tiền /inq/transferParam');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_active_save_order', 'BEGIN fopks_openapi.pr_active_save_order(:accountid,:foacctno,:err_code,:err_msg); END;', 'Y', 'order', 'Kích hoạt lệnh nháp');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_check_corebank_accounts', 'BEGIN fopks_openapi.pr_check_corebank_accounts(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'service', 'Lấy thông tin bank acc của tiểu khoản ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_delete_orders', 'BEGIN fopks_openapi.pr_delete_orders(:accountid,:orderid,:username,:ipaddress,:err_code,:err_msg); END;', 'Y', 'orders', 'Function delete orders');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_delete_positions', 'BEGIN fopks_openapi.pr_delete_positions(:accountid,:positionid,:err_code,:err_msg); END;', 'Y', 'positions', 'Function delete position');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_delete_save_order', 'BEGIN fopks_openapi.pr_delete_save_order(:accountid,:foacctno,:err_code,:err_msg); END;', 'Y', 'order', 'Xóa lệnh nháp');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_account_flags', 'BEGIN fopks_openapi.pr_get_account_flags(:ret,:custid,:err_code,:err_msg); END;', 'Y', 'config', 'Lấy config api /accounts');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_accounts', 'BEGIN fopks_openapi.pr_get_accounts(:ret,:custid,:err_code,:err_msg); END;', 'Y', 'config', 'Lấy danh sách tài khoản');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_amdata', 'BEGIN fopks_openapi.pr_get_amdata(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'Lấy thông tin amdata cho api /state');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_cfg_accmanagercolumn', 'BEGIN fopks_openapi.pr_get_cfg_accmanagercolumn(:ret,:tableid,:err_code,:err_msg); END;', 'Y', 'config', 'Lấy thông tin accountManager/columns api /config');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_cfg_accmanagertable', 'BEGIN fopks_openapi.pr_get_cfg_accmanagertable(:ret,:err_code,:err_msg); END;', 'Y', 'config', 'Lấy thông tin accountManager api /config');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_cfg_duration', 'BEGIN fopks_openapi.pr_get_cfg_duration(:ret,:err_code,:err_msg); END;', 'Y', 'config', 'Lấy duration api /config');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_cfg_pulling_interval', 'BEGIN fopks_openapi.pr_get_cfg_pulling_interval(:ret,:groupname,:err_code,:err_msg); END;', 'Y', 'config', 'Lấy pullingInterval api /config');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_executions', 'BEGIN fopks_openapi.pr_get_executions(:ret,:accountid,:instrument,:maxcount,:err_code,:err_msg); END;', 'Y', 'orders', 'Function get orders executions');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_instruments', 'BEGIN fopks_openapi.pr_get_instruments(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'Lấy thông tin các mã của tiểu khoản');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_order_detail', 'BEGIN fopks_openapi.pr_get_orders(:ret,:accountid,:orderid,:err_code,:err_msg); END;', 'Y', 'orders', 'Lấy thông tin 1 lệnh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_orders', 'BEGIN fopks_openapi.pr_get_orders(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'orders', 'Lấy thông tin sổ lệnh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_ordershistory', 'BEGIN fopks_openapi.pr_get_ordershistory(:ret,:accountid,:maxcount,:err_code,:err_msg); END;', 'Y', 'orders', 'Láy lịch sử đặt lệnh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_position_detail', 'BEGIN fopks_openapi.pr_get_positions(:ret,:accountid,:positionid,:err_code,:err_msg); END;', 'Y', 'positions', 'Function get position detail');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_positions', 'BEGIN fopks_openapi.pr_get_positions(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'positions', 'Function get positions');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_save_order', 'BEGIN fopks_openapi.pr_get_save_order(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'accmng', 'Lấy all lệnh nháp /saveorder');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_state', 'BEGIN fopks_openapi.pr_get_state(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'Lấy thông tin cho api /state');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_state_amdata', 'BEGIN fopks_openapi.pr_get_state_amdata(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'Lấy amdata api /state');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_post_orders', 'BEGIN fopks_openapi.pr_post_orders(:accountid,:requestid,:username,:instrument,:qty,:side,:type,:limitprice,:stopprice,:durationtype,:durationdatetime,:stoploss,:takeprofit,:digitalsignature,:ipaddress,:orderid,:err_code,:err_msg); END;', 'Y', 'orders', 'Tạo lệnh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_put_orders', 'BEGIN fopks_openapi.pr_put_orders(:accountid,:orderid,:username,:qty,:limitprice,:stopprice,:stoploss,:takeprofit,:digitalsignature,:ipaddress,:err_code,:err_msg); END;', 'Y', 'orders', 'Sửa lệnh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_put_positions', 'BEGIN fopks_openapi.pr_put_positions(:ret,:accountid,:stoploss,:takeprofit,:err_code,:err_msg); END;', 'Y', 'positions', 'Function update positions');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_save_order', 'BEGIN fopks_openapi.pr_save_order(:accountid,:requestid,:username,:instrument,:qty,:side,:type,:limitprice,:digitalsignature,:ipaddress,:err_code,:err_msg); END;', 'Y', 'order', 'Lưu lệnh nháp /saveorder');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetAdvancedStatement', 'BEGIN fopks_reportapi.pr_GetAdvancedStatement(:ret,:accountid,:fromdate,:todate,:err_code,:err_msg); END;', 'Y', 'ultility', 'Lịch sử ứng trước /report/advancedStatement');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetCashTransferStatement', 'BEGIN fopks_reportapi.pr_GetCashTransferStatement(:ret,:accountid,:fromdate,:todate,:err_code,:err_msg); END;', 'Y', 'ultility', 'Lịch sử chuyển tiền /report/cashTransferStatement');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetRightOffStatement', 'BEGIN fopks_reportapi.pr_GetRightOffStatement(:ret,:custid,:accountid,:fromdate,:todate,:err_code,:err_msg); END;', 'Y', 'ultility', 'Lịch sử đăng kí quyền mua /report/rightOffStatement');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getCashStatement', 'BEGIN fopks_reportapi.pr_getCashStatement(:ret,:accountId,:fromDate,:toDate,:err_code,:err_msg); END;', 'Y', 'report', 'Lịch sử giao dịch tiền /cashStatementHist');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getOrder', 'BEGIN fopks_reportapi.pr_getOrder(:ret,:custid,:accountId,:fromDate,:toDate,:symbol,:execType,:orsStatus,:err_code,:err_msg); END;', 'Y', 'report', 'Lịch sử đặt lệnh /orderHist');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getOrderMatch', 'BEGIN fopks_reportapi.pr_getOrderMatch(:ret,:custId,:afacctno,:fromdate,:todate,:symbol,:exectype,:err_code,:err_msg); END;', 'Y', 'report', 'Lấy lệnh khớp /orderMatch');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getPnlExecuted', 'BEGIN fopks_reportapi.pr_getPnlExecuted(:ret,:custid,:accountId,:fromDate,:toDate,:symbol, :tradePlace,:err_code,:err_msg); END;', 'Y', 'report', 'Lãi lỗ đã thực hiện /pnlExecuted');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getSecuritiesStatement', 'BEGIN fopks_reportapi.pr_getSecuritiesStatement(:ret,:accountId,:fromDate,:toDate,:symbol,:err_code,:err_msg); END;', 'Y', 'report', 'Lịch sử giao dịch CK /securitiesStatement');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_sa.Sp_login', 'BEGIN fopks_api.sp_login(:username,:password,:tlid,:tlfullname,:err_code,:err_param); END;', 'Y', 'login', 'FK suwr dungj');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_sa.pr_get_all_account', 'BEGIN fopks_sa.pr_get_all_account(:ret,:err_code,:err_msg); END;', 'Y', 'config', 'K sử dụng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_sa.pr_get_all_account_broker', 'BEGIN fopks_sa.pr_get_all_account_broker(:ret,:err_code,:err_msg); END;', 'Y', 'broker', 'Get all broker and custid careby');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_sa.pr_get_allcode', 'BEGIN fopks_sa.pr_get_allcode(:ret,:err_code,:err_msg); END;', 'Y', 'config', 'K sử dụng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_ExternalTransfer', 'BEGIN fopks_ultilityApi.pr_ExternalTransfer(:accountid,:benefitbank,:benefitaccount,:benefitname,:benefitlisensecode,:amout,:feeamount,:vatamount,:transdescription,:ipaddress,:err_code,:err_msg); END;', 'Y', 'ultility', 'Chuyển tiền ra ngoài /externalTransfer');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_InternalTransfer', 'BEGIN fopks_ultilityApi.pr_InternalTransfer(:accountid,:receiveaccount,:amout,:transdescription,:ipaddress,:err_code,:err_msg); END;', 'Y', 'ultility', 'Chuyển tiền nội bộ /internalTransfer');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_advanced', 'BEGIN fopks_ultilityApi.pr_advanced(:accountid,:txdate,:paidDate,:advanceamt,:feeAmt,:days,:advancedMaxAmt,:desc,:ipaddress,:err_code,:err_msg); END;', 'Y', 'ultility', 'Thực hiện ứng trước /advanced');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_checkCashTransfer', 'BEGIN fopks_ultilityApi.pr_checkCashTransfer(:accountid,:type,:amount,:receiveaccount,:receiveamout,:feeamount,:vatamout,:err_code,:err_msg); END;', 'Y', 'ultility', 'Kiểm tra thông tin GD chuyển tiền /checkCashTransfer');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_rightOffRegiter', 'BEGIN fopks_ultilityApi.pr_rightOffRegiter(:accountid,:camastid,:qtty,:desc,:ipaddress,:err_code,:err_msg); END;', 'Y', 'ultility', 'Đăng kí mua CK sự kiện quyền /rightOffRegiter');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_transferStock', 'BEGIN fopks_ultilityApi.pr_transferStock(:accountid,:receiveaccount,:symbol,:qtty,:desc,:ipaddress,:err_code,:err_msg); END;', 'Y', 'ultility', 'Chuyển khoản CK nội bộ /tranferStock');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityapi.pr_updatepassonline', 'BEGIN fopks_ultilityapi.pr_updatepassonline(:username,:pwttype,:oldpassword,:password,:err_code,:err_msg); END;', 'Y', 'user', 'Thay đổi mk/mã pin /inq/changePass');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('gettransact_fee', 'select fn_gettransact_fee(:pv_feecode,:pv_amount) FEEAMOUNT from dual', 'Y', 'acc', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('htspks_api.sp_get_active_order_by_careby', 'BEGIN htspks_api.sp_get_active_order_by_careby(:ret,:txdate,:tlid,:custodycd,:afacctno,:exectype,:symbol); END;', 'Y', 'accmng', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('htspks_api.sp_get_order_by_careby', 'BEGIN htspks_api.sp_get_order_by_careby(:ret,:txdate,:tlid,:custodycd,:afacctno,:exectype,:symbol); END;', 'Y', 'accmng', 'K dùng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('pr_getppse', 'BEGIN pr_getppse(:ret,:afacctno,:symbol,:quoteprice,:via); END;', 'Y', 'order', 'K dùng');
INSERT INTO focmdcode
(cmdcode, cmdtext, cmduse, cmdtype, cmddesc)
VALUES('fopks_inquiryApi.pr_GetStockTransferList', 'BEGIN fopks_inquiryApi.pr_GetStockTransferList(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'Lấy thông tin chuyển khoản chứng khoán');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetStockTransferStatement', 'BEGIN fopks_reportapi.pr_GetStockTransferStatement(:ret,:custid,:accountid,:fromDate,:toDate,:err_code,:err_msg); END;', 'Y', 'account', 'Lịch sử chuyển khoản chứng khoán');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetLoanList', 'BEGIN fopks_reportapi.pr_GetLoanList(:ret,:custid,:accountid,:fromDate,:toDate,:err_code,:err_msg); END;', 'Y', 'ultility', 'Tra cứu món vay');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetPaymentHist', 'BEGIN fopks_reportapi.pr_GetPaymentHist(:ret,:custid,:accountid,:fromDate,:toDate,:err_code,:err_msg); END;', 'Y', 'ultility', 'Thông tin trả nợ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetAccountAsset', 'BEGIN fopks_inquiryApi.pr_GetAccountAsset(:ret,:accountId,:err_code,:err_msg); END;', 'Y', 'report', 'Báo cáo tài sản /accountAsset');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetAvlSellOddLot', 'BEGIN fopks_inquiryApi.pr_GetAvlSellOddLot(:ret,:custid,:accountid,:err_code,:err_msg); END;', 'Y', 'ultility', 'Tra cứu thông tin giao dịch lô lẻ /avlSellOddLot');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetBonds2SharesList', 'BEGIN fopks_inquiryApi.pr_GetBonds2SharesList(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'report', 'Tra cứu thông tin chuyển đổi trái phiếu');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetSellOddLotHist', 'BEGIN fopks_reportapi.pr_GetSellOddLotHist(:ret,:custid,:accountid,:fromdate,:todate,:err_code,:err_msg); END;', 'Y', 'report', 'Lấy tiểu sử giao dịch lô lẻ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_registSellOddLot', 'BEGIN fopks_ultilityApi.pr_registSellOddLot(:accountid,:symbol,:quantity,:price,:err_code,:err_msg); END;', 'Y', 'reg', 'Đăng ký giao dịch lô lẻ trên cả tài khoản');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetBondsToSharesHist', 'BEGIN fopks_reportapi.pr_GetBondsToSharesHist(:ret,:accountid,:fromdate,:todate,:err_code,:err_msg); END;', 'Y', 'report', 'lịch sử chuyển đổi trái phiếu');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetConfirmOrderHist', 'BEGIN fopks_reportapi.pr_GetConfirmOrderHist(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'report', 'tra cứu danh sách xác nhận lệnh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_Bonds2SharesRegister', 'BEGIN fopks_ultilityApi.pr_Bonds2SharesRegister(:accountid,:caSchId,:quantity,:desc,:ipaddress,:err_code,:err_msg); END;', 'Y', 'reg', 'Đăng ký chuyển đổi trái phiếu');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_confirmOrder', 'BEGIN fopks_ultilityApi.pr_confirmOrder(:accountid,:custid,:orderId,:ipaddress,:err_code,:err_msg); END;', 'Y', 'reg', 'Giao dịch thực hiện xác nhận lệnh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getBankInfo', 'BEGIN fopks_inquiryApi.pr_getBankInfo(:ret,:err_code,:err_msg); END;', 'Y', 'report', 'Lấy danh sách ngân hàng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getBankBranchInfo', 'BEGIN fopks_inquiryApi.pr_getBankBranchInfo(:ret,:bankNo,:err_code,:err_msg); END;', 'Y', 'report', 'Lấy danh sách chi nhánh ngân hàng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_registTransferAcct', 'BEGIN fopks_ultilityApi.pr_registTransferAcct(:accountId,:bankAcName,:bankAcc,:bankName,:bankId,:bankOrgNo,:branch,:city,:hintName,:ipAddress,:err_code,:err_msg); END;', 'Y', 'reg', 'Đăng ký người thụ hưởng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getTemplates', 'BEGIN fopks_inquiryApi.pr_getTemplates(:ret,:accountId,:type,:err_code,:err_msg); END;', 'Y', 'report', 'Danh sách tt đăng ký nhận bản tin sms/email');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_RemoveTransferAcct', 'BEGIN fopks_ultilityApi.pr_RemoveTransferAcct(:accountId,:bankAcc,:err_code,:err_msg); END;', 'Y', 'remove', 'Xóa danh sách tài khoản thụ hưởng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_editTemplate', 'BEGIN fopks_ultilityApi.pr_editTemplate(:accountId,:code,:type,:err_code,:err_msg); END;', 'Y', 'reg', 'Đăng ký/Hủy đăng ký nhận bản tin sms/email');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_cancelSellOddLot', 'BEGIN fopks_ultilityApi.pr_cancelSellOddLot(:accountId,:symbol,:txnum,:txdate,:err_code,:err_msg); END;', 'Y', 'reg', 'Hủy đăng ký lô lẻ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_editCustInfo', 'BEGIN fopks_ultilityApi.pr_editCustInfo(:custid,:address,:err_code,:err_msg); END;', 'Y', 'repot', 'Cập nhật địa chỉ liên hệ BKSV');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_changeTelePin', 'BEGIN fopks_ultilityApi.pr_changeTelePin(:custid,:newpin,:err_code,:err_msg); END;', 'Y', 'repot', 'Thay đổi mã pin tele');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_authapi.pr_getSerialNum', 'BEGIN fopks_authapi.pr_getSerialNum(:custid,:serialNum,:err_code,:err_msg); END;', 'Y', 'report', 'Kiểm tra serial number');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_resetpassonline', 'BEGIN fopks_api.pr_resetpassonline(:userName,:idCode,:mobile,:email,:err_code,:err_msg); END;', 'Y', 'resset', 'Reset mật khẩu');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_get_loan_policy', 'BEGIN fopks_inquiryApi.pr_get_loan_policy(:ret,:err_code,:err_msg); END;', 'Y', 'report', 'Danh sách chính sách cho vay của KB');
--  FDS API
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_PROCESSDT02', 'BEGIN fds_broker_api.PR_PROCESSDT02(:tlId,:custodycd,:accountId,:amount,:iorofee,:desc,:err_code,:err_msg,:ipaddress,:via,:validationType,:deviceType,:device); END;', 'Y', 'reg', 'Nộp tiền tài khoản ký quỹ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.fds_OrderHistory', 'BEGIN fds_broker_api.fds_OrderHistory(:ret,:accountId,:fromDate,:toDate,:orderType,:symbol,:status); END;', 'Y', 'reg', 'Lịch sử đặt lệnh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETDT02', 'BEGIN fds_broker_api.PR_GETDT02(:ret,:username,:fromDate,:toDate,:status); END;', 'Y', 'reg', 'Lịch sử nộp tiền vào tài khoản ký quỹ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETDT01', 'BEGIN fds_broker_api.PR_GETDT01(:ret,:username,:fromDate,:toDate,:status); END;', 'Y', 'reg', 'Lịch sử nộp tiền vào tài khoản giao dịch phái sinh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETDT13', 'BEGIN fds_broker_api.PR_GETDT13(:ret,:username,:fromDate,:toDate,:status); END;', 'Y', 'reg', 'Lịch sử rút tiền từ tài khoản giao dịch phái sinh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETDT07', 'BEGIN fds_broker_api.PR_GETDT07(:ret,:username,:fromDate,:toDate,:status); END;', 'Y', 'reg', 'Rút tiền ký quỹ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.fds_HistoryVIMCash', 'BEGIN fds_broker_api.fds_HistoryVIMCash(:ret,:custodycd,:accountId,:fromDate,:toDate); END;', 'Y', 'report', 'Lịch sử giao dịch tài khoản ký quỹ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getCashOnHandHist', 'BEGIN fds_broker_api.pr_getCashOnHandHist(:ret,:accountId,:fromDate,:toDate); END;', 'Y', 'report', 'Lịch sử giao dịch tiền tài khoản công ty');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_PROCESSDT07', 'BEGIN fds_broker_api.PR_PROCESSDT07(:tlId,:custodycd,:accountId,:amount,:iorofee,:desc,:err_code,:err_msg,:ipaddress,:via,:validationType,:deviceType,:device); END;', 'Y', 'reg', 'Rút tiền từ tài khoản ký quỹ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.fds_FDSCollateralsdtlHistory', 'BEGIN fds_broker_api.fds_FDSCollateralsdtlHistory(:ret,:accountId,:fromDate,:toDate,:symbol); END;', 'Y', 'report', 'Lịch sử giao dịch tài khoản đảm bảo');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getStamentDebt', 'BEGIN fds_broker_api.pr_getStamentDebt(:ret,:dmAccount,:accountId,:fromDate,:toDate); END;', 'Y', 'report', 'Sao kê giải ngân và thu nợ thấu chi');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETSTAMENTPOSITIONS', 'BEGIN fds_broker_api.PR_GETSTAMENTPOSITIONS(:ret,:fromDate,:toDate,:dmAccount,:accountId,:uaCode,:symbol,:tltxCd); END;', 'Y', 'report', 'Sao kê vị thế');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETCALPOSITIONFEE', 'BEGIN fds_broker_api.PR_GETCALPOSITIONFEE(:ret,:fromDate,:toDate,:dmAccount,:accountId); END;', 'Y', 'report', 'Bảng kê phí vị thế');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getBalanceAmount', 'BEGIN fds_broker_api.pr_getBalanceAmount(:ret,:accountId); END;', 'Y', 'report', 'Thông tin số dư tài khoản');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FDS_GET_MARGINLIST', 'SELECT bk.symbol,bk.haircut,bk.price_max, LEAST(bk.price_max, price_asset) price_asset, sb.price_rf from dtmast dt, fdsbaskets bk, instruments sb where dt.pbassetsid = bk.basketid AND bk.symbol = sb.symbol and (dt.acctno =:accountid)', 'Y', 'report', 'Thông tin danh sách chứng khoán được ký quỹ');
INSERT INTO focmdcode
(cmdcode, cmdtext, cmduse, cmdtype, cmddesc)
VALUES('FN_GETDTMAST_AVLCASHWITHDRAW', 'select fds_broker_api.FN_GETDTMAST_AVLCASHWITHDRAW(:pv_dtaacctno) AVLCASHWITHDRAW from dual', 'Y', 'error', 'Lấy số tiền tối đa được rút - nộp tiền vào tài khoản kí quỹ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FN_GETINSTRUMENT', 'SELECT fi.symbol, fi.delisteddt FROM fdsinstruments fi WHERE halt <> ''W'' AND (uacode = :uaCode)', 'Y', 'report', 'Thông tin mã hợp đồng - Các mẫu hợp đồng hiện tại');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_PROCESSDT17', 'BEGIN fds_broker_api.PR_PROCESSDT17(:tlId,:accountId,:desc,:err_code,:err_msg,:ipaddress,:via,:validationType,:deviceType,:device); END;', 'Y', 'report', 'Tất toán nợ thấu chi - Submit');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETDT17', 'BEGIN fds_broker_api.PR_GETDT17(:ret,:username,:fromDate,:toDate,:status); END;', 'Y', 'report', 'Tất toán nợ thấu chi - Submit');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getPROCESSDT17', 'BEGIN fds_broker_api.pr_getPROCESSDT17(:ret,:accountId); END;', 'Y', 'report', ' Tất toán nợ thấu chi - Thông tin tiền, nợ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getSpecificationInfo', 'BEGIN fopks_inquiryApi.pr_getSpecificationInfo(:ret,:uaCode,:err_code,:err_msg); END;', 'Y', 'report', 'Thông tin mã hợp đồng - Thông tin hợp đồng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getOpenPositionsInfo', 'BEGIN fds_broker_api.pr_getOpenPositionsInfo(:ret,:dmaacctno,:dtaacctno,:instrument); END;', 'Y', 'report', 'Thông tin vị thế mở');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getClosePositionsInfo', 'BEGIN fds_broker_api.pr_getClosePositionsInfo(:ret,:dmaacctno,:dtaacctno,:instrument); END;', 'Y', 'report', 'Thông tin vị thế đóng');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.fds_getwaittomatchorder', 'BEGIN fds_broker_api.fds_getwaittomatchorder(:ret,:dmaacctno,:dtaacctno,:orderside,:instrument); END;', 'Y', 'report', 'Thông tin lệnh chờ khớp');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_engine_api.sp_get_order_tx6105', 'BEGIN fds_engine_api.sp_get_order_tx6105(:ret,:userId,:placeCustid,:afacctno,:execType,:symbol,:status,:fromDate,:toDate,:classcd,:searchTime,:seqNum); END;', 'Y', 'report', 'Thông tin lệnh điều kiện');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getSecuritiesInfo', 'BEGIN fds_broker_api.pr_getSecuritiesInfo(:ret,:accountId); END;', 'Y', 'report', 'Chứng khoán ký quỹ');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_PROCESSDT13', 'BEGIN fds_broker_api.PR_PROCESSDT13(:tlId,:custodycd,:accountId,:amount,:desc,:err_code,:err_msg,:ipaddress,:via,:validationType,:deviceType,:device,:json_msg); END;', 'Y', 'report', 'Rút tiền từ tài khoản giao dịch phái sinh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_PROCESSDT01', 'BEGIN fds_broker_api.PR_PROCESSDT01(:tlId,:custodycd,:accountId,:amount,:desc,:err_code,:err_msg,:ipaddress,:via,:validationType,:deviceType,:device,:json_msg); END;', 'Y', 'report', 'Nộp tiền vào tài khoản giao dịch phái sinh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FDS_CSPKS_SYSTEM.FN_GETFEE3611', 'select FDS_CSPKS_SYSTEM.FN_GETFEE3611(:pv_Value,:pv_feecode,:pv_iofee) FEE from dual', 'Y', 'report', 'Lấy kiểu phí');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.fds_getcustomersummary', 'BEGIN fds_broker_api.fds_getcustomersummary(:ret,:p_dmaacctno,:p_dtaacctno); END;', 'Y', 'report', 'Lấy tiền rút tối đa');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getOrderFeeAndTax', 'BEGIN  fopks_reportapi.pr_getOrderFeeAndTax(:ret,:accountId,:fromDate,:toDate,:err_code,:err_msg); END;', 'Y', 'report', 'Bảng kê tính phí giao dịch');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getOrderMatch', 'BEGIN fopks_inquiryApi.pr_getOrderMatch(:ret,:accountId,:err_code,:err_msg); END;', 'Y', 'report', 'Thông tin lệnh khớp trong ngày');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getActiveOrder_fds', 'BEGIN fopks_inquiryApi.pr_getActiveOrder(:ret,:accountId,:err_code,:err_msg); END;', 'Y', 'report', 'Thông tin lệnh đặt trong ngày');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryapi.pr_getsummaryaccount_fds', 'BEGIN fopks_inquiryapi.pr_getsummaryaccount(:ret,:accountId,:err_code,:err_msg); END;', 'Y', 'report', 'Tổng hợp tài khoản');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryapi.pr_getcalcdepositamt2buy', 'BEGIN fopks_inquiryapi.pr_getcalcdepositamt2buy(:ret,:accountId,:symbol,:type,:err_code,:err_msg); END;', 'Y', 'report', 'Thông tin lệnh đặt trong ngày');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getordermatch_fds', 'BEGIN fopks_reportapi.pr_getordermatch(:ret,:accountId,:fromDate,:toDate,:symbol,:side); END;', 'Y', 'report', 'Lịch sử khớp lệnh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getpnlexecuted_fds', 'BEGIN fopks_reportapi.pr_getpnlexecuted(:ret,:accountId,:fromDate,:toDate,:symbol); END;', 'Y', 'report', 'Lãi lỗ trong ngày');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FN_GET_BASE_SECURITIES', 'SELECT VALUECD FROM ( SELECT UACODE VALUECD, UACODE VALUE, UACODE DISPLAY, UACODE EN_DISPLAY, UACODE DESCRIPTION FROM FDSSPECIFICATIONS UNION ALL SELECT ''ALL'', ''ALL'', ''ALL'', ''ALL'', ''ALL'' FROM DUAL ) ORDER BY DISPLAY', 'Y', 'report', 'Lấy chứng khoán cơ sở');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FN_GET_FDS_SECURITIES', 'SELECT VALUECD FROM ( SELECT SYMBOL VALUECD, SYMBOL VALUE, SYMBOL DISPLAY, SYMBOL EN_DISPLAY,SYMBOL DESCRIPTION FROM FDSINSTRUMENTS UNION ALL SELECT ''ALL'', ''ALL'', ''ALL'', ''ALL'', ''ALL'' FROM DUAL ) ORDER BY DISPLAY', 'Y', 'report', 'Lấy chứng khoán phái sinh');
insert into FOCMDCODE (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FN_GET_TRANSACTION_CODE', 'SELECT DISPLAY, EN_DISPLAY  FROM ( SELECT TLTXCD VALUECD, TLTXCD VALUE, TXDESC DISPLAY, EN_TXDESC EN_DISPLAY, EN_TXDESC DESCRIPTION FROM TLTX WHERE TLTXCD LIKE ''D%'' AND TLTXCD NOT LIKE ''DF%''  UNION ALL SELECT ''ALL'', ''ALL'', ''ALL'', ''ALL'', ''ALL'' FROM DUAL  ) ORDER BY DISPLAY', 'Y', 'report', 'Mã giao dịch');
commit;
/

