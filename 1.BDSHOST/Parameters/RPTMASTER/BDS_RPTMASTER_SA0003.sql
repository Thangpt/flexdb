﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SA0003';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SA0003','HOST','SA','12','5','5','60','5','5','BÁO CÁO QUYỀN GROUP','Y',1,'1','P','SA0003','Y','S','N','R','N','N','M','000','S',-1,'Báo cáo quyền group',null,'0','0','0','0','N','N','Y');
COMMIT;
/
