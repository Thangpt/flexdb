--
--
/
DELETE FILEMASTER WHERE FILECODE = 'C031';
INSERT INTO FILEMASTER (EORI,FILECODE,FILENAME,FILEPATH,TABLENAME,SHEETNAME,ROWTITLE,DELTD,EXTENTION,PAGE,PROCNAME,PROCFILLTER,OVRRQD,MODCODE,RPTID,CMDCODE)
VALUES ('C','C031','BD02CV',null,'BD02CV','1',1,'N','.xls',100,null,null,'N',null,null,null);
COMMIT;
/
