﻿--
--
/
DELETE CMDMENU WHERE PRID = '230000';
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('230005','230000',3,'Y','R','PR0005  ','PR','RPTMASTER','Báo cáo','Reporting','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('230004','230000',3,'Y','A','PR0004  ','PR','PRGENERALVIEW','Tra cứu tổng hợp','General view','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('230003','230000',3,'N','T','PR0002  ','PR',null,'Giao dịch','Transaction','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('230002','230000',3,'Y','O','PR0001','PR','PRTYPE','Loại hình sản phẩm nguồn PR','Pool/Room Type','YYYYYYYNNY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('230001','230000',3,'Y','O','PR0000  ','PR','PRMASTER','Quản lý nguồn Pool/Room','Pool / Room management','YYYYYYYNNY',null);
COMMIT;
/