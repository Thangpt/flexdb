﻿--
--
/
DELETE VSDTRFCODE WHERE TLTXCD = '8816';
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('548.INST.LINK//542.SETR//TRAD.STCO//DLWM','Từ chối chuyển khoản CK TDCN lô lẻ','548','Y','CFN','8816',null,'CUSTODYCD','8815','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('542.NEWM.CLAS//PEND/1.SETR//TRAD.STCO//DLWM.NAK','Điện chuyển khoản CK TDCN chờ giao dịch lô lẻ bị NAK','542','N','CFN','8816',null,null,'8815','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('542.NEWM.CLAS//NORM/1.SETR//TRAD.STCO//DLWM.NAK','Điện chuyển khoản CK TDCN lô lẻ bị NAK','542','Y','CFN','8816',null,null,'8815','Y');
COMMIT;
/
