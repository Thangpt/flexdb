﻿--
--
/
DELETE FILEMASTER WHERE FILECODE = 'IHNX';
INSERT INTO FILEMASTER (EORI,FILECODE,FILENAME,FILEPATH,TABLENAME,SHEETNAME,ROWTITLE,DELTD,EXTENTION,PAGE,PROCNAME,PROCFILLTER,OVRRQD,MODCODE,RPTID,CMDCODE)
VALUES ('I','IHNX','Import trading result HNX',null,'HNXTRADINGRESULT','1',1,'N','.xls',100,'PRC_COMPARE_HNXRESULT',null,'N',null,null,null);
COMMIT;
/
