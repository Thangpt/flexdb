﻿--
--
/
DELETE VSDTRFCODE WHERE TLTXCD = '2265';
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('598.001.ACCT//TWAC.NAK','Điện tất toán bị NAK','598','Y','CFN','2265',null,null,null,'Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('548.INST.LINK//598.SETR//TWAC.','Từ chối chuyển khoản tất toán không đóng tài khoản','548','Y','CFN','2265','SE2265',null,'2255','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('548.INST.LINK//542.SETR//OWNE.STCO//DLWM','Từ chối chuyển khoản chứng khoán','546','Y','CFN','2265','SE2265','CUSTODYCD','2255','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('542.NEWM.CLAS//PEND/2.SETR//OWNI.STCO//DLWM.NAK','Điện chuyển khoản chứng khoán bị NAK','546','Y','CFN','2265','SE2265','CUSTODYCD','2255','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('542.NEWM.CLAS//PEND/2.SETR//OWNE.STCO//DLWM.NAK','Điện chuyển khoản chứng khoán bị NAK','546','Y','CFN','2265','SE2265','CUSTODYCD','2255','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('542.NEWM.CLAS//PEND/1.SETR//OWNI.STCO//DLWM.NAK','Điện chuyển khoản chứng khoán bị NAK','546','Y','CFN','2265','SE2265','CUSTODYCD','2255','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('542.NEWM.CLAS//PEND/1.SETR//OWNE.STCO//DLWM.NAK','Điện chuyển khoản chứng khoán bị NAK','546','Y','CFN','2265','SE2265','CUSTODYCD','2255','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('542.NEWM.CLAS//NORM/2.SETR//OWNI.STCO//DLWM.NAK','Điện chuyển khoản chứng khoán bị NAK','546','Y','CFN','2265','SE2265','CUSTODYCD','2255','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('542.NEWM.CLAS//NORM/2.SETR//OWNE.STCO//DLWM.NAK','Điện chuyển khoản chứng khoán bị NAK','546','Y','CFN','2265','SE2265','CUSTODYCD','2255','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('542.NEWM.CLAS//NORM/1.SETR//OWNI.STCO//DLWM.NAK','Điện chuyển khoản chứng khoán bị NAK','546','Y','CFN','2265','SE2265','CUSTODYCD','2255','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('542.NEWM.CLAS//NORM/1.SETR//OWNE.STCO//DLWM.NAK','Điện chuyển khoản chứng khoán bị NAK','546','Y','CFN','2265','SE2265','CUSTODYCD','2255','Y');
COMMIT;
/
