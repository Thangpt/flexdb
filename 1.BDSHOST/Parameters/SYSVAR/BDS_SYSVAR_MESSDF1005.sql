--
--
/
DELETE SYSVAR WHERE VARNAME = 'MESSDF1005';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','MESSDF1005','MESSDF1005','ECC xin thông báo: Tài khoản: <CUSTODYCD> có deal vay: <ACCTNO>, Khối lượng vay: <REMAINQTTY>, Chứng khoán: <SYMBOL>, Số tiền vay: <AMT> quá hạn từ ngày <BUSDATE>. Vui lòng liên hệ 08-12345678 để được tư vấn.','ECC xin thông báo: Tài khoản: <CUSTODYCD> có deal vay: <ACCTNO>, Khối lượng vay: <REMAINQTTY>, Chứng khoán: <SYMBOL>, Số tiền vay: <AMT> quá hạn từ ngày <BUSDATE>. Vui lòng liên hệ 08-12345678 để được tư vấn.','N');
COMMIT;
/
