--
--
/
DELETE ALLCODE WHERE CDNAME = 'GRPTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','GRPTYPE','2','Dịch vụ KH',1,'Y','Dịch vụ KH');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','GRPTYPE','1','Bình thường',0,'Y','Bình thường');
COMMIT;
/
