﻿--
--
/
DELETE FILEMASTER WHERE FILECODE = 'I033';
INSERT INTO FILEMASTER (EORI,FILECODE,FILENAME,FILEPATH,TABLENAME,SHEETNAME,ROWTITLE,DELTD,EXTENTION,PAGE,PROCNAME,PROCFILLTER,OVRRQD,MODCODE,RPTID,CMDCODE)
VALUES ('T','I033','Import giao dịch giải tỏa chứng khoán phong tỏa (2203)',null,'TBLSE2203','1',1,'N','.xls',100,'PR_FILE_TBLSE2203',null,'N','SE','V_SE2203','SE');
COMMIT;
/
