--
--
/
DELETE ALLCODE WHERE CDNAME = 'FIXERRTYP';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','FIXERRTYP','002','Xóa do VSD hủy kết quả khớp lệnh',0,'Y','VSD cancel trading result');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','FIXERRTYP','001','Xóa do lỗi giao dịch và khớp vào tự doanh',0,'Y','Trading error');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','FIXERRTYP','000','Nguyên nhân khác',0,'Y','Other reason');
COMMIT;
/
