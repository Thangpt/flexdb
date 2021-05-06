truncate table FOCMDCODE;
-- BASE API
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fn_check_account_@', 'select corebank, ''N'' alternateacct from afmast where (acctno=:accountid)', 'Y', 'service', 'Check account @');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fn_get_check_bank_balance_info', 'select corebank, ''N'' alternateacct, bankname, bankacctno from afmast where (acctno=:accountid)', 'Y', 'service', 'L?y thông tin bank acc c?a ti?u kho?n ');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fn_get_deferror', 'SELECT * FROM DEFERROR', 'Y', 'error', 'L?y b?ng mã l?i');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fn_get_deferror_fds', 'SELECT * FROM DEFERROR WHERE MODCODE IN (''DO'', ''DA'', ''DT'', ''DC'')', 'Y', 'error', 'L?y b?ng mã l?i phái sinh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_CreateTermDeposit', 'BEGIN fopks_api.pr_CreateTermDeposit(:afacctno,:tdactype,:amt,:auto,:desc,:err_code,:err_msg,:via,:ipaddress,:validationtype,:devicetype,:device); END;', 'Y', 'ultility', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetAdvancedPayment', 'BEGIN fopks_api.pr_GetAdvancedPayment(:ret,:afacctno,:f_date,:t_date,:status,:advplace,:custodycd); END;', 'Y', 'ultility', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetCashStatement', 'BEGIN fopks_api.pr_GetCashStatement(:ret,:afacctno,:f_date,:t_date); END;', 'Y', 'report', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetCashTransfer', 'BEGIN fopks_api.pr_GetCashTransfer(:ret,:custodycd,:afacctno,:f_date,:t_date,:status); END;', 'Y', 'ultility', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetDetailDFInfor', 'BEGIN fopks_api.pr_GetDetailDFInfor(:ret,:afacctno,:groupid); END;', 'Y', 'ultility', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetInfo4Margin', 'BEGIN fopks_api.pr_GetInfo4Margin(:ret,:strafacctno,:strcustodycd); END;', 'Y', 'acc', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetOrder', 'BEGIN fopks_api.pr_GetOrder(:ret,:custodycd,:afacctno,:f_date,:t_date,:symbol,:status,:exectype,:p_tlid); END;', 'Y', 'report', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetRightOffInfor', 'BEGIN fopks_api.pr_GetRightOffInfor(:ret,:custodycd,:afacctno,:f_date,:t_date); END;', 'Y', 'ultility', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetSecureRatio', 'BEGIN fopks_api.pr_GetSecureRatio(:ret,:accountid,:symbol,:exectype,:pricetype,:timetype,:quoteprice,:orderqtty,:via); END;', 'Y', 'order', 'Get secureratio cho lu?ng hold bank');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_GetSecuritiesStatement', 'BEGIN fopks_api.pr_GetSecuritiesStatement(:ret,:afacctno,:f_date,:t_date,:symbol); END;', 'Y', 'report', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_TermDepositRegister', 'BEGIN fopks_api.pr_TermDepositRegister(:afacctno,:tdacctno,:desc,:err_code,:err_msg,:via,:ipaddress,:validationtype,:devicetype,:device); END;', 'Y', 'ultility', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getAFAcountInfo', 'BEGIN fopks_inquiryApi.pr_getAFAcountInfo(:ret,:afacctno); END;', 'Y', 'user', 'Thông tin cá nhân /afacctnoInfor');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_get_PNL_executed', 'BEGIN fopks_api.pr_get_PNL_executed(:ret,:custodycd,:afacctno,:symbol,:f_date,:t_date); END;', 'Y', 'report', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_get_ci_transfer_amount', 'BEGIN fopks_api.pr_get_ci_transfer_amount(:ret,:afacctno,:type); END;', 'Y', 'ultility', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_get_ciacount', 'BEGIN fopks_api.pr_get_ciacount(:ret,:custodycd,:afacctno); END;', 'Y', 'ultility', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_get_seacount', 'BEGIN fopks_api.pr_get_seacount(:ret,:custodycd,:afacctno); END;', 'Y', 'order', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_authapi.pr_checkTradingPass', 'BEGIN fopks_authapi.pr_checkTradingPass(:username,:password,:err_code,:err_msg); END;', 'Y', 'auth', 'Ki?m tra mã xác th?c');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_authapi.pr_getAuthType', 'BEGIN fopks_authapi.pr_getAuthType(:username,:via,:authtype,:mobile1,:mobile2,:email,:err_code,:err_msg); END;', 'Y', 'auth', 'L?y hình th?c xác th?c c?a tài kho?n');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_authapi.sp_login', 'BEGIN fopks_authapi.sp_login(:username,:password,:tlid,:tlfullname,:role,:err_code,:err_param); END;', 'Y', 'login', 'Hàm login LocalStrategy c?a sso');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_brokerapi.pr_getAccountByBroker', 'BEGIN fopks_brokerapi.pr_getAccountByBroker(:ret,:tlid,:custodycd,:err_code,:err_msg); END;', 'Y', 'broker', 'L?y danh sách ti?u kho?n c?a khách hàng careby b?i môi gi?i');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_brokerapi.pr_getBrokerInfo', 'BEGIN fopks_brokerapi.pr_getBrokerInfo(:ret,:tlid,:err_code,:err_msg); END;', 'Y', 'broker', 'L?y thông tin môi gi?i');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_brokerapi.pr_getCustomerByBroker', 'BEGIN fopks_brokerapi.pr_getCustomersByBroker(:ret,:tlid,:custodycd,:fullname,:idcode,:mobile,:err_code,:err_msg); END;', 'Y', 'broker', 'Tìm customer môi gi?i careby');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_brokerapi.pr_getOrder', 'BEGIN fopks_brokerapi.pr_getOrder(:ret,:tlid,:accountid,:fromdate,:todate,:symbol,:exectype,:status,:err_code,:err_msg); END;', 'Y', 'broker', 'L?y báo cáo l?ch s? d?t l?nh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_brokerapi.pr_getOrderBuy', 'BEGIN fopks_brokerapi.pr_getOrderBuy(:ret,:tlid,:accountid,:txdate,:via,:err_code,:err_msg); END;', 'Y', 'broker', 'Phi?u l?nh mua');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_brokerapi.pr_getOrderSell', 'BEGIN fopks_brokerapi.pr_getOrderSell(:ret,:tlid,:accountid,:txdate,:via,:err_code,:err_msg); END;', 'Y', 'broker', 'Phi?u l?nh bán');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_datafeed.pr_get_depths', 'BEGIN fopks_datafeed.pr_get_depths(:ret,:symbol,:err_code,:err_msg); END;', 'Y', 'quotes', 'L?y thông tin depth /depths');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_datafeed.pr_get_mapping', 'BEGIN fopks_datafeed.pr_get_mapping(:ret,:err_code,:err_msg); END;', 'Y', 'quotes', 'L?y mapping mã ck và sàn /mapping');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_datafeed.pr_get_quotes', 'BEGIN fopks_datafeed.pr_get_quotes(:ret,:err_code,:err_msg); END;', 'Y', 'quotes', 'L?y thông tin giá all mã /quotes');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_datafeed.pr_get_quotes_by_symbol', 'BEGIN fopks_datafeed.pr_get_quotes_by_symbol(:ret,:symbol,:err_code,:err_msg); END;', 'Y', 'quote', 'L?y giá theo mã');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetAdvancedInfo', 'BEGIN fopks_inquiryApi.pr_GetAdvancedInfo(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'Các kho?n vay ?ng tru?c chua hoàn ?ng /inq/advancedInfo');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetInfoForAdvance', 'BEGIN fopks_inquiryApi.pr_GetInfoForAdvance(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'ultility', 'L?y thông tin ?ng tru?c /infoForAdvance');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetMortgageInfo', 'BEGIN fopks_inquiryApi.pr_GetMortgageInfo(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'Thông tin các kho?n vay c?m c? chua thanh toán /inq/mortgageInfo');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetOrder', 'BEGIN fopks_inquiryApi.pr_GetOrder(:ret,:accountid,:exectype,:symbol,:err_code,:err_msg); END;', 'Y', 'account', 'S? l?nh trong ngày /inq/order');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetRightOffList', 'BEGIN fopks_inquiryApi.pr_GetRightOffList(:ret,:custid,:accountid,:err_code,:err_msg); END;', 'Y', 'ultility', 'L?y danh sách quy?n mua /rightOffList');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetTransferAccountlist', 'BEGIN fopks_inquiryApi.pr_GetTransferAccountlist(:ret,:accountid,:transfertype,:err_code,:err_msg); END;', 'Y', 'ultility', 'Danh sách tài kho?n th? hu?ng /inq/transferAccountList');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getActiveOrder', 'BEGIN fopks_inquiryApi.pr_getActiveOrder(:ret,:accountid,:exectype,:symbol,:err_code,:err_msg); END;', 'Y', 'account', 'Danh sách l?nh ho?t d?ng /inq/activeOrder');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getAllocateAdvance', 'BEGIN fopks_inquiryApi.pr_getAllocateAdvance(:ret,:accountid,:advanceamt,:err_code,:err_msg); END;', 'Y', 'ultility', 'L?y thông tin xác nh?n ?ng tru?c /allocateAdvance');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getAvailableTrade', 'BEGIN fopks_inquiryApi.pr_getAvailableTrade(:ret,:accountid,:symbol,:quoteprice,:err_code,:err_msg); END;', 'Y', 'account', 'L?y thông tin s?c mua, kl du?c mua, kl du?c bán c?a tài kho?n /inq/getAvailableTrade');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getCIinfo', 'BEGIN fopks_inquiryApi.pr_getCIinfo(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'ord ticket', 'L?y s? du CK có th? chuy?n kho?n n?i b? /inq/cashInfo');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getMarginInfo', 'BEGIN fopks_inquiryApi.pr_getMarginInfo(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'Các kho?n vay kí qui /inq/marginInfo');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getSEAvlTransfer', 'BEGIN fopks_inquiryApi.pr_getSEAvlTransfer(:ret,:accountid,:symbol,:err_code,:err_msg); END;', 'Y', 'ultility', 'L?y s? du CK có th? chuy?n kho?n n?i b? /inq/availableStockTransfer');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getSEList', 'BEGIN fopks_inquiryApi.pr_getSEList(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'ord ticket', 'CK hi?n có thu g?n /inq/securities');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getSETransferList', 'BEGIN fopks_inquiryApi.pr_getSETransferList(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'ultility', 'L?y ds tài kho?n có th? chuy?n kho?n CK');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getSecuritiesPortfolio', 'BEGIN fopks_inquiryApi.pr_getSecuritiesPortfolio(:ret,:custid,:accountid,:symbol,:err_code,:err_msg); END;', 'Y', 'account', 'CK hi?n có /inq/securitiesPortfolio');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getSummaryAccount', 'BEGIN fopks_inquiryApi.pr_getSummaryAccount(:ret,:custid,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'T?ng h?p tài kho?n ti?n /summaryAccount');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getTransferParam', 'BEGIN fopks_inquiryApi.pr_getTransferParam(:ret,:accountid,:transfertype,:err_code,:err_msg); END;', 'Y', 'ultility', 'L?y tham s? cho GD chuy?n ti?n /inq/transferParam');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_active_save_order', 'BEGIN fopks_openapi.pr_active_save_order(:accountid,:foacctno,:err_code,:err_msg); END;', 'Y', 'order', 'Kích ho?t l?nh nháp');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_check_corebank_accounts', 'BEGIN fopks_openapi.pr_check_corebank_accounts(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'service', 'L?y thông tin bank acc c?a ti?u kho?n ');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_delete_orders', 'BEGIN fopks_openapi.pr_delete_orders(:accountid,:orderid,:username,:ipaddress,:err_code,:err_msg); END;', 'Y', 'orders', 'Function delete orders');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_delete_positions', 'BEGIN fopks_openapi.pr_delete_positions(:accountid,:positionid,:err_code,:err_msg); END;', 'Y', 'positions', 'Function delete position');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_delete_save_order', 'BEGIN fopks_openapi.pr_delete_save_order(:accountid,:foacctno,:err_code,:err_msg); END;', 'Y', 'order', 'Xóa l?nh nháp');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_account_flags', 'BEGIN fopks_openapi.pr_get_account_flags(:ret,:custid,:err_code,:err_msg); END;', 'Y', 'config', 'L?y config api /accounts');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_accounts', 'BEGIN fopks_openapi.pr_get_accounts(:ret,:custid,:err_code,:err_msg); END;', 'Y', 'config', 'L?y danh sách tài kho?n');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_amdata', 'BEGIN fopks_openapi.pr_get_amdata(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'L?y thông tin amdata cho api /state');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_cfg_accmanagercolumn', 'BEGIN fopks_openapi.pr_get_cfg_accmanagercolumn(:ret,:tableid,:err_code,:err_msg); END;', 'Y', 'config', 'L?y thông tin accountManager/columns api /config');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_cfg_accmanagertable', 'BEGIN fopks_openapi.pr_get_cfg_accmanagertable(:ret,:err_code,:err_msg); END;', 'Y', 'config', 'L?y thông tin accountManager api /config');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_cfg_duration', 'BEGIN fopks_openapi.pr_get_cfg_duration(:ret,:err_code,:err_msg); END;', 'Y', 'config', 'L?y duration api /config');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_cfg_pulling_interval', 'BEGIN fopks_openapi.pr_get_cfg_pulling_interval(:ret,:groupname,:err_code,:err_msg); END;', 'Y', 'config', 'L?y pullingInterval api /config');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_executions', 'BEGIN fopks_openapi.pr_get_executions(:ret,:accountid,:instrument,:maxcount,:err_code,:err_msg); END;', 'Y', 'orders', 'Function get orders executions');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_instruments', 'BEGIN fopks_openapi.pr_get_instruments(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'L?y thông tin các mã c?a ti?u kho?n');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_order_detail', 'BEGIN fopks_openapi.pr_get_orders(:ret,:accountid,:orderid,:err_code,:err_msg); END;', 'Y', 'orders', 'L?y thông tin 1 l?nh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_orders', 'BEGIN fopks_openapi.pr_get_orders(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'orders', 'L?y thông tin s? l?nh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_ordershistory', 'BEGIN fopks_openapi.pr_get_ordershistory(:ret,:accountid,:maxcount,:err_code,:err_msg); END;', 'Y', 'orders', 'Láy l?ch s? d?t l?nh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_position_detail', 'BEGIN fopks_openapi.pr_get_positions(:ret,:accountid,:positionid,:err_code,:err_msg); END;', 'Y', 'positions', 'Function get position detail');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_positions', 'BEGIN fopks_openapi.pr_get_positions(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'positions', 'Function get positions');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_save_order', 'BEGIN fopks_openapi.pr_get_save_order(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'accmng', 'L?y all l?nh nháp /saveorder');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_state', 'BEGIN fopks_openapi.pr_get_state(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'L?y thông tin cho api /state');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_state_amdata', 'BEGIN fopks_openapi.pr_get_state_amdata(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'L?y amdata api /state');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_post_orders', 'BEGIN fopks_openapi.pr_post_orders(:accountid,:requestid,:username,:instrument,:qty,:side,:type,:limitprice,:stopprice,:durationtype,:durationdatetime,:stoploss,:takeprofit,:digitalsignature,:ipaddress,:orderid,:err_code,:err_msg); END;', 'Y', 'orders', 'T?o l?nh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_put_orders', 'BEGIN fopks_openapi.pr_put_orders(:accountid,:orderid,:username,:qty,:limitprice,:stopprice,:stoploss,:takeprofit,:digitalsignature,:ipaddress,:err_code,:err_msg); END;', 'Y', 'orders', 'S?a l?nh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_put_positions', 'BEGIN fopks_openapi.pr_put_positions(:ret,:accountid,:stoploss,:takeprofit,:err_code,:err_msg); END;', 'Y', 'positions', 'Function update positions');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_save_order', 'BEGIN fopks_openapi.pr_save_order(:accountid,:requestid,:username,:instrument,:qty,:side,:type,:limitprice,:digitalsignature,:ipaddress,:err_code,:err_msg); END;', 'Y', 'order', 'Luu l?nh nháp /saveorder');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetAdvancedStatement', 'BEGIN fopks_reportapi.pr_GetAdvancedStatement(:ret,:accountid,:fromdate,:todate,:err_code,:err_msg); END;', 'Y', 'ultility', 'L?ch s? ?ng tru?c /report/advancedStatement');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetCashTransferStatement', 'BEGIN fopks_reportapi.pr_GetCashTransferStatement(:ret,:accountid,:fromdate,:todate,:err_code,:err_msg); END;', 'Y', 'ultility', 'L?ch s? chuy?n ti?n /report/cashTransferStatement');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetRightOffStatement', 'BEGIN fopks_reportapi.pr_GetRightOffStatement(:ret,:custid,:accountid,:fromdate,:todate,:err_code,:err_msg); END;', 'Y', 'ultility', 'L?ch s? dang kí quy?n mua /report/rightOffStatement');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getCashStatement', 'BEGIN fopks_reportapi.pr_getCashStatement(:ret,:accountId,:fromDate,:toDate,:err_code,:err_msg); END;', 'Y', 'report', 'L?ch s? giao d?ch ti?n /cashStatementHist');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getOrder', 'BEGIN fopks_reportapi.pr_getOrder(:ret,:custid,:accountId,:fromDate,:toDate,:symbol,:execType,:orsStatus,:err_code,:err_msg); END;', 'Y', 'report', 'L?ch s? d?t l?nh /orderHist');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getOrderMatch', 'BEGIN fopks_reportapi.pr_getOrderMatch(:ret,:custId,:afacctno,:fromdate,:todate,:symbol,:exectype,:err_code,:err_msg); END;', 'Y', 'report', 'L?y l?nh kh?p /orderMatch');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getPnlExecuted', 'BEGIN fopks_reportapi.pr_getPnlExecuted(:ret,:custid,:accountId,:fromDate,:toDate,:symbol, :tradePlace,:err_code,:err_msg); END;', 'Y', 'report', 'Lãi l? dã th?c hi?n /pnlExecuted');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getSecuritiesStatement', 'BEGIN fopks_reportapi.pr_getSecuritiesStatement(:ret,:accountId,:fromDate,:toDate,:symbol,:err_code,:err_msg); END;', 'Y', 'report', 'L?ch s? giao d?ch CK /securitiesStatement');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_sa.Sp_login', 'BEGIN fopks_api.sp_login(:username,:password,:tlid,:tlfullname,:err_code,:err_param); END;', 'Y', 'login', 'FK suwr dungj');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_sa.pr_get_all_account', 'BEGIN fopks_sa.pr_get_all_account(:ret,:err_code,:err_msg); END;', 'Y', 'config', 'K s? d?ng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_sa.pr_get_all_account_broker', 'BEGIN fopks_sa.pr_get_all_account_broker(:ret,:err_code,:err_msg); END;', 'Y', 'broker', 'Get all broker and custid careby');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_sa.pr_get_allcode', 'BEGIN fopks_sa.pr_get_allcode(:ret,:err_code,:err_msg); END;', 'Y', 'config', 'K s? d?ng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_ExternalTransfer', 'BEGIN fopks_ultilityApi.pr_ExternalTransfer(:accountid,:benefitbank,:benefitaccount,:benefitname,:benefitlisensecode,:amout,:feeamount,:vatamount,:transdescription,:ipaddress,:via,:validationtype,:devicetype,:device,:err_code,:err_msg); END;', 'Y', 'ultility', 'Chuy?n ti?n ra ngoài /externalTransfer');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_InternalTransfer', 'BEGIN fopks_ultilityApi.pr_InternalTransfer(:accountid,:receiveaccount,:amout,:transdescription,:ipaddress,:via,:validationtype,:devicetype,:device,:err_code,:err_msg); END;', 'Y', 'ultility', 'Chuy?n ti?n n?i b? /internalTransfer');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_advanced', 'BEGIN fopks_ultilityApi.pr_advanced(:accountid,:txdate,:paidDate,:advanceamt,:feeAmt,:days,:advancedMaxAmt,:desc,:ipaddress,:via,:validationtype,:devicetype,:device,:err_code,:err_msg); END;', 'Y', 'ultility', 'Th?c hi?n ?ng tru?c /advanced');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_checkCashTransfer', 'BEGIN fopks_ultilityApi.pr_checkCashTransfer(:accountid,:type,:amount,:receiveaccount,:receiveamout,:feeamount,:vatamout,:err_code,:err_msg); END;', 'Y', 'ultility', 'Ki?m tra thông tin GD chuy?n ti?n /checkCashTransfer');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_rightOffRegiter', 'BEGIN fopks_ultilityApi.pr_rightOffRegiter(:accountid,:camastid,:qtty,:desc,:ipaddress,:via,:validationtype,:devicetype,:device,:err_code,:err_msg); END;', 'Y', 'ultility', 'Ðang kí mua CK s? ki?n quy?n /rightOffRegiter');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_transferStock', 'BEGIN fopks_ultilityApi.pr_transferStock(:accountid,:receiveaccount,:symbol,:qtty,:desc,:ipaddress,:err_code,:err_msg); END;', 'Y', 'ultility', 'Chuy?n kho?n CK n?i b? /tranferStock');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityapi.pr_updatepassonline', 'BEGIN fopks_ultilityapi.pr_updatepassonline(:username,:pwttype,:oldpassword,:password,:err_code,:err_msg); END;', 'Y', 'user', 'Thay d?i mk/mã pin /inq/changePass');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('gettransact_fee', 'select fn_gettransact_fee(:pv_feecode,:pv_amount) FEEAMOUNT from dual', 'Y', 'acc', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('htspks_api.sp_get_active_order_by_careby', 'BEGIN htspks_api.sp_get_active_order_by_careby(:ret,:txdate,:tlid,:custodycd,:afacctno,:exectype,:symbol); END;', 'Y', 'accmng', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('htspks_api.sp_get_order_by_careby', 'BEGIN htspks_api.sp_get_order_by_careby(:ret,:txdate,:tlid,:custodycd,:afacctno,:exectype,:symbol); END;', 'Y', 'accmng', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('pr_getppse', 'BEGIN pr_getppse(:ret,:afacctno,:symbol,:quoteprice,:via); END;', 'Y', 'order', 'K dùng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetStockTransferList', 'BEGIN fopks_inquiryApi.pr_GetStockTransferList(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'account', 'L?y thông tin chuy?n kho?n ch?ng khoán');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetStockTransferStatement', 'BEGIN fopks_reportapi.pr_GetStockTransferStatement(:ret,:custid,:accountid,:fromDate,:toDate,:err_code,:err_msg); END;', 'Y', 'account', 'L?ch s? chuy?n kho?n ch?ng khoán');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetLoanList', 'BEGIN fopks_reportapi.pr_GetLoanList(:ret,:custid,:accountid,:fromDate,:toDate,:err_code,:err_msg); END;', 'Y', 'ultility', 'Tra c?u món vay');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetPaymentHist', 'BEGIN fopks_reportapi.pr_GetPaymentHist(:ret,:custid,:accountid,:fromDate,:toDate,:err_code,:err_msg); END;', 'Y', 'ultility', 'Thông tin tr? n?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetAccountAsset', 'BEGIN fopks_inquiryApi.pr_GetAccountAsset(:ret,:accountId,:err_code,:err_msg); END;', 'Y', 'report', 'Báo cáo tài s?n /accountAsset');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetAvlSellOddLot', 'BEGIN fopks_inquiryApi.pr_GetAvlSellOddLot(:ret,:custid,:accountid,:err_code,:err_msg); END;', 'Y', 'ultility', 'Tra c?u thông tin giao d?ch lô l? /avlSellOddLot');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_GetBonds2SharesList', 'BEGIN fopks_inquiryApi.pr_GetBonds2SharesList(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'report', 'Tra c?u thông tin chuy?n d?i trái phi?u');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetSellOddLotHist', 'BEGIN fopks_reportapi.pr_GetSellOddLotHist(:ret,:custid,:accountid,:fromdate,:todate,:err_code,:err_msg); END;', 'Y', 'report', 'L?y ti?u s? giao d?ch lô l?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_registSellOddLot', 'BEGIN fopks_ultilityApi.pr_registSellOddLot(:accountid,:symbol,:quantity,:price,:err_code,:err_msg); END;', 'Y', 'reg', 'Ðang ký giao d?ch lô l? trên c? tài kho?n');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetBondsToSharesHist', 'BEGIN fopks_reportapi.pr_GetBondsToSharesHist(:ret,:accountid,:fromdate,:todate,:err_code,:err_msg); END;', 'Y', 'report', 'l?ch s? chuy?n d?i trái phi?u');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_GetConfirmOrderHist', 'BEGIN fopks_reportapi.pr_GetConfirmOrderHist(:ret,:accountid,:err_code,:err_msg); END;', 'Y', 'report', 'tra c?u danh sách xác nh?n l?nh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_Bonds2SharesRegister', 'BEGIN fopks_ultilityApi.pr_Bonds2SharesRegister(:accountid,:caSchId,:quantity,:desc,:ipaddress,:via,:validationtype,:devicetype,:device,:err_code,:err_msg); END;', 'Y', 'reg', 'Ðang ký chuy?n d?i trái phi?u');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_confirmOrder', 'BEGIN fopks_ultilityApi.pr_confirmOrder(:accountid,:custid,:orderId,:ipaddress,:via,:err_code,:err_msg); END;', 'Y', 'reg', 'Giao d?ch th?c hi?n xác nh?n l?nh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getBankInfo', 'BEGIN fopks_inquiryApi.pr_getBankInfo(:ret,:err_code,:err_msg); END;', 'Y', 'report', 'L?y danh sách ngân hàng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getBankBranchInfo', 'BEGIN fopks_inquiryApi.pr_getBankBranchInfo(:ret,:bankNo,:err_code,:err_msg); END;', 'Y', 'report', 'L?y danh sách chi nhánh ngân hàng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_registTransferAcct', 'BEGIN fopks_ultilityApi.pr_registTransferAcct(:accountId,:bankAcName,:bankAcc,:bankName,:bankId,:bankOrgNo,:branch,:city,:hintName,:ipAddress,:via,:validationtype,:devicetype,:device,:err_code,:err_msg); END;', 'Y', 'reg', 'Ðang ký ngu?i th? hu?ng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getTemplates', 'BEGIN fopks_inquiryApi.pr_getTemplates(:ret,:accountId,:type,:err_code,:err_msg); END;', 'Y', 'report', 'Danh sách tt dang ký nh?n b?n tin sms/email');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_RemoveTransferAcct', 'BEGIN fopks_ultilityApi.pr_RemoveTransferAcct(:accountId,:bankAcc,:err_code,:err_msg); END;', 'Y', 'remove', 'Xóa danh sách tài kho?n th? hu?ng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_editTemplate', 'BEGIN fopks_ultilityApi.pr_editTemplate(:accountId,:code,:type,:err_code,:err_msg); END;', 'Y', 'reg', 'Ðang ký/H?y dang ký nh?n b?n tin sms/email');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_cancelSellOddLot', 'BEGIN fopks_ultilityApi.pr_cancelSellOddLot(:accountId,:symbol,:txnum,:txdate,:err_code,:err_msg); END;', 'Y', 'reg', 'H?y dang ký lô l?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_editCustInfo', 'BEGIN fopks_ultilityApi.pr_editCustInfo(:custid,:address,:err_code,:err_msg); END;', 'Y', 'repot', 'C?p nh?t d?a ch? liên h? BKSV');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_ultilityApi.pr_changeTelePin', 'BEGIN fopks_ultilityApi.pr_changeTelePin(:custid,:newpin,:err_code,:err_msg); END;', 'Y', 'repot', 'Thay d?i mã pin tele');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_authapi.pr_getSerialNum', 'BEGIN fopks_authapi.pr_getSerialNum(:custid,:serialNum,:err_code,:err_msg); END;', 'Y', 'report', 'Ki?m tra serial number');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_resetpassonline', 'BEGIN fopks_api.pr_resetpassonline(:userName,:idCode,:mobile,:email,:err_code,:err_msg); END;', 'Y', 'resset', 'Reset m?t kh?u');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_get_loan_policy', 'BEGIN fopks_inquiryApi.pr_get_loan_policy(:ret,:err_code,:err_msg); END;', 'Y', 'report', 'Danh sách chính sách cho vay c?a KB');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('pr_insertlogplaceorder', 'BEGIN pr_insertlogplaceorder(:requestId,:orderId,:via,:ipAddress,:validationType,:deviceType,:device); END;', 'Y', 'report', 'Ghi log d?t l?nh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.pr_get_customer_info', 'BEGIN fopks_openapi.pr_get_customer_info(:ret,:custid,:err_code,:err_msg); END;', 'Y', 'report', 'Thông tin tài kho?n');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_openapi.fn_check_system_active', 'select fopks_openapi.fn_check_system_active from dual', 'Y', 'report', 'Trạng thái DB');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_api.pr_updatepasspinonline', 'BEGIN fopks_api.pr_updatepasspinonline(:username,:password,:pin,:err_code,:err_msg,:via); END;', 'Y', 'account', 'Đổi mật khẩu và pin đồng thời');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_authapi.pr_checkPassword', 'BEGIN fopks_authapi.pr_checkPassword(:username,:password,:err_code,:err_msg); END;', 'Y', 'auth', 'Kiem tra mat khau');
--  FDS API
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_PROCESSDT02', 'BEGIN fds_broker_api.PR_PROCESSDT02(:tlId,:custodycd,:accountId,:amount,:iorofee,:desc,:err_code,:err_msg,:ipaddress,:via,:validationType,:deviceType,:device); END;', 'Y', 'reg', 'N?p ti?n tài kho?n ký qu?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.fds_OrderHistory', 'BEGIN fds_broker_api.fds_OrderHistory(:ret,:accountId,:fromDate,:toDate,:orderType,:symbol,:status); END;', 'Y', 'reg', 'L?ch s? d?t l?nh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETDT02', 'BEGIN fds_broker_api.PR_GETDT02(:ret,:username,:fromDate,:toDate,:status); END;', 'Y', 'reg', 'L?ch s? n?p ti?n vào tài kho?n ký qu?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETDT01', 'BEGIN fds_broker_api.PR_GETDT01(:ret,:username,:fromDate,:toDate,:status); END;', 'Y', 'reg', 'L?ch s? n?p ti?n vào tài kho?n giao d?ch phái sinh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETDT13', 'BEGIN fds_broker_api.PR_GETDT13(:ret,:username,:fromDate,:toDate,:status); END;', 'Y', 'reg', 'L?ch s? rút ti?n t? tài kho?n giao d?ch phái sinh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETDT07', 'BEGIN fds_broker_api.PR_GETDT07(:ret,:username,:fromDate,:toDate,:status); END;', 'Y', 'reg', 'Rút ti?n ký qu?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.fds_HistoryVIMCash', 'BEGIN fds_broker_api.fds_HistoryVIMCash(:ret,:custodycd,:accountId,:fromDate,:toDate); END;', 'Y', 'report', 'L?ch s? giao d?ch tài kho?n ký qu?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getCashOnHandHist', 'BEGIN fopks_reportapi.pr_getCashOnHandHist(:ret,:accountId,:fromDate,:toDate); END;', 'Y', 'report', 'L?ch s? giao d?ch ti?n tài kho?n công ty');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_PROCESSDT07', 'BEGIN fds_broker_api.PR_PROCESSDT07(:tlId,:custodycd,:accountId,:amount,:iorofee,:desc,:err_code,:err_msg,:ipaddress,:via,:validationType,:deviceType,:device); END;', 'Y', 'reg', 'Rút ti?n t? tài kho?n ký qu?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.fds_FDSCollateralsdtlHistory', 'BEGIN fds_broker_api.fds_FDSCollateralsdtlHistory(:ret,:accountId,:fromDate,:toDate,:symbol); END;', 'Y', 'report', 'L?ch s? giao d?ch tài kho?n d?m b?o');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getStamentDebt', 'BEGIN fds_broker_api.pr_getStamentDebt(:ret,:dmAccount,:accountId,:fromDate,:toDate); END;', 'Y', 'report', 'Sao kê gi?i ngân và thu n? th?u chi');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETSTAMENTPOSITIONS', 'BEGIN fds_broker_api.PR_GETSTAMENTPOSITIONS(:ret,:fromDate,:toDate,:dmAccount,:accountId,:uaCode,:symbol,:tltxCd); END;', 'Y', 'report', 'Sao kê v? th?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETCALPOSITIONFEE', 'BEGIN fds_broker_api.PR_GETCALPOSITIONFEE(:ret,:fromDate,:toDate,:dmAccount,:accountId); END;', 'Y', 'report', 'B?ng kê phí v? th?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getBalanceAmount', 'BEGIN fds_broker_api.pr_getBalanceAmount(:ret,:accountId); END;', 'Y', 'report', 'Thông tin s? du tài kho?n');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FDS_GET_MARGINLIST', 'SELECT bk.symbol,bk.haircut,bk.price_max, LEAST(bk.price_max, price_asset) price_asset, sb.price_rf from dtmast dt, fdsbaskets bk, instruments sb where dt.pbassetsid = bk.basketid AND bk.symbol = sb.symbol and (dt.acctno =:accountid)', 'Y', 'report', 'Thông tin danh sách ch?ng khoán du?c ký qu?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FN_GETDTMAST_AVLCASHWITHDRAW', 'select fds_broker_api.FN_GETDTMAST_AVLCASHWITHDRAW(:pv_dtaacctno) AVLCASHWITHDRAW from dual', 'Y', 'error', 'L?y s? ti?n t?i da du?c rút - n?p ti?n vào tài kho?n kí qu?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FN_GETINSTRUMENT', 'SELECT fi.symbol, fi.delisteddt FROM fdsinstruments fi WHERE halt <> ''W'' AND (uacode = :uaCode)', 'Y', 'report', 'Thông tin mã h?p d?ng - Các m?u h?p d?ng hi?n t?i');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_PROCESSDT17', 'BEGIN fds_broker_api.PR_PROCESSDT17(:tlId,:accountId,:desc,:err_code,:err_msg,:ipaddress,:via,:validationType,:deviceType,:device); END;', 'Y', 'report', 'T?t toán n? th?u chi - Submit');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_GETDT17', 'BEGIN fds_broker_api.PR_GETDT17(:ret,:username,:fromDate,:toDate,:status); END;', 'Y', 'report', 'T?t toán n? th?u chi - Submit');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getPROCESSDT17', 'BEGIN fds_broker_api.pr_getPROCESSDT17(:ret,:accountId); END;', 'Y', 'report', ' T?t toán n? th?u chi - Thông tin ti?n, n?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getSpecificationInfo', 'BEGIN fopks_inquiryApi.pr_getSpecificationInfo(:ret,:uaCode,:err_code,:err_msg); END;', 'Y', 'report', 'Thông tin mã h?p d?ng - Thông tin h?p d?ng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getOpenPositionsInfo', 'BEGIN fds_broker_api.pr_getOpenPositionsInfo(:ret,:dmaacctno,:dtaacctno,:instrument); END;', 'Y', 'report', 'Thông tin v? th? m?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getClosePositionsInfo', 'BEGIN fds_broker_api.pr_getClosePositionsInfo(:ret,:dmaacctno,:dtaacctno,:instrument); END;', 'Y', 'report', 'Thông tin v? th? dóng');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.fds_getwaittomatchorder', 'BEGIN fds_broker_api.fds_getwaittomatchorder(:ret,:dmaacctno,:dtaacctno,:orderside,:instrument); END;', 'Y', 'report', 'Thông tin l?nh ch? kh?p');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_engine_api.sp_get_order_tx6105', 'BEGIN fds_engine_api.sp_get_order_tx6105(:ret,:userId,:placeCustid,:afacctno,:execType,:symbol,:status,:fromDate,:toDate,:classcd,:searchTime,:seqNum); END;', 'Y', 'report', 'Thông tin l?nh di?u ki?n');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_getSecuritiesInfo', 'BEGIN fds_broker_api.pr_getSecuritiesInfo(:ret,:accountId); END;', 'Y', 'report', 'Ch?ng khoán ký qu?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_PROCESSDT13', 'BEGIN fds_broker_api.PR_PROCESSDT13(:tlId,:custodycd,:accountId,:amount,:desc,:err_code,:err_msg,:ipaddress,:via,:validationType,:deviceType,:device,:json_msg); END;', 'Y', 'report', 'Rút ti?n t? tài kho?n giao d?ch phái sinh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.PR_PROCESSDT01', 'BEGIN fds_broker_api.PR_PROCESSDT01(:tlId,:custodycd,:accountId,:amount,:desc,:err_code,:err_msg,:ipaddress,:via,:validationType,:deviceType,:device,:json_msg); END;', 'Y', 'report', 'N?p ti?n vào tài kho?n giao d?ch phái sinh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FDS_CSPKS_SYSTEM.FN_GETFEE3611', 'select FDS_CSPKS_SYSTEM.FN_GETFEE3611(:pv_Value,:pv_feecode,:pv_iofee) FEE from dual', 'Y', 'report', 'L?y ki?u phí');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.fds_getcustomersummary', 'BEGIN fds_broker_api.fds_getcustomersummary(:ret,:dmacctno,:dtaacctno); END;', 'Y', 'report', 'L?y ti?n rút t?i da');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getOrderFeeAndTax', 'BEGIN  fopks_reportapi.pr_getOrderFeeAndTax(:ret,:accountId,:fromDate,:toDate,:err_code,:err_msg); END;', 'Y', 'report', 'B?ng kê tính phí giao d?ch');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getOrderMatch', 'BEGIN fopks_inquiryApi.pr_getOrderMatch(:ret,:accountId,:err_code,:err_msg); END;', 'Y', 'report', 'Thông tin l?nh kh?p trong ngày');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryApi.pr_getActiveOrder_fds', 'BEGIN fopks_inquiryApi.pr_getActiveOrder(:ret,:accountId,:err_code,:err_msg); END;', 'Y', 'report', 'Thông tin l?nh d?t trong ngày');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryapi.pr_getsummaryaccount_fds', 'BEGIN fopks_inquiryapi.pr_getsummaryaccount(:ret,:accountId,:err_code,:err_msg); END;', 'Y', 'report', 'T?ng h?p tài kho?n');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_inquiryapi.pr_getcalcdepositamt2buy', 'BEGIN fopks_inquiryapi.pr_getcalcdepositamt2buy(:ret,:accountId,:symbol,:type,:err_code,:err_msg); END;', 'Y', 'report', 'Thông tin l?nh d?t trong ngày');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getordermatch_fds', 'BEGIN fopks_reportapi.pr_getordermatch(:ret,:accountId,:fromDate,:toDate,:symbol,:side); END;', 'Y', 'report', 'L?ch s? kh?p l?nh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fopks_reportapi.pr_getpnlexecuted_fds', 'BEGIN fopks_reportapi.pr_getpnlexecuted(:ret,:accountId,:fromDate,:toDate,:symbol); END;', 'Y', 'report', 'Lãi l? trong ngày');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FN_GET_BASE_SECURITIES', 'SELECT VALUECD FROM ( SELECT UACODE VALUECD, UACODE VALUE, UACODE DISPLAY, UACODE EN_DISPLAY, UACODE DESCRIPTION FROM FDSSPECIFICATIONS UNION ALL SELECT ''ALL'', ''ALL'', ''ALL'', ''ALL'', ''ALL'' FROM DUAL ) ORDER BY DISPLAY', 'Y', 'report', 'L?y ch?ng khoán co s?');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FN_GET_FDS_SECURITIES', 'SELECT VALUECD FROM ( SELECT SYMBOL VALUECD, SYMBOL VALUE, SYMBOL DISPLAY, SYMBOL EN_DISPLAY,SYMBOL DESCRIPTION FROM FDSINSTRUMENTS UNION ALL SELECT ''ALL'', ''ALL'', ''ALL'', ''ALL'', ''ALL'' FROM DUAL ) ORDER BY DISPLAY', 'Y', 'report', 'L?y ch?ng khoán phái sinh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('FN_GET_TRANSACTION_CODE', 'SELECT DISPLAY, EN_DISPLAY  FROM ( SELECT TLTXCD VALUECD, TLTXCD VALUE, TXDESC DISPLAY, EN_TXDESC EN_DISPLAY, EN_TXDESC DESCRIPTION FROM TLTX WHERE TLTXCD LIKE ''D%'' AND TLTXCD NOT LIKE ''DF%''  UNION ALL SELECT ''ALL'', ''ALL'', ''ALL'', ''ALL'', ''ALL'' FROM DUAL  ) ORDER BY DISPLAY', 'Y', 'report', 'Mã giao d?ch');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_cspks_dtproc.pr_getppse', 'BEGIN fds_cspks_dtproc.pr_getppse(:ret,:accountId,:symbol,:quoteprice,:via); END;', 'Y', 'report', 'S? lu?ng mua bán t?i da');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_ConfirmOrder', 'BEGIN fds_broker_api.pr_ConfirmOrder(:orderId,:custid,:via,:ipAddress,:validationType,:deviceType,:device,:err_code,:err_msg,:tlid); END;', 'Y', 'trans', 'Xác nh?n l?nh');
insert into focmdcode (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC)
values ('fds_broker_api.pr_GetConfirmOrderHist', 'BEGIN fds_broker_api.pr_GetConfirmOrderHist(:ret,:custodycd,:accountId,:fromDate,:toDate,:execType,:pagerpp,:rowsrpp); END;', 'Y', 'report', 'Danh sách l?nh chua xác nh?n l?nh');
commit;
/
