--
--
/
DELETE ALLCODE WHERE CDNAME = 'TYPESTS';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('FO','TYPESTS','C','Đóng',3,'Y','Đóng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('FO','TYPESTS','S','Suspend',2,'Y','Suspend');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('FO','TYPESTS','A','Hoạt động',1,'Y','Hoạt động');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('FO','TYPESTS','P','Chờ duyệt',0,'Y','Chờ duyệt');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TYPESTS','C','Đóng',3,'Y','Đóng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TYPESTS','S','Tạm dừng',2,'Y','Tạm dừng');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TYPESTS','A','Hoạt động',1,'Y','Hoạt động');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TYPESTS','P','Chờ duyệt',0,'Y','Chờ duyệt');
COMMIT;
/
