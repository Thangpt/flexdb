﻿--
--
/
DELETE FILEMAP WHERE FILECODE = 'I051';
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I051','MARGINCALLPRICE','MARGINCALLPRICE','N','N',24,'U','N','Y','Y','4',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I051','MARGINPRICE','MARGINPRICE','N','N',24,'U','N','Y','Y','4',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I051','SYMBOL','SYMBOL','C','N',18,'U','N','Y','Y','3',null,'N');
COMMIT;
/
