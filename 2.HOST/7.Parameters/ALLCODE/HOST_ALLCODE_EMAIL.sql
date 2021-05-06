--
--
/
DELETE ALLCODE WHERE CDNAME = 'EMAIL';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','EMAIL','cuongpv@kbsec.com.vn','Email nhan thong bao',4,'Y','Email nhan thong bao');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','EMAIL','thaont@kbsec.com.vn','Email nhan thong bao',4,'Y','Email nhan thong bao');
COMMIT;
/
