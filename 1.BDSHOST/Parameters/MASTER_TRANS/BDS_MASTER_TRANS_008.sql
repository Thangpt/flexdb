﻿--
--
/
DELETE FLDVAL WHERE OBJNAME = '008';
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('08','008',2,'V','>>','@0',null,'Con chung khoan phong toa','Con chung khoan phong toa',null,null,'0');
COMMIT;
/
