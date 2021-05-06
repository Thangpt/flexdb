﻿--
--
/
DELETE CMDMENU WHERE PRID = '111200';
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111210','111200',3,'Y','A','CI0013','CI','CUSTODYCDCIWITHDRAW','Tra cứu rút tiền theo tài khoản','CUSTODYCDCIWITHDRAW','YNNYYYYNNYY',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111209','111200',3,'Y','O','CI0012','SA','CRBTRFLOGCI','Quản lý bảng kê tiền sang ngân hàng','Bank voucher management','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111208','111200',-3,'Y','A','CI0011  ','CI','CIEXTRANSFER','Chuyển tiền ra ngân hàng (liên tiểu khoản)','Transfer from to other Bank','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111207','111200',3,'Y','A','CI0010  ','CI','MANUALADV','Ứng trước tiền bán','Manual Advance','YYYYYYYYYYN','1153');
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111206','111200',-3,'Y','A','CI0009  ','CI','CIWITHDRAW','Rút tiền (liên tiểu khoản)','Withdrawn on Custodycd','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111205','111200',3,'Y','A','CIIMP','CI','CIIMPORTFILE','Import giao dịch theo file','Synchronous data from file','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111204','111200',3,'Y','A','CI0005  ','CI','CIGENERALVIEW','Tra cứu tổng hợp','General view','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111203','111200',3,'Y','R','CI0004  ','CI','RPTMASTER','Báo cáo','Reporting','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111202','111200',3,'N','T','CI0003  ','CI',null,'Giao dịch','Transaction','YYYYYYYYYYN',null);
INSERT INTO CMDMENU (CMDID,PRID,LEV,LAST,MENUTYPE,MENUCODE,MODCODE,OBJNAME,CMDNAME,EN_CMDNAME,AUTHCODE,TLTXCD)
VALUES ('111201','111200',3,'Y','M','CI0002  ','CI','CIMAST','Quản lý','Management','NYNNYYYNNYN',null);
COMMIT;
/
