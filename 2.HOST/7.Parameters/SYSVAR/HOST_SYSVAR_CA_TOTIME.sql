﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'CA_TOTIME';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('STRADE','CA_TOTIME','23:00:00','Strade, CA register to time',null,'N');
COMMIT;
/
