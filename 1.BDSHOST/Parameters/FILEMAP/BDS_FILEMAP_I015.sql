﻿--
--
/
DELETE FILEMAP WHERE FILECODE = 'I015';
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I015','TXDATE','TXDATE','C','Y',500,'U','N','Y','Y','0',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I015','OrderNo','OrderNo','C','Y',500,'U','N','Y','Y','0',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I015','TraderCode','custodycd','C','Y',500,'U','N','Y','Y','0',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I015','acctno','acctno','C','Y',500,'U','N','Y','Y','0',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I015','Symbol','Symbol','C','Y',500,'U','N','Y','Y','0',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I015','QTTY','QTTY','C','Y',500,'U','N','Y','Y','0',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I015','ORDERQTTY','ORDERQTTY','C','Y',500,'U','N','Y','Y','0',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I015','EXECTYPE','EXECTYPE','C','Y',500,'U','N','Y','Y','0',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I015','NORP','NORP','C','Y',500,'U','N','Y','Y','0',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I015','FEEACR','FEEACR','C','Y',500,'U','N','Y','Y','0',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I015','AMT','AMT','C','Y',500,'U','N','Y','Y','0',null,'N');
INSERT INTO FILEMAP (FILECODE,FILEROWNAME,TBLROWNAME,TBLROWTYPE,ACCTNOFLD,TBLROWMAXLENGTH,CHANGETYPE,DELTD,DISABLED,VISIBLE,LSTODR,FIELDDESC,SUMAMT)
VALUES ('I015',' QUOTEPRICE','QUOTEPRICE','C','Y',500,'U','N','Y','Y','0',null,'N');
COMMIT;
/
