--
--
/
DELETE CMDMENU WHERE PRID = '210000';
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('210005','210000',-3,'Y','A','SY0005  ','SA','TRANSACTSYNC','Đồng bộ giao dịch từ file','Synchronous transaction from file','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('210004','210000',3,'Y','A','GL0015  ','GL','GLGENERALVIEW','Tra cứu tổng hợp','General view','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('210002','210000',3,'Y','R','GL0014  ','GL','RPTMASTER','Báo cáo','Reporting','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('210001','210000',3,'N','T','GL0013  ','GL',null,'Giao dịch','Transaction','YYYYYYYYYYN',null);
COMMIT;
/
