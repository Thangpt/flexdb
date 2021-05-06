CREATE OR REPLACE PACKAGE "UTF8NUMS"
    is
    -- Save with PL/SQL Developer and Run on PL/SQL Developer
    C_CONST_MONTH_VI CONSTANT VARCHAR2(20):= 'tháng';
    C_CONST_DATE_VI CONSTANT VARCHAR2(20):= 'ngày';
    c_const_COMPANY_NAME CONSTANT VARCHAR2(20):= 'KBSV';
    c_const_custtype_custodycd_ic constant varchar2(30):= 'Cá nhân trong nước';
    c_const_custtype_custodycd_bc constant varchar2(30):= 'Tổ chức trong nước';
    c_const_custtype_custodycd_if constant varchar2(30):= 'Cá nhân nước ngoài';
    c_const_custtype_custodycd_bf constant varchar2(30):= 'Tổ chức nước ngoài';

    c_const_custodycd_type_c constant varchar2(30):= 'Trong nước';
    c_const_custodycd_type_f constant varchar2(30):= 'Nước ngoài';
    c_const_custodycd_type_p constant varchar2(30):= 'Tự doanh';
    c_const_custodycd_type_re constant varchar2(30):= 'Môi giới';
    c_const_potxnum constant varchar2(30):= 'Bảng kê số';

    c_const_desc_8851 constant varchar2(30):= 'Hoàn trả ƯTTB';
    c_const_desc_8851_oddate constant varchar2(30):= 'Ngày ứng';
    c_const_desc_8851_txdate constant varchar2(30):= 'Ngày GD';

    c_const_ca0030_custodytype_1 constant varchar2(100) := 'I. MÔI GIỚI TRONG NƯỚC';
    c_const_ca0030_custodytype_2 constant varchar2(100) := 'II. MÔI GIỚI NƯỚC NGOÀI';
    c_const_ca0030_custodytype_3 constant varchar2(100) := 'III. TỰ DOANH';
    c_const_ca0030_custtype_1 constant varchar2(100) := '1. Cá nhân';
    c_const_ca0030_custtype_2 constant varchar2(100) := '2. Tổ chức';
    c_const_ca0030_name_allbranch constant varchar2(100) := 'Toàn công ty';
    c_const_ca0030_name_cb_BVS constant varchar2(100) := 'Tại KBSV';
    c_const_df_marketname constant varchar2(100) := 'Trái phiếu chuyên biệt';

    c_const_ca_rightname_a constant varchar2(100) := 'A. QUYỀN NHẬN CỔ TỨC BẰNG CỔ PHIẾU';
    c_const_ca_rightname_b constant varchar2(100) := 'B. QUYỀN CỔ PHIẾU THƯỞNG';
    c_const_ca_rightname_c constant varchar2(100) := 'C. QUYỀN NHẬN CỔ TỨC BẰNG TIỀN';
    c_const_ca_rightname_d constant varchar2(100) := 'D. QUYỀN MUA';
    c_const_ca_rightname_e constant varchar2(100) := 'E. QUYỀN HOÁN ĐỔI CỔ PHIẾU';
    c_const_ca_rightname_f constant varchar2(100) := 'F. QUYỀN CHUYỂN ĐỔI TRÁI PHIẾU' ;
    c_const_ca_rightname_g constant varchar2(100) := 'G. QUYỀN BIỀU QUYẾT';
    c_const_ca_rightname_h constant varchar2(100) := 'H. QUYỀN KHÁC';

    --TXDESC
    c_const_TLTX_TXDESC_8855 constant varchar2(100) := 'Trả phí mua';
    c_const_TLTX_TXDESC_8856 constant varchar2(100) := 'Trả phí bán';
    c_const_TLTX_TXDESC_8865 constant varchar2(100) := 'Trả tiền mua';
    c_const_TLTX_TXDESC_8866 constant varchar2(100) := 'Nhận tiền bán';
    c_const_TLTX_TXDESC_2262 constant varchar2(100) := 'Chuyển CK chờ giao dịch thành giao dịch';
    c_const_TLTX_TXDESC_2670 constant varchar2(100) := 'Giải ngân vay ML';
    c_const_TLTX_TXDESC_2660 constant varchar2(30) := 'Tất toán';
    c_const_TLTX_TXDESC_6663_DESC constant varchar2(100) := 'Chuyển tiền mua CK , TK : ';
    c_const_TLTX_TXDESC_6663_order constant varchar2(30) := ', Số lệnh :';
    c_const_TLTX_TXDESC_6663_amt constant varchar2(30) := ', Số tiền ';
    c_const_TLTX_TXDESC_6663_date constant varchar2(30) := ', Ngày GD ';
    c_const_TLTX_TXDESC_6641 constant varchar2(100) := 'Chuyển tiền thu phí lưu ký, TK: ';
    c_const_TLTX_TXDESC_6641_3384 constant varchar2(100) := 'Đăng ký thực hiện quyền mua, ';
    c_const_TLTX_TXDESC_6641_8842 constant varchar2(100) := 'Hoàn trả UTTB , TK: ';
    c_const_TLTX_TXDESC_6641_price constant varchar2(100) := 'giá';
    c_const_TLTX_TXDESC_6641_2 constant varchar2(100) := 'Phí chuyển khoản tất toán tài khoản';
    c_const_TLTX_TXDESC_6644_VAT constant varchar2(100) := 'Chuyển thuế bán CK lô lẻ CK';
    c_const_TLTX_TXDESC_6644 constant varchar2(100) := 'Chuyển tiền bán CK lô lẻ CK ';
    c_const_TLTX_TXDESC_6644_TAX constant varchar2(100) := 'Hoàn lại thuế, TK: ';
    c_const_TLTX_TXDESC_6644_FEE constant varchar2(100) := 'Hoàn lại phí, TK : ';
    c_const_TLTX_TXDESC_6644_BUY constant varchar2(100) := 'Hoàn lại tiền và phí mua, TK : ';
    c_const_TLTX_TXDESC_6643 constant varchar2(50) := 'Thu thuế ';
    c_const_TLTX_TXDESC_6643_3386 constant varchar2(50) := 'Hủy đăng ký quyền mua, ';
    c_const_TLTX_TXDESC_6682_DIV constant varchar2(100) := 'Chuyển thuế bán CK, TK : ';
    c_const_TLTX_TXDESC_6682_RI constant varchar2(100) := 'Chuyển thuế bán CK quyền mua , TK : ';
    c_const_TLTX_TXDESC_6666 constant varchar2(100) := 'Chuyển phí bán CK , TK : ';
    c_const_TLTX_TXDESC_6665 constant varchar2(100) := 'Chuyển tiền bán CK , TK : ';
    c_const_TLTX_TXDESC_6665_aamt constant varchar2(100) := 'đã ứng : ';
    c_const_TLTX_TXDESC_6664 constant varchar2(100) := 'Chuyển phí mua CK , TK : ';
    c_const_reftype_AFGP constant varchar2(100) := 'Hỗ trợ chậm thanh toán tiền mua';
    c_const_reftype_AFP constant varchar2(100) := 'Giao dịch ký quỹ';
    c_const_reftype_dfp constant varchar2(100) := 'Hợp đồng vay DF';
    c_const_TLTX_TXDESC_3356 constant varchar2(100) := 'Chuyển chứng khoán chờ giao dịch thành giao dịch, chốt ngày ';
    c_const_TLTX_TXDESC_0088_FEE constant varchar2(100) := 'Phí chuyển khoản tất toán TK';
    c_const_TXDESC_1101_OL constant varchar2(100) := 'Chuyển khoản ra ngoài: ';
    c_const_TXDESC_1120_OL constant varchar2(100) := 'Chuyển khoản nội bộ: ';
    c_const_TXDESC_1133_OL constant varchar2(100) := 'Chuyển khoản ra ngoài với CMND: ';
    c_const_TLTX_TXDESC_6646 constant varchar2(100) := 'Chuyển tiền UTTB ';
    c_const_TLTX_TXDESC_6646_amt constant varchar2(100) := 'số tiền: ';
    c_const_TLTX_TXDESC_6646_fee constant varchar2(100) := 'phí: ';
    c_const_TLTX_TXDESC_2244 constant varchar2(100) := 'Chuyển khoản chứng khoán ra ngoài';

    c_const_RPT_CF1000_1143 constant varchar2(200) := 'Số tiền đến hạn phải thanh toán';
    c_const_RPT_CF1000_1153 constant varchar2(200) := 'Phí ứng trước';
    c_const_RPT_CF1000_2266 constant varchar2(200) := 'Chuyển khoản chứng khoán ra bên ngoài';
    c_const_RPT_CF1007_8865 constant varchar2(200) := 'Trả tiền mua CK ngày ';
    c_const_RPT_CF1007_8855 constant varchar2(200) := 'Trả phí mua CK ngày ';
    c_const_RPT_CF1007_8866 constant varchar2(200) := 'Nhận tiền bán CK ngày ';
    c_const_RPT_CF1007_8866_2 constant varchar2(200) := 'Trả phí bán CK ngày ';
    c_const_RPT_CF1009_8867_SELL constant varchar2(200) := 'Bán ';
    c_const_RPT_CF1009_8867_BUY constant varchar2(200) := 'Mua ';
    c_const_RPT_CF1009_8867_DATE constant varchar2(200) := ' ngày ';

    c_const_RPT_CI1018_Phi_DESC constant varchar2(200) := 'Phí chuyển tiền';
    c_const_RPT_LN1000_AFGP_DESC CONSTANT VARCHAR2(200) := 'Bảo lãnh';
    c_const_RPT_LN1000_AFPB_DESC CONSTANT VARCHAR2(200) := 'Nguồn Ngân hàng ';
    c_const_RPT_LN1000_AFPC_DESC CONSTANT VARCHAR2(200) := 'Nguồn KBSV';
    c_const_DESC_VSD2245 CONSTANT VARCHAR2(200) := 'Điện thông báo mã CK từ VSD';
    
    --1.5.7.6|iss:1976
    c_FindText constant varchar2(2000) :=  'áàảãạâấầẩẫậăắằẳẵặđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵÁÀẢÃẠÂẤẦẨẪẬĂẮẰẲẴẶĐÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴ';
    c_ReplText constant varchar2(2000) :=  'aaaaaaaaaaaaaaaaadeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyAAAAAAAAAAAAAAAAADEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYY';
    --1.5.7.6|iss:2024
    c_const_TLTX_STATUS_1118 constant varchar2(100) := 'Chờ duyệt';
    c_const_TLTX_TXDESC_1118 constant varchar2(100) := 'Món chuyển tiền vượt hạn mức';
	--1.8.2.0.P2
	c_const_OUT_STANDING_I038 constant varchar2(100) := 'Bậc thang';
	c_const_OUT_STANDING_I039 constant varchar2(100) := 'Lãi suất linh hoạt';
END utf8nums;
/
