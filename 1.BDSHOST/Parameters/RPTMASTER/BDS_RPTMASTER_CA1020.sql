﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA1020';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA1020','HOST','CA','12','5','5','60','5','5','BÁO CÁO THEO DÕI CHUYỂN SÀN GIAO DỊCH','Y',1,'1','L','CA1020','Y','S','N','R','N','N','M','000','S',-1,'BÁO CÁO THEO DÕI CHUYỂN SÀN GIAO DỊCH',null,'0','0','0','0','N','N','Y');
COMMIT;
/
