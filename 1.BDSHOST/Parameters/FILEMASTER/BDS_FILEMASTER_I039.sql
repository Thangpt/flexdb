﻿/
DELETE FILEMASTER WHERE FILECODE='I039';
insert into FILEMASTER (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE)
values ('T', 'I039', 'Thay đổi lãi suất vay của KH/nhóm KH', null, 'TBLINTCHANGE', '1', 1, 'N', '.xls', 100, 'PR_INT_CHANGE', null, 'N', null, null, 'CF');
COMMIT;
/
