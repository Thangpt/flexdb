--
--
/
DELETE ALLCODE WHERE CDNAME = 'CFINTROSTATUS';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CFINTROSTATUS','R','Từ chối',2,'Y','Reject');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CFINTROSTATUS','D','Đã xóa',2,'Y','Delete');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CFINTROSTATUS','A','Thành công',1,'Y','Active');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','CFINTROSTATUS','P','Chờ xử lý',0,'Y','Pending');
COMMIT;
/
