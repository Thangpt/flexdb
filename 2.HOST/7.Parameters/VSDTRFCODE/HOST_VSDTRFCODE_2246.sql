﻿--
--
/
DELETE VSDTRFCODE WHERE TLTXCD = '2246';
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('544.NEWM.LINK//540.SETR//TRAD.STCO//PHYS.OK','Chấp thuận lưu ký chứng khoán','544','Y','CFO','2246','SE2246','CUSTODYCD','2241','Y');
COMMIT;
/