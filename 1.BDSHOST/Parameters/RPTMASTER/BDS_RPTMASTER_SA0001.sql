﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SA0001';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SA0001','HOST','SA','12','5','5','60','5','5','DANH SÁCH USER TRONG TỪNG GROUP','Y',1,'1','L','SA0001','Y','S','N','R','N','N','M','000','S',-1,'Danh sách user trong từng group ',null,'0','0','0','0','N','N','Y');
COMMIT;
/
