--
--
/
DELETE ALLCODE WHERE CDNAME = '1OR0';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','1OR0','0','Không',1,'Y','Không');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','1OR0','1','Có',0,'Y','Có');
COMMIT;
/
