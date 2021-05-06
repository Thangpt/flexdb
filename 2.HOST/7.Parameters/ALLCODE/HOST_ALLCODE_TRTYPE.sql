--
--
/
DELETE ALLCODE WHERE CDNAME = 'TRTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RP','TRTYPE','T','Chuyển nhượng',2,'Y','Chuyển nhượng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('RP','TRTYPE','M','Cầm cố',1,'Y','Cầm cố');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SE','TRTYPE','012','Nhận chuyển khoản cùng nhà đầu tư',11,'Y','Nhận chuyển khoản cùng nhà đầu tư');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SE','TRTYPE','011','Nhận chuyển khoản tất toán',10,'Y','Nhận chuyển khoản tất toán');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SE','TRTYPE','010','Chuyển khoản khác',9,'Y','Chuyển khoản khác');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SE','TRTYPE','009','Chuyển khoản do TVLK bị đình chỉ hoạt động, thu hồi giấy CN hoạt động LK',8,'Y','Chuyển khoản do TVLK bị đình chỉ hoạt động, thu hồi giấy CN hoạt động LK');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SE','TRTYPE','008','Chuyển khoản xử lý CK cầm cố',7,'Y','Chuyển khoản xử lý CK cầm cố');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SE','TRTYPE','007','Chuyển khoản góp vốn bằng CK vào DN',6,'Y','Chuyển khoản góp vốn bằng CK vào DN');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SE','TRTYPE','006','Chuyển khoản chia, tách sát nhập DN',5,'Y','Chuyển khoản chia, tách sát nhập DN');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SE','TRTYPE','005','Chuyển khoản do thay đổi loại điều kiện chứng khoán lưu ký',4,'Y','Chuyển khoản do thay đổi loại điều kiện chứng khoán lưu ký');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SE','TRTYPE','004','Chuyển khoản hỗ trợ chứng khoán',3,'Y','Chuyển khoản hỗ trợ chứng khoán');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SE','TRTYPE','003','Chuyển khoản thừa kế, ly hôn',2,'Y','Chuyển khoản thừa kế, ly hôn');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SE','TRTYPE','002','Chuyển khoản biếu tặng cho',1,'Y','Chuyển khoản biếu tặng cho');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SE','TRTYPE','001','Chuyển khoản chứng khoán giao dịch CK lô lẻ',0,'Y','Chuyển khoản chứng khoán giao dịch CK lô lẻ');
COMMIT;
/
