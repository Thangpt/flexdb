﻿--
--
/
DELETE FILEMASTER WHERE FILECODE = 'I009';
INSERT INTO FILEMASTER (EORI,FILECODE,FILENAME,FILEPATH,TABLENAME,SHEETNAME,ROWTITLE,DELTD,EXTENTION,PAGE,PROCNAME,PROCFILLTER,OVRRQD,MODCODE,RPTID,CMDCODE)
VALUES ('I','I009','Thay d?i R? S?n ph?m Credit line',null,'SECBASKETEDIT','1',1,'N','.xls',100,'CAL_SEC_BASKET_EDIT','FILLTER_SEC_BASKET_EDIT','Y',null,null,null);
COMMIT;
/