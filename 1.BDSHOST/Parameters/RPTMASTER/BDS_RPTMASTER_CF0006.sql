﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF0006';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF0006','HOST','CF','12','5','5','60','5','5','BÁO CÁO PHÁT SINH SỐ DƯ PHONG TỎA','Y',1,'1','L','CF0006','Y','S','N','R','N','Y','M','000','S',-1,'Báo cáo phát sinh số dư phong tỏa',null,'0','0','0','0','N','N','Y');
COMMIT;
/