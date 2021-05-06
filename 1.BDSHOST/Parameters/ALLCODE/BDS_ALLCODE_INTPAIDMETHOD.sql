--
--
/
DELETE ALLCODE WHERE CDNAME = 'INTPAIDMETHOD';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','INTPAIDMETHOD','P','Thu KH theo tỷ lệ trả gốc, Trả NH vào kỳ trả gốc cuối cùng',3,'Y','Thu KH theo tỷ lệ trả gốc, Trả NH vào kỳ trả gốc cuối cùng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','INTPAIDMETHOD','L','Thu vào kỳ trả gốc cuối cùng',2,'Y','Thu vào kỳ trả gốc cuối cùng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('LN','INTPAIDMETHOD','I','Thu ngay theo tỷ lệ trả gốc',1,'Y','Thu ngay theo tỷ lệ trả gốc');
COMMIT;
/
