--
--
/
DELETE ALLCODE WHERE CDNAME = 'CMDALLOW';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','CMDALLOW','N','Không',1,'Y','Không');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','CMDALLOW','Y','Có',0,'Y','Có');
COMMIT;
/
