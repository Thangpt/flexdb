--
--
/
DELETE allcode WHERE cdtype = 'OD' AND cdname = 'PRICECHKTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','PRICECHKTYPE','1','Giá lệnh con không vuợt qua giá chỉ thị',1,'Y','Sub order price can not greaster than origin order');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','PRICECHKTYPE','2','Giá trung bình không vượt qua giá chỉ thị',2,'Y','Sub average price can not greaster than origin order');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','PRICECHKTYPE','3','Không check giá lệnh con',3,'Y','Do not check price sub order');
COMMIT;
/
