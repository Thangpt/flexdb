﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD0023';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD0023','HOST','OD','12','5','5','60','5','5','SỔ LỆNH GIAO DỊCH CỦA KHÁCH HÀNG','Y',1,'1','L','OD0023','N','S','N','R','N','Y','M','000','S',-1,'Sổ lệnh giao dịch của khách hàng ',null,'0','0','0','0','N','N','Y');
COMMIT;
/
