﻿--
--
/
DELETE FILEMASTER WHERE FILECODE = 'C012';
INSERT INTO FILEMASTER (EORI,FILECODE,FILENAME,FILEPATH,TABLENAME,SHEETNAME,ROWTITLE,DELTD,EXTENTION,PAGE,PROCNAME,PROCFILLTER,OVRRQD,MODCODE,RPTID,CMDCODE)
VALUES ('D','C012','Cfauth convert',null,'CFAUTHCV','1',1,'N','.xls',100,null,null,'N',null,null,null);
COMMIT;
/
