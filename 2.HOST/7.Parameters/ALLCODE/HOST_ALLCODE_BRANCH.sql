--
--
/
DELETE ALLCODE WHERE CDNAME = 'BRANCH';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','BRANCH','5','Sở giao dịch chứng khoán TP. Hồ Chí Minh',4,'Y','Sở giao dịch chứng khoán TP. Hồ Chí Minh');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','BRANCH','4','Sở giao dịch chứng khoán Hà Nội',3,'Y','Sở giao dịch chứng khoán Hà Nội');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','BRANCH','3','Uỷ ban chứng khoán Nhà Nước',2,'Y','Uỷ ban chứng khoán Nhà Nước');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','BRANCH','2','Chi nhánh Trung tâm lưu ký chứng khoán Việt Nam',1,'Y','Trung tâm lưu ký chứng khoán Việt Nam CN TP Hồ Chí Minh');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','BRANCH','1','Trung tâm lưu ký chứng khoán Việt Nam',0,'Y','Trung tâm lưu ký chứng khoán Việt Nam');
COMMIT;
/
