﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'RM0001';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('RM0001','HOST','RM','12','5','5','60','5','5','BÁO CÁO BÁN LÔ LẺ - TÀI KHOẢN COREBANK(GD-8815)','Y',1,'1','L','RM0001','Y','S','N','R','N','N','M','000','S',-1,'Báo cáo bán lô lẻ - tài khoản corebank(GD-8815)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
