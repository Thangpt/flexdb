--
--
/
DELETE ALLCODE WHERE CDNAME = 'RESTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('PR','RESTYPE','M','Margin',1,'Y','Margin');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('PR','RESTYPE','S','Hệ thống',0,'Y','System');
COMMIT;
/
