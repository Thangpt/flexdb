﻿--
--
/
DELETE CMDMENU WHERE PRID = '031000';
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('031003','031000',4,'Y','O','GL0003  ','SA','BANKNOSTRO','Danh sách tài khoản tại ngân hàng','Bank nostro account','YYYYYYYNNYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('031002','031000',-4,'Y','O','GL0002  ','GL','GLMAST','Danh mục tiểu khoản kế toán chi tiết','GL detail account management','YYNYYYYNNYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('031001','031000',-4,'Y','O','GL0001  ','GL','GLBANK','Danh mục kế toán đồ','GL master account management','YYYYYYYNNYN',null);
COMMIT;
/
