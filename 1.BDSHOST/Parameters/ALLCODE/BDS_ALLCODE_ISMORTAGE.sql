--
--
/
DELETE ALLCODE WHERE CDNAME = 'ISMORTAGE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','ISMORTAGE','0','Không',1,'Y','Không');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OD','ISMORTAGE','1','Có',0,'Y','Có');
COMMIT;
/
