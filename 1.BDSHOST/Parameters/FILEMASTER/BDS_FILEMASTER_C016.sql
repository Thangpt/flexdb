﻿--
--
/
DELETE FILEMASTER WHERE FILECODE = 'C016';
INSERT INTO FILEMASTER (EORI,FILECODE,FILENAME,FILEPATH,TABLENAME,SHEETNAME,ROWTITLE,DELTD,EXTENTION,PAGE,PROCNAME,PROCFILLTER,OVRRQD,MODCODE,RPTID,CMDCODE)
VALUES ('C','C016','advanced convert',null,'ADSCHDCV','1',1,'N','.xls',100,null,null,'N',null,null,null);
COMMIT;
/
