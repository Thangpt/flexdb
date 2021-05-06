﻿--
--
/
DELETE CMDMENU WHERE PRID = '111100';
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111113','111100',3,'Y','O','CF0013','CF','MSBBANKREQUEST','Đăng ký tự động chuyển tiền MSB','Auto tranfer/receiving cash from bank','YNNYYYYNNYY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111112','111100',3,'Y','O','CF0012','CF','BANKCONTRACTINFO','Quản lý đăng ký HĐ 3 bên với khách hàng','Register contract account with Bank','YYYYYYYNNNN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111111','111100',3,'Y','O','CF0011','CF','AFSERVICES','Quản lý đăng ký dịch vụ','Register services management','NYYNYYNNNNN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111110','111100',3,'Y','A','CF0010  ','CF','EMAILPOPULAR','Quản lý email/SMS gửi chung','Email/SMS popular management','NYNNYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111109','111100',-3,'Y','O','CF0009','CF','AFPOLICYMST','Qui định đầu tư','Investment policy','YYYYYYYNNYY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111108','111100',3,'Y','A','CF0000  ','CF','DETAILCUSTINFO','Tra cứu tổng hợp thông tin khách hàng','Search full detail customer info','NYNNYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111107','111100',3,'Y','A','CFAPRIMP','CF','CFAPRIMPORTFILE','Duyệt Import giao dịch theo file','Approve Synchronous data from file','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111106','111100',3,'Y','A','CFIMPORT','CF','CFIMPORTFILE','Import giao dịch theo file','Synchronous data from file','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111104','111100',3,'Y','A','CF0007  ','CF','CFGENERALVIEW','Tra cứu tổng hợp','General view','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111103','111100',3,'Y','R','CF0006  ','CF','RPTMASTER','Báo cáo','Reporting','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111102','111100',3,'N','T','CF0005  ','CF','0070','Giao dịch','Transaction','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111101','111100',3,'Y','M','CF0004  ','CF','AFMAST','Quản lý','Management','YYYYYYYNNYY',null);
COMMIT;
/
