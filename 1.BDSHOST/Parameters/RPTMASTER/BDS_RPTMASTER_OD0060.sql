﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD0060';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD0060','HOST','OD','12','5','5','60','5','5','BÁO CÁO CHI TIẾT SỔ LỆNH','Y',1,'1','P','OD0060','N','S','N','R','N','Y','M','000','S',-1,'Báo cáo chi tiết sổ lệnh',null,'0','0','0','0','N','N','Y');
COMMIT;
/