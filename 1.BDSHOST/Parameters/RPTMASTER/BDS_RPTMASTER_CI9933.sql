﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CI9933';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CI9933','HOST','CI','12','5','5','60','5','5','TRA CỨU LỆNH ETS LIÊN QUAN ĐẾN XỬ LÝ DEAL','Y',1,'1','P','CI9933','N','B','N','V','N','N','M','000','S',-1,'View ETS order for deal payment',null,'0','0','0','0','N','N','Y');
COMMIT;
/