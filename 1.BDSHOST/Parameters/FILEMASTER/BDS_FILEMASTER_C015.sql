﻿--
--
/
DELETE FILEMASTER WHERE FILECODE = 'C015';
INSERT INTO FILEMASTER (EORI,FILECODE,FILENAME,FILEPATH,TABLENAME,SHEETNAME,ROWTITLE,DELTD,EXTENTION,PAGE,PROCNAME,PROCFILLTER,OVRRQD,MODCODE,RPTID,CMDCODE)
VALUES ('C','C015','Stschd convert',null,'STSCHDCV','1',1,'N','.xls',100,null,null,'N',null,null,null);
COMMIT;
/