--
--
/
DELETE ALLCODE WHERE CDNAME = 'MTMPRICECD';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','MTMPRICECD','003','Bằng tay',2,'Y','Bằng tay');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','MTMPRICECD','002','Giá trung bình',1,'Y','Giá trung bình');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','MTMPRICECD','001','Giá đóng cửa',0,'Y','Giá đóng cửa');
COMMIT;
/
