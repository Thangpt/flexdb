--
--
/
DELETE ALLCODE WHERE CDNAME = 'TERMOFUSE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','TERMOFUSE','003','GD cần 2 chữ ký',2,'Y','GD cần 2 chữ ký');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','TERMOFUSE','004','Tất cả cùng ký',2,'Y','Tất cả cùng ký');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','TERMOFUSE','002','Tối thiểu 1 chữ ký',1,'Y','Tối thiểu 1 chữ ký');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','TERMOFUSE','001','Chữ ký chủ sở hữu',0,'Y','Chữ ký chủ sở hữu');
COMMIT;
/
