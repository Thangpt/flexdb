﻿--
--
/
DELETE CMDMENU WHERE PRID = '220000';
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('220005','220000',3,'Y','A','CA0026  ','CA','IMPORTFILECA','Import file thực hiện quyền','Import file ca','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('220004','220000',3,'Y','A','CA1003  ','CA','CAGENERALVIEW','Tra cứu tổng hợp','General view','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('220003','220000',3,'Y','R','CA1002  ','CA','RPTMASTER','Báo cáo','Reporting','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('220002','220000',3,'N','T','CA1001  ','CA',null,'Giao dịch','Transaction','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('220001','220000',3,'Y','O','CA1000  ','CA','CAMAST','Quản lý quyền','CA management','YYYYYYYNNYY',null);
COMMIT;
/
