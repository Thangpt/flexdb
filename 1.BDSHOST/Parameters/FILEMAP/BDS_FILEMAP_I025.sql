﻿--
--
/
DELETE FILEMAP WHERE FILECODE = 'I025';
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I025','ROOMLIMITMAX','ROOMLIMIT','N','N',24,'U','N','Y','Y','4',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I025','SYMBOL','SYMBOL','C','N',18,'U','N','Y','Y','3',null,'N');
COMMIT;
/
