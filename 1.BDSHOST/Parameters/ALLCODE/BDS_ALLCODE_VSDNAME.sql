--
--
/
DELETE ALLCODE WHERE CDNAME = 'VSDNAME';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','VSDNAME','002','Trung tâm lưu ký chứng khoán Việt Nam - Chi nhánh TP Hồ Chí Minh',1,'Y','Trung tâm lưu ký chứng khoán Việt Nam - Chi nhánh TP Hồ Chí Minh');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CA','VSDNAME','001','Trung tâm lưu ký chứng khoán Việt Nam',0,'Y','Trung tâm lưu ký chứng khoán Việt Nam');
COMMIT;
/
