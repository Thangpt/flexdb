--
--
/
DELETE ALLCODE WHERE CDNAME = 'GL0003';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GL','GL0003','597','Lợi nhuận sau thuế',8,'Y','Lợi nhuận sau thuế');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GL','GL0003','596','Lợi nhuận tính thuế',7,'Y','Lợi nhuận tính thuế');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GL','GL0003','595','Tổng lợi nhuận trước thuế',6,'Y','Tổng lợi nhuận trước thuế');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GL','GL0003','594','Lợi nhuận ngoài hoạt động kinh doanh',5,'Y','Lợi nhuận ngoài hoạt động kinh doanh');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GL','GL0003','593','Lợi nhuận thuần từ hoạt động kinh doanh chứng khoán',4,'Y','Lợi nhuận thuần từ hoạt động kinh doanh chứng khoán');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GL','GL0003','592','Lợi nhuận gộp',3,'Y','Lợi nhuận gộp');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GL','GL0003','591','Doanh thu hoạt động kinh doanh chứng khoán và lãi đầu tư',2,'Y','Doanh thu hoạt động kinh doanh chứng khoán và lãi đầu tư');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GL','GL0003','590','Doanh thu thuần',1,'Y','Doanh thu thuần');
COMMIT;
/
