﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CI1112';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CI1112','HOST','CI','12','5','5','60','5','5','TRA CỨU BẢNG KÊ UNC CẦN TỪ CHỐI (1112)','Y',1,'1','P','CI1112','Y','B','N','V','N','N','M','000','S',-1,'View Order Payment (CI1112)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
