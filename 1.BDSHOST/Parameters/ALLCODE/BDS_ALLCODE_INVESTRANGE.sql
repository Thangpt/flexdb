--
--
/
DELETE ALLCODE WHERE CDNAME = 'INVESTRANGE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','INVESTRANGE','003','> 2 tỷ',2,'Y','> 2 tỷ');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','INVESTRANGE','002','500 triệu - 2 tỷ',1,'Y','500 triệu - 2 tỷ');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('CF','INVESTRANGE','001','< 500 triệu',0,'Y','< 500 triệu');
COMMIT;
/
