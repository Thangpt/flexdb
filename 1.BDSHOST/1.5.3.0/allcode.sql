DELETE allcode WHERE cdname = 'VIATYPE';

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'VIATYPE', 'A', 'Tất cả', 0, 'Y', 'All');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'VIATYPE', 'O', 'Kênh Online', 1, 'Y', 'Online');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'VIATYPE', 'K', 'Kênh Home', 2, 'Y', 'Home');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'VIATYPE', 'P', 'Kênh Bảng giá', 3, 'Y', 'PriceBoard');

DELETE allcode WHERE cdname = 'OTAUTHTYPE' AND cdval in('4', '0', '1');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'OTAUTHTYPE', '1', 'Xác thực OTP', 1, 'Y', 'Authorized by OTP');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'OTAUTHTYPE', '0', 'Xác thực PIN', 0, 'Y', 'Authorized by ');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'OTAUTHTYPE', '4', 'Xác thực Chứng thư số', 2, 'Y', 'Authorized by ');

COMMIT;

delete from ALLCODE WHERE CDTYPE = 'SA' AND CDNAME = 'OTFUNC' 
and CDVAL in ('ORDINPUT', 'COND_ORDER','CASHTRANS','CASHTRANS_INTERNAL','STOCKTRANSFER','UPDTRANACT');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'OTFUNC', 'CASHTRANS', 'Chuyển tiền ra ngoài', -1, 'Y', 'Cash transfer');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'OTFUNC', 'CASHTRANS_INTERNAL', 'Chuyển tiền nội bộ', 0, 'Y', 'Cash transfer internal');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'OTFUNC', 'ORDINPUT', 'Đặt, sửa, hủy lệnh thông thường', 4, 'Y', 'Place order');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'OTFUNC', 'COND_ORDER', 'Đặt, sửa, hủy lệnh điều kiện', 5, 'Y', 'Conditional order');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'OTFUNC', 'STOCKTRANSFER', 'Chuyển khoản chứng khoán', 15, 'Y', 'Stock transfer');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'OTFUNC', 'UPDTRANACT', 'Giao dịch khác', 16, 'Y', 'TRANSACTION OTHERS');

commit;
