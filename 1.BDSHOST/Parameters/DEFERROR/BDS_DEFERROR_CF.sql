--
--
/
DELETE DEFERROR WHERE MODCODE = 'CF';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100094,'[-100094]: Nhom nay dang quan ly khach hang!','[-100094]: This group is caring customers!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100095,'[-100095]: Gửi SMS không thành công!','[-100095]: Deliver SMS fail!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100159,'[-100159]: TK chua dang ký giao d?ch qua Tele!','[-100159]: ERR_CF_OVER_MARGINLIMIT!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100412,'[-100412]: Không thể thay đổi ngân hàng , hợp đồng vẫn còn số dư!','[-100412]: Cannot change bank name','CF',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100601,'[-100601] User ko duoc cap han muc margin','[-100601] ERR_SA_USER_HAVE_NO_MARGIN_LIMIT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100602,'[-100602]: Cấp vượt quá hạn mức Margin còn lại của User !','[-100602] ERR_SA_ALLOCATE_EXCEED_AVAILABLE_USER_LIMIT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100603,'[-100603]: Vuot qua han muc user co the cap cho 1 hop dong','[-100603]: ERR_SA_ALLOCATE_EXCEED_AVAILABLE_USER_LIMIT_TO_AF!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100604,'[-100604]: Khong the thu hoi khi chua cap','[-100604]: ERR_SA_CAN_NOT_RETRIEVE_WHEN_NOT_ALLOCATED','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100606,'[-100606]: Tiểu khoản không hoạt động !','[-100606]: ERR_SA_ACCTNO_NOT_ACTIVE','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100607,'[-100607]: Cấp vượt quá hạn mức của khách hàng !','[-100607]: ERR_SA_ALLOCATE_EXCEED_CF_MRLOANLIMIT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100608,'[-100608]: Hop dong khong margin','[-100608]: ERR_SA_ACCTNO_NOT_IN_MARGIN_TYPE','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100610,'[-100610]: Hạn mức vay của tiểu khoản không được phép vượt quá Pool cho phép theo UBCK!','[-100610]: Credit limit can not exceed Pool limit of SSC','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100611,'[-100611]:Giao dịch hiện chỉ thay đổi hạn mức vay mà không thay đổi tham số check pool của tiểu khoản!','[-100611]: The new checkpool type must be difference from the old one!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100612,'[-100612]: Dư nợ của tiểu khoản vượt quá nguồn còn lại của hệ thống!','[-100612]: Of sub-account debit balance exceeds the remaining resources of the system!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100613,'[-100613]: Dư nợ của tiểu khoản vượt quá hạn mức pool riêng của tiểu khoản!','[-100613]: Of sub-account debit balance exceeds the limit of the sub-account Private pool!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-180045,'[-180045]: Không được chuyển loại tiểu khoản Normal/Creditline/Margin loan!','[-180045]: Can not change Normal/Creditline/Margin loan!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200001,'[-200001]: Mã loại hình hợp đồng bị trùng!','[-200001]: Duplicate contract ID!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200002,'[-200002]: Thông tin khách hàng không tồn tại!','[-200002]: Customer info is not existed','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200003,'[-200003]: ERR_CF_AFTYPE_NOTFOUND','[-200003]: ERR_CF_AFTYPE_NOTFOUND!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200004,'[-200004]: Đang tồn tại tiểu khoản','[-200004]: ERR_CF_AFMAST_ALREADY_EXIST','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200005,'[-200005]: ERR_CF_AFMAST_OVER_TRADELIMIT','[-200005]: ERR_CF_AFMAST_OVER_TRADELIMIT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200006,'[-200006]: ERR_CF_AFMAST_OVER_MARGINLIMIT','[-200006]: ERR_CF_AFMAST_OVER_MARGINLIMIT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200007,'[-200007]: ERR_CF_AFMAST_OVER_ADVANCELIMIT','[-200007]: ERR_CF_AFMAST_OVER_ADVANCELIMIT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200008,'[-200008]: ERR_CF_AFMAST_OVER_REPOLIMIT','[-200008]: ERR_CF_AFMAST_OVER_REPOLIMIT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200009,'[-200009]: ERR_CF_AFMAST_OVER_DEPOSITLIMIT','[-200009]: ERR_CF_AFMAST_OVER_DEPOSITLIMIT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200010,'[-200010]: Trạng thái tiểu khoản không đúng!','[-200010]: ERR_CF_AFMAST_STATUS_INVALID','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200011,'[-200011]: ERR_CF_ACTYPE_HAS_CONTRACT','[-200011]: ERR_CF_ACTYPE_HAS_CONTRACT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200012,'[-200012]: Số tiểu khoản không tồn tại','[-200012]: Account no not exist','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200014,'[-200014]: ERR_CF_CONTRACT_HAS_TRANSACTION','[-200014]: ERR_CF_CONTRACT_HAS_TRANSACTION','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200015,'[-200015]: ERR_CF_ACTYPE_HAS_CONSTRAINTS','[-200015]: ERR_CF_ACTYPE_HAS_CONSTRAINTS','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200016,'[-200016]: ERR_CF_AFMAST_RISKOVER_AFTYPE','[-200016]: ERR_CF_AFMAST_RISKOVER_AFTYPE','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200017,'[-200017]: ERR_CF_CAREBY_NOT_EXIT','[-200017]: ERR_CF_CAREBY_NOT_EXIT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200018,'[-200018]: Tồn tại thông tin liên lạc - không thể xóa','[-200018]: ERR_CF_CUSTID_CONSTRAINTS','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200019,'[-200019]: Trùng số lưu ký','[-200019]: Custoycode is duplicated','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200020,'[-200020]: Số CMTND/CCCD/Hộ chiếu đã tồn tại','[-200020]: Idcode is duplicate','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200021,'[-200021]: ERR_CF_SE_NOT_EXIT','[-200021]: ERR_CF_SE_NOT_EXIT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200022,'[-200022]: ERR_CF_CI_NOT_EXIT','[-200022]: ERR_CF_CI_NOT_EXIT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200023,'[-200023]: Mã khách hàng không tồn tại!','[-200023]:Customer ID is not exists!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200024,'[-200024]: Mã khách hàng không tồn tại!','[-200024]:Customer ID is not exists!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200025,'[-200025]: ERR_CF_AFMAST_TRADERATE_OVER_AFTYPE!','[-200025]: ERR_CF_AFMAST_TRADERATE_OVER_AFTYPE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200026,'[-200026]: ERR_CF_AFMAST_DEPORATE_OVER_AFTYPE!','[-200026]: ERR_CF_AFMAST_DEPORATE_OVER_AFTYPE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200027,'[-200027]: ERR_CF_AFMAST_MISCRATE_OVER_AFTYPE!','[-200027]: ERR_CF_AFMAST_MISCRATE_OVER_AFTYPE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200028,'[-200028]: ERR_CF_OVER_MARGINLIMIT!','[-200028]: ERR_CF_OVER_MARGINLIMIT!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200029,'[-200029]: ERR_CF_OVER_TRADELIMIT!','[-200029]: ERR_CF_OVER_TRADELIMIT!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200030,'[-200030]: ERR_CF_OVER_ADVANCELINE!','[-200030]: ERR_CF_OVER_ADVANCELINE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200031,'[-200031]: ERR_CF_OVER_REPOLINE!','[-200031]: ERR_CF_OVER_REPOLINE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200032,'[-200032]: ERR_CF_OVER_DEPOSITLINE!','[-200032]: ERR_CF_OVER_DEPOSITLINE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200033,'[-200033]: ERR_CF_CANNOT_CLOSE!','[-200033]: ERR_CF_CANNOT_CLOSE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200034,'[-200034]: ERR_CF_RECUSTID_NOTFOUND!','[-200034]: ERR_CF_RECUSTID_NOTFOUND!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200035,'-200035]: Mã khách hàng đã tồn tại','[-200035]: ERR_CF_CUSTID_DUPLICATED!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200036,'-200036]: Mã khách hàng không đúng','[-200036]: ERR_CF_CUSTID_INVALID!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200037,'[-200037]: ERR_CF_INTERNATION_NOTEMPTY!','[-200037]: ERR_CF_INTERNATION_NOTEMPTY!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200038,'[-200038]: ERR_CF_TRADEPHONE_ISNOTEMPTY!','[-200038]: ERR_CF_TRADEPHONE_ISNOTEMPTY!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200039,'[-200039]: ERR_CF_CURRDATE_SMALLER_THAN_BIRTHDATE!','[-200039]: ERR_CF_CURRDATE_SMALLER_THAN_BIRTHDATE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200040,'[-200040]: Ngày hết hạn nhỏ hơn ngày hiện tại là không hợp lệ !','[-200040]: ERR_CF_IDEXPIRED_SMALLER_THAN_CURRDATE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200041,'[-200041]: ERR_CF_OVER_TRADELINE!','[-200041]: ERR_CF_OVER_TRADELINE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200042,'Phải nhập mã số thuế','[-200042]: ERR_CF_TAXCODE_ISNOT_NULL!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200043,'[-200043]: Ngày bắt đầu hiệu lực không được lớn hơn ngày hết hiệu lực !','[-200043]: ERR_CF_CURRDATE_SMALLER_THAN_VALDATE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200044,'[-200044]:Ngày hết hiệu lực không được nhỏ hơn ngày hiện tại !','[-200044]: ERR_CF_CURRDATE_SMALLER_THAN_VALDATE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200045,'[-200045]: Trạng thái khách hàng không hợp lệ hoặc Không phải là Ngân hàng !','[-200045]: ERR_INVALIF_CFMAST_STATUS!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200046,'[-200046]: ERR_CF_PIN_ISNOT_NULL!','[-200046]: ERR_CF_PIN_ISNOT_NULL!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200047,'[-200047] INVALID OTC STAUS','[-200047] INVALID OTC STAUS','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200048,'[-200048] Mã tiểu khoản đã có người sử dụng','[-200048] ERR_CF_ACCTNO_DUPLICATE','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200050,'[-200050]: Ban khong quan ly khach hang nay!','[-200050]: You do not care this customer!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200051,'[-200051]:Mã báo cáo , chu kỳ bị trùng !','[-200051]: Report ID or Cycle is duplicated!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200052,'[-200052]: Mã báo cáo không tồn tại!','[-200052]: Report ID not found!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200053,'[-200053]: ERR_CF_PIN_DIFFRENCE','[-200053]: ERR_CF_PIN_DIFFRENCE','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200054,'[-200054]: ERR_CF_REGTYPE_DUPLICATE!','[-200054]:ERR_CF_REGTYPE_DUPLICATE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200055,'[-200055]: ERR_CF_CANNOT_ACTIVE','[-200055]: ERR_CF_CANNOT_ACTIVE','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200056,'[-200056]: Khách hàng không phải là ngân hàng!','[-200056]: Customer is not bank!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200058,'[-200058]: Trùng quan hệ','[-200058]: ERR_CF_RELATION_DUPLICATE','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200060,'[-200060]: ERR_CF_EXAFMAST_DUPLICATED','[-200060]: ERR_CF_EXAFMAST_DUPLICATED','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200061,'[-200061]: ERR_CF_EXAFSCHD_DUPLICATED','[-200061]: ERR_CF_EXAFSCHD_DUPLICATED','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200062,'[-200062]: ERR_CF_EVENTCODE_INVALID','[-200062]: ERR_CF_EVENTCODE_INVALID','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200064,'[-200064]: Vẫn còn số dư chứng khoán chờ lưu ký nên không thể đóng tiểu khoản !','[-200064]: ERR_CF_SENDDEPOSIT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200065,'[-200065]: ERR_CI_AFTYPE_IS_NOT_CORRCECT','[-200065]: ERR_CI_AFTYPE_IS_NOT_CORRCECT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200066,'Bi trung username','Username duplicate','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200072,'[-200072]: ERR_CF_USER_LIMIT_GREATER_ZERO!','[-200072]: ERR_CF_USER_LIMIT_GREATER_ZERO!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200073,'[-200073]: ERR_CF_USER_LIMIT_GREATER_USEDLIMIT','[-200073]: ERR_CF_USER_LIMIT_GREATER_USEDLIMIT!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200074,'[-200074]: ERR_CF_USER_NOT_ACTIVE!','[-200074]: ERR_CF_USER_NOT_ACTIVE!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200075,'[-200075]: ERR_CF_ACCOUNT_LIMIT_GREATER_USEDLIMIT!','[-200075]: ERR_CF_ACCOUNT_LIMIT_GREATER_USEDLIMIT!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200076,'[-200076]: ERR_CF_ACCOUNT_LIMIT_SMALLER_THAN_ZERO!','[-200076]: ERR_CF_ACCOUNT_LIMIT_SMALLER_THAN_ZERO!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200077,'[-200077]: ERR_CF_USER_BD_ALREADY_ALLOCATE_LIMIT!','[-200077]: ERR_CF_USER_BD_ALREADY_ALLOCATE_LIMIT!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200078,'[-200078]: ERR_CF_USER_BO_ALREADY_ALLOCATE_LIMIT!','[-200078]: ERR_CF_USER_BO_ALREADY_ALLOCATE_LIMIT!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200079,'[-200079]: ERR_CF_T0_USER_LIMIT_GREATER_ZERO','[-200079]: ERR_CF_T0_USER_LIMIT_GREATER_ZERO','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200080,'[-200080]: ERR_CF_T0_MAX_SMALLER_THAN_ZERO!','[-200080]: ERR_CF_T0_MAX_SMALLER_THAN_ZERO!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200081,'[-200081]: Khách hàng vẫn còn chữ ký nên không thể xóa !','[-200081]: ERR_CF_CANNOT_DELETE_SIGN!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200082,'[-200082]: Số tiểu khoản phải là số !','[-200082]: ERR_AF_ACCTNO_ISNUMBERIC !','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200083,'[-200083]: Mã chi nhánh trong số tiểu khoản không đúng !','[-200083]: ERR_AF_ACCTNO_NOTBELONGBRANCH !','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200084,'[-200084]: Tài khoản mua lô lẻ phải là tài khoản tự doanh !','[-200084]: ODD LOT TRADING ACCOUNT MUST BE DEALING ACCOUNT','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200085,'[-200085]: User được gán đã hết hiệu lực!','[-200085]: ERR_TL_NOT_ACTIVE !','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200086,'[-200086]: User được gán không có quyền Careby khách hàng này !','[-200086]: ERR_NOT_CARE_BY !','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200087,'[-200087]: Tài khoản này đang hoạt động nên không thể xóa được !','[-200087]: Account is active!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200088,'[-200088]: Mã người giới thiệu (Tab [Phân loại KH]) không hợp lệ hoặc trùng với người được giới thiệu !','[-200088]: Reference code (Tab customer classify) invalid or duplicate!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200089,'[-200089]: Số mobile đăng kí nhận SMS chưa được khai báo trên thông tin hợp đồng!','[-200089]: SMS mobile number not declared on contract! ','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200090,'[-200090]: Khách hàng phải đủ 18 tuổi !','[-200090]: The customer must be 18 years old','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200091,'[-200091]:User không tồn tại hoặc user ở trạng thái chưa áp dụng !','[-200091]: User not exist or not active!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200097,'[-200097]: Loại hình thay đổi mới chưa khai báo các loại hình LN, SE, CI.','[-200097]: The new AFTYPE not yet declare LN, SE, CI type','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200098,'[-200098]: Tại một thời điểm chỉ một chữ ký được hoạt động!','[-200098]: Only 1 active signature at once time! ','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200099,'[-200099]: Tiểu khoản không được đăng ký giao dịch trực tuyến','[-200099]: Online trading not registered! ','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200102,'[-200102]: Tiểu khoản chưa được phân quyền giao dịch trực tuyến','[-200102]: Account not allowed online trading','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200103,'[-200103]: Người dùng này đã được thiết lập master','[-200103]: Master set up for User already!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200104,'[-200104]: Trạng thái khách hàng không hợp lệ','[-200104]: Customer status invalid','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200105,'[-200105]: Trạng thái master của người dùng không thay đổi','[-200105]: Do not change User master status','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200106,'[-200106]: Mã chi nhánh mới trùng mã chi nhánh cũ!','[-200106]: New branch code branch code coincides old!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200193,'[-200193]: Khách hàng này không được phép tạo tiểu khoản Margin!','[-200193]:Can not create Margin sub account for this customer!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200194,'[-200194]: Đã có tiểu khoản margin trên hệ thống, không cho phép tạo tiểu khoản thứ 2!','[-200194]:This customer already had Margin account!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200195,'[-200195]: Khách hàng chưa có tiểu khoản thường!','[-200195]:This customer have not got normal account yet!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200196,'[-200196]: Không được chuyển sang loại hình tiểu khoản khác!','[-200196]:Can not change to orther account type!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200197,'[-200197]: Điều kiện loại hình tiểu khoản GDKQ không đúng!','[-200197]:The Margin type is not correct!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200198,'[-200198]: Hệ thống hiện tại không cho phép tại mới TK Margin!','[-200198]:System not allow to create Margin account!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200199,'[-200199]: Hệ thống hiện tại không cho phép gia hạn HĐ Margin!','[-200199]:System not allow to extend Margin deal!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200200,'[-200200]: ERR_AFMAST_MRCRLIMIT_NOT_ENOUGH','[-200200]: ERR_AFMAST_MRCRLIMIT_NOT_ENOUGH','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200204,'[-200204]: Không được cập nhật Loại hình Margin(Credit line) tương ứng với Mã loại hình.','[-200204]: AFTYPE not approved','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200205,'[-200205]: Hết hạn giấy tờ (CMND) trên thông tin khách hàng!','[-200205]: ID code expried! ','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200206,'[-200206]: Giao dịch yêu cầu nhiều hơn một chử ký của chủ tài khoản!','[-200206]: Transaction requests more than 1 signature of account owner! ','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200207,'[-200207]: CMT/HC/GPKD của Khách hàng yêu cầu giao dịch đã hết hạn!','[-200207]: ID code/ Passport/ Business certificate of customer is expired! ','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200210,'Khách hàng vẫn đang có tiểu khoản sử dụng','Already has inused sub-account','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200211,'[-200211]: Tiểu khoản chỉ được cấp bởi user thuộc nhóm careby của tiểu khoản này!','[-200211]: User must belong to Careby group of this account','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200255,'[-200255]: Số LK chuyển cùng số LK nhận!','[-200255]: Số LK chuyển cùng số LK nhận!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200300,'[-200300]: Nơi lưu ký không hợp lệ','[-200300]: Invalid custodian bank','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200301,'[-200301]: Tiểu khoản đang tồn tại dư nợ, không được phép chuyển đổi từ loại hình margin sang không margin hay ngược lại!','[-200301]: Can not change AF type while remain outstanding! ','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200302,'[-200302]: Ngân hàng chưa được cấp hạn mức vay tối đa!','[-200302]: Bank not allocated max limit!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200303,'[-200303]: Hạn mức tín dụng nguồn ngân hàng chưa khai báo cho loại hình nghiệp vụ!','[-200303]: Credit limit of bank not declared on product type!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200304,'[-200304] Tiểu khoản này đã được đăng ký!','[-200304] Sub account has been registered already!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200305,'[-200305]: Loại hình giao dịch ký quỹ bắt buộc khai báo tự động ứng trước!','[-200305]: MR type require Auto AD!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200306,'[-200306]: Loại khách hàng bị chặn không được thực hiện giao dịch này!','[-200306]: Limited customer for this transaction!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200307,'[-200307]: Tồn tại mối quan hệ - không thể xóa','[-200307]: ERR_CF_RELATION_CREATED','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200308,'[-200308]: Tồn tại tổ chức phát hành - không thể xóa','[-200308]: ERR_CF_CUSTID_ISSUER','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200309,'[-200309] Cần đăng ký hình thức xác thực cho kênh giao dịch All trước!','[-200309] Cần đăng ký hình thức xác thực cho kênh giao dịch All trước!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200310,'[-200310] Chứng thư số chỉ đăng ký cho kênh Online và Home!','[-200310] Chứng thư số chỉ đăng ký cho kênh Online và Home!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200311,'[-200311] Token là bắt buộc nhập!','[-200311] Token là bắt buộc nhập!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200312,'[-200312] Phải xóa các kênh Online/Home/Priceboard trước!','[-200312] Phải xóa kênh Online/Home/Priceboard trước!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200313,'[-200313] Hình thức xác thực không trùng khớp với các tiểu khoản khác!','[-200313] Hình thức xác thực không trùng khớp với các tiểu khoản khác!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200314,'[-200314] Kênh giao dịch trên chưa được khai báo trên tài khoản được ủy quyền','[-200314] Kênh giao dịch trên chưa được khai báo trên tài khoản được ủy quyền','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200315,'[-200315] Thông tin Serial Token không khớp với các kênh còn lại','[-200315] Thông tin Serial Token không khớp với các kênh còn lại','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200316,'[-200316] Thông tin Serial Token đã tồn tại của khách hàng khác.','[-200316] Thông tin Serial Token đã tồn tại của khách hàng khác.','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200333,'[-200333]: Tiểu khoản còn nợ bảo lãnh chưa thanh toán, không được tự động cấp bảo lãnh!','[-200333]: Can not auto allocate Underwrite while T0 outstanding remain!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200334,'[-200334]: Bạn đang thực hiện UTTB cho tài khoản kết nối ngân hàng!','[-200334]: You are executing AD for corebank account!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200400,'[-200400]: Khách hàng này chưa được cấp tài khoản giao dịch trực tuyến!','[-200400]: Online trading account not exist! ','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200500,'[-200500]: Mã email này đã tồn tại trên hệ thống!','[-200500]: This e-mail code already exists on the system!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200501,'[-200501]: Không được sửa thông tin Email!','[-200501]: Do not edit Email information!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200520,'[-200520]:Mã pin phải từ 6 ký tự trở lên, chỉ bao gồm số','[-200520]:Mã pin phải từ 6 ký tự trở lên, chỉ bao gồm số','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260158,'[-260158]: Tài khoản vẫn còn lệnh chưa khớp hết !','[-260158]: Unmatched order still exist!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260159,'[-260159]: Tài khoản vẫn còn chứng khoán phong tỏa !','[-260159]: Blocked stocks still exist!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260160,'[-260160]: Tài khoản vẫn còn chứng khoán phong tỏa trong các deal DF !','[-260160]: Blocked stocks of Deals still exist!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260161,'[-260161]: Số lưu ký vẫn còn tiểu khoản hoạt động hoặc chờ duyệt !','[-260161]:  Active account still exist!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260162,'[-260162]: Chứng khoán cần phải chuyển về một số tiểu khoản trước khi làm giao dịch !','[-260162]:  SE must be transfer to accounts before transaction','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260163,'[-260163]: Cần nhập mã TVLK và số lưu ký  người nhận để chuyển chứng khoán trước khi đóng !','[-260163]:  Deposit member code and name of receiver required before closing!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260164,'[-260164]: Tiểu khoản còn lệnh repo chưa đặt lệnh lần 2 !','[-260164]:  Sub account still remains Repo order not yet placed second time!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260165,'[-260165]: Đã tồn tại khách hàng sử dụng sđt này trên hệ thống !','[-260165]:  Mobile is in used','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260166,'[-260166]: Trạng thái yêu cầu giới thiệu không hợp lệ !','[-260166]:  Status invalid','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260168,'[-260168]: Giao dịch không thực hiện được vì đã thực hiện thay đổi!','[-260168]: Transaction fails for making changes!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260169,'[-260169]: Tài khoản đã được gán môi giới!','[-260169]: Account has been assigned Brokers!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260170,'[-260170]: Tiểu khoản đang được gán ngân hàng!','[-260170]: Account are assigned bank account!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260171,'[-260171]: Tiểu khoản đang được gán ủy quyền!','[-260171]: Account are assigned authorization!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260172,'[-260172]: Tiểu khoản đang được gán giao dịch chặn!','[-260172]: Account transactions are assigned to block!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260173,'[-260173]: Tiểu khoản đang được gán chính sách mua bán!','[-260173]: Accounts are assigned purchasing policy!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260174,'[-260174]: Tiểu khoản đang đăng ký trực tuyến!','[-260174]: Accounts are being registered online!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260175,'[-260175]: Tiểu khoản đang đăng ký mẫu SMS/Email!','[-260175]: Accounts are being registered SMS/Email!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260176,'[-260176]: Tài khoản đang đang đăng ký hạn mức ngân hàng!','[-260176]: Accounts are being registered bank limits!','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260177,'[-260177]: Yêu cầu kích hoạt tài khoản đã gửi lên VSD!','[-260177]: Open account request sent to VSD!','CF',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700047,'[-700047]: ERR_OD_CANNOT_DELETE','[-700047]: ERR_OD_CANNOT_DELETE','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-900100,'[-900100]: ERR_SBSECURITIES_CAREBY_INVALID','[-900100]: ERR_SBSECURITIES_CAREBY_INVALID','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901205,'[-901205]: Số TK lưu ký chưa đăng ký online hoặc User đăng nhập chưa Active','[-901205]: Depository Account Number unregistered online or Active User login yet','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901206,'[-901206]: Một User chỉ được phép gán với 1 tk Master','[-901206]: One User only be tied to one account Master','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901207,'[-901207]: Một tk Master chỉ được gắn với 1 User','[-901207]: One account Master only be tied to one User','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901208,'[-901208]: User đã được bỏ gắn tài khoản master','[-901208]: User accounts have been un- master','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901209,'[-901209]: Trùng tên gợi nhớ tài khoản thụ hưởng','[-901209]: Duplicate reminiscent names of beneficiary account','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901210,'[-901210]: Tên chủ tài khoản thụ hưởng không cùng tên khách hàng','[-901210]: Beneficiary account holder name does not have the same customer name','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901211,'[-901211]: Mật khẩu phải có từ 7 ký tự gồm số, chữ hoa, chữ thường và ký tự đặc biệt !@#$%^&*()','[-901211]: Passwords must contain 7 characters including numbers, uppercase letters, lowercase letters, and special characters !@#$%^&*()','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901212,'[-901212]: Pin phải có từ 7 ký tự gồm số, chữ hoa, chữ thường và ký tự đặc biệt !@#$%^&*()','[-901212]: Pin must contain 7 characters including numbers, uppercase letters, lowercase letters, and special characters !@#$%^&*()','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901213,'[-901213]: Mật khẩu mới phải khác mật khẩu cũ','[-901213]: New password must be different from old password','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901214,'[-901214]: Pin mới phải khác pin cũ','[-901214]: New pin must be different from old pin','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901215,'[-901215]: Trạng thái tài khoản không hợp lệ','[-901215]: Invalid status account','CF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901216,'[-901216]: Tiểu khoản đã đăng ký sản phẩm','[-901216]: ERR_CF_REGISTER_PORODUC_NOT_EXIT','CF',0);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-901217,'[-901217]: Tiểu khoản đã hủy đăng ký sản phẩm','[-901217]: ERR_CF_REGISTER_PORODUC_NOT_EXIT','CF',0);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200112, '[-200112]: Ngày sinh và Ngày cấp không hợp lệ!', '[-200112]: Ngày sinh và Ngày cấp không hợp lệ!', 'CF', null);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200113, '[-200113]: Khách hàng chưa đủ tuổi để mở tài khoản!', '[-200113]: Khách hàng chưa đủ tuổi để mở tài khoản!', 'CF', null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200502,'[-200502]: Hiện tại mẫu này không được hủy đăng ký!','[-200502]: The template do not delete','CF',0);
insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200220, '[-200220]: Tài khoản chuyển phải khác tài khoản nhận!', '[-200220]: Tài khoản chuyển phải khác tài khoản nhận!', 'CF', null);
INSERT into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200221, '[-200221]: Trạng thái chuyển tiền không hợp lệ!', '[-200221]: Trạng thái chuyển tiền không hợp lệ!', 'CF', null);
INSERT into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200222, '[-200222]: Số tài khoản lưu ký chuyển không tồn tại hoặc không còn hoạt động!', '[-200222]: Số tài khoản lưu ký chuyển không tồn tại hoặc không còn hoạt động!', 'CF', null);
INSERT into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200223, '[-200223]: Số tài khoản lưu ký nhận không tồn tại hoặc không còn hoạt động!', '[-200223]: Số tài khoản lưu ký nhận không tồn tại hoặc không còn hoạt động!', 'CF', null);
INSERT into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200224, '[-200224]: Số tiểu khoản chuyển không thuộc tài khoản chuyển !', '[-200224]: Số tiểu khoản chuyển không thuộc tài khoản chuyển !', 'CF', null);
INSERT into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200225, '[-200225]: Số tiểu khoản nhận không thuộc tài khoản chuyển !', '[-200225]: Số tiểu khoản nhận không thuộc tài khoản chuyển !', 'CF', null);
INSERT into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-200226, '[-200226]: Số tiền chuyển phải là số và lớn hơn 0 !', '[-200226]: Số tiền chuyển phải là số và lớn hơn 0 !', 'CF', null);
COMMIT;
/
