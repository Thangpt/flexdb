﻿--
--
/
DELETE CMDMENU WHERE PRID = '020000';
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020132','020000',3,'Y','O','SY2009','SA','DBNAVGRP','Nhóm khách hàng đánh giá theo số dư nợ và NAV','Group assisted by debit balance and NAV','YYYYYYYNNYY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020131','020000',3,'Y','O','SY2009','SA','SELIMITGRP','Nhóm hạn mức chứng khoán cho khách hàng','Group securities limit','YYYYYYYNNYY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020119','020000',3,'Y','A','SY2015','SA','READFILECV','Chuyển đổi dữ liệu từ File','Convert data from file','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020050','020000',3,'Y','A','SY2050  ','SA','COMPARETRADINGRESULT','So sánh kết quả khớp lệnh với sở GDCK','Compare Trading Result from file','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020028','020000',3,'Y','O','SY2028','SA','CFOTHERACCBLACKLIST','Danh sách tài khoản thụ hưởng nằm trong nằm trong Blacklist','The list of beneficiaries is in the Blacklist','YNNYYYNNNNN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020027','020000',3,'Y','O','SY2013  ','SA','USERT0LIMIT','Qui định hạn mức bảo lãnh cho user','Common t0 limit for user ','YYYYYYYNNYY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020026','020000',3,'Y','O','SY2025','RE','RETAX','Biểu phí TNCN môi giới','TAX FEE for remiser','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020025','020000',3,'Y','A','SY2025','SA','APRIMPORTFILE','Duyệt Import giao dịch theo file','Approve Synchronous data from file','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020024','020000',3,'Y','A','SY2024','SA','IMPORTFILE','Import giao dịch theo file','Synchronous data from file','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020023','020000',3,'Y','M','SY2021','SA','AFSERISK','Quy định CK Credit line áp dụng trong ngày','Securities margin apply for contract type','NNNNYYYNNYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020021','020000',3,'Y','O','SY2021','SA','CRBTRFACCTSRC','Tham số ngân hàng chuyển khoản','Bank source information','YYYYYYYYYYY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020019','020000',3,'Y','O','SY1010','SA','SYSVAR','Tham số hệ thống','Change sysvar value','NYYNYYNNNNY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020018','020000',3,'Y','A','SY2015  ','SA','APRREADFILE','Duyệt đồng bộ dữ liệu từ File','Approve synchronous data from file','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020017','020000',3,'Y','A','SY2015  ','SA','READFILE','Đồng bộ dữ liệu từ File','Synchronous data from file','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020014','020000',3,'Y','O','SY2014  ','CF','CFLIMITEXT','NH - Qui định hạn mức riêng cho từng khách hàng','Exception credit limit of the bank','YYYYYYYNNYY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020013','020000',3,'Y','O','SY2013  ','CF','CFLIMIT','NH - Qui định hạn mức chung','Common credit limit of the bank','YYYYYYYNNYY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020012','020000',3,'Y','O','SY2013','SA','SECURITIES_RISK','Quy định CK Credit line mức hệ thống','Securities for credit line','YYYYYYYNNYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020011','020000',3,'Y','O','SY2011','SA','BASKET','Qui định rổ chứng khoán','Securities basket','YYYYYYYNNYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020010','020000',3,'Y','A','SY2007  ','SA','SECURITIES_INFO','Thông tin chứng khoán','Securities information','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020009','020000',3,'Y','O','SY2009','SA','BRKFEEGRP','Nhóm chung phí môi giới','Contract fee group management','YYYYYYYNNYY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020008','020000',3,'Y','O','SY2008','SA','ODPROBRKMST','Chính sách ưu đãi phí môi giới','Brokerage fee promotion management','YYYYYYYNNYY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020007','020000',3,'Y','O','SY2007','SA','FEEMASTER','Bảng phí giao dịch','Fee management','YYYYYYYNNYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020006','020000',3,'Y','O','SY2006','SA','ICCFTYPESCHD','Bảng lịch biểu phí lãi tiền gửi','Fee interest accure schedule','YYYYYYYNNYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020005','020000',3,'Y','O','SY2005  ','SA','DEPOSIT_MEMBER','Thành viên lưu ký','Deposit member management','YYYYYYYNNYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020004','020000',3,'Y','O','SY2004  ','SA','ISSUERS','Tổ chức phát hành','Issuers management','YYYYYYYNNYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('020002','020000',3,'Y','A','SY2002  ','SA','CALENDAR','Lịch làm việc','Calendar management','YYYYYYYYYYN',null);
insert into cmdmenu (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
values ('020020', '020000', 3, 'Y', 'O', 'SY2020  ', 'SA', 'NAVMANAGE', 'Khai báo kỳ đánh giá khách hàng', 'NAV management', 'YYYNYYYNNYY', null);
insert into cmdmenu (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
values ('020022', '020000', 3, 'Y', 'O', 'SY2022  ', 'SA', 'EMAILLIMIT', 'Khai báo mail phê duyệt hạn mức chuyển tiền theo chi nhánh', 'Email limit', 'YYYYYYYNNYY', null);
COMMIT;
/
