--
--
/
DELETE FILEMASTER WHERE FILECODE = 'I024';
INSERT INTO FILEMASTER (EORI,FILECODE,FILENAME,FILEPATH,TABLENAME,SHEETNAME,ROWTITLE,DELTD,EXTENTION,PAGE,PROCNAME,PROCFILLTER,OVRRQD,MODCODE,RPTID,CMDCODE)
VALUES ('I','I024','DS nguồn Room hệ thống',null,'SECURITIES_INFO_IMPORT','1',1,'N','.xls',100,'PR_ROOM_SYSTEM_APPROVE',null,'N',null,null,null);
COMMIT;
/
