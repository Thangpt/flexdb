﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE0043';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE0043','HOST','SE','12','5','5','60','5','5','GIẤY ĐỀ NGHỊ CHUYỂN KHOẢN CHỨNG KHOÁN','Y',1,'1','L','SE0043#SE00311#SE00312#SE00313#SE00314#SE00315#SE00316#SE00317#SE00318#SE00431','Y','S','N','R','N','N','M','000','S',-1,'GIẤY ĐỀ NGHỊ CHUYỂN KHOẢN CHỨNG KHOÁN',null,'0','0','0','0','Y','N','Y');
COMMIT;
/