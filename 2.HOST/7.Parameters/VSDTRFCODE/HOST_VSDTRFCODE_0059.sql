﻿--
--
/
DELETE VSDTRFCODE WHERE TLTXCD = '0059';
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('598.NEWM/ACLS','Ðóng tài khoản','598','Y','REQ','0059',null,null,null,'Y');
COMMIT;
/
