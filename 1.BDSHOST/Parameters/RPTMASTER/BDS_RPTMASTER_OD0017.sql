﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD0017';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD0017','HOST','OD','12','5','5','60','5','5','BÁO CÁO TỔNG HỢP PHÍ GIAO DỊCH TOÀN CÔNG TY','Y',1,'1','P','OD0017','Y','S','N','R','N','N','M','000','S',-1,'BÁO CÁO TỔNG HỢP PHÍ GIAO DỊCH TOÀN CÔNG TY',null,'0','0','0','0','N','N','Y');
COMMIT;
/
