﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'RE0091';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('RE0091','HOST','RE','12','5','5','60','5','5','BÁO CÁO PHÂN BỔ LƯƠNG BỔ SUNG CHĂM SÓC HỘ','Y',1,'1','L','RE0091','Y','S','N','R','N','N','M','000','S',-1,'BÁO CÁO PHÂN BỔ LƯƠNG BỔ SUNG CHĂM SÓC HỘ',null,'0','0','0','0','N','N','Y');
COMMIT;
/
