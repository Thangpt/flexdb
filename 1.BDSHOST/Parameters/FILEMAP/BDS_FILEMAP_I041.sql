--
--
/
DELETE FILEMAP WHERE FILECODE = 'I041';
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I041','NAVPRICE','NAVPRICE','N','N',24,'U','N','Y','Y','4',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I041','SYMBOL','SYMBOL','C','N',18,'U','N','Y','Y','3',null,'N');
COMMIT;
/
