--
--
/
DELETE ALLCODE WHERE CDNAME = 'MSGSTS';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','MSGSTS','E','Lỗi',2,'Y','Lỗi');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','MSGSTS','C','Hoàn tất',1,'Y','Hoàn tất');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','MSGSTS','P','Chờ duyệt',0,'Y','Chờ duyệt');
COMMIT;
/
