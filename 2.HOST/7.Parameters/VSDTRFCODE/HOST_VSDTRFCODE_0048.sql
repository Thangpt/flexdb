﻿--
--
/
DELETE VSDTRFCODE WHERE TLTXCD = '0048';
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('598.002.ACCT//AOPN','Chấp thuận mở tài khoản','598','Y','CFO','0048','CF0048','CUSTODYCD','0047','Y');
COMMIT;
/