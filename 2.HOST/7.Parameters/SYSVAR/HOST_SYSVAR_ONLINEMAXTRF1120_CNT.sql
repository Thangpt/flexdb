﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'ONLINEMAXTRF1120_CNT';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ONLINEMAXTRF1120_CNT','99999999999999999999','So lan chuyen khoan noi bo toi da trong ngay','So lan chuyen khoan noi bo toi da trong ngay','Y');
COMMIT;
/
