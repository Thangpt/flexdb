--
--
/
DELETE FILEMASTER WHERE FILECODE = 'I028';
INSERT INTO FILEMASTER (EORI,FILECODE,FILENAME,FILEPATH,TABLENAME,SHEETNAME,ROWTITLE,DELTD,EXTENTION,PAGE,PROCNAME,PROCFILLTER,OVRRQD,MODCODE,RPTID,CMDCODE)
VALUES ('T','I028','Import giao dịch nhận chuyển khoản chứng khoán (2245)',null,'TBLSE2245','1',1,'N','.xls',100,'PR_FILE_TBLSE2245',null,'N','SE','V_SE2245','SE');
COMMIT;
/
