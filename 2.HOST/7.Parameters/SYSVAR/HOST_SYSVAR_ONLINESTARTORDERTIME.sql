﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'ONLINESTARTORDERTIME';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ONLINESTARTORDERTIME','190000','Thoi gian cho phep dat lenh giao dich tren online','Thoi gian cho phep dat lenh giao dich tren online','N');
COMMIT;
/
