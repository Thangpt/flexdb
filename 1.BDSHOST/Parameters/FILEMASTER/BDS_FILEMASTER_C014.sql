﻿--
--
/
DELETE FILEMASTER WHERE FILECODE = 'C014';
INSERT INTO FILEMASTER (EORI,FILECODE,FILENAME,FILEPATH,TABLENAME,SHEETNAME,ROWTITLE,DELTD,EXTENTION,PAGE,PROCNAME,PROCFILLTER,OVRRQD,MODCODE,RPTID,CMDCODE)
VALUES ('C','C014','SEmast convert',null,'SEMASTCV','1',1,'N','.xls',100,null,null,'N',null,null,null);
COMMIT;
/