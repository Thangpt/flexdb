﻿--
--
/
DELETE SYSVAR WHERE VARNAME = 'HCMBVSCREPAUTH';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('DEFINED','HCMBVSCREPAUTH','02/2012 /UQ-BVSC ngày 01/ 02 /2012','Giấy ủy quyền của BVSC',null,'N');
COMMIT;
/
