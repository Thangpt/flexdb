--
--
/
DELETE ALLCODE WHERE CDNAME = 'SECTOR';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','SECTOR','002','Xây dựng',1,'Y','Xây dựng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','SECTOR','001','Tin học và Viễn thông',0,'Y','Tin học và Viễn thông');
COMMIT;
/
