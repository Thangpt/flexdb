﻿--
--
/
DELETE FILEMASTER WHERE FILECODE = 'I035';
INSERT INTO FILEMASTER (EORI,FILECODE,FILENAME,FILEPATH,TABLENAME,SHEETNAME,ROWTITLE,DELTD,EXTENTION,PAGE,PROCNAME,PROCFILLTER,OVRRQD,MODCODE,RPTID,CMDCODE)
VALUES ('T','I035',' Import giao dịch giảm trừ phí cho khách hàng (1138)',null,'TBLCI1138','1',1,'N','.xls',100,'PR_FILE_TBLCI1138',null,'N','CI','V_CI1138','CI');
COMMIT;
/
