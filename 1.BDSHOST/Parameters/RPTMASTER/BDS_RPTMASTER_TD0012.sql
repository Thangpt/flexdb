﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'TD0012';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('TD0012','HOST','TD','12','5','5','60','5','5','BÁO CÁO GIAO DỊCH TIẾT KIỆM','Y',1,'1','L','TD0012','N','S','N','R','N','Y','M','000','S',-1,null,null,'0','0','0','0','N','N','Y');
COMMIT;
/
