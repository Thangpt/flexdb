﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF1016';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF1016','HOST','CF','12','5','5','60','5','5','HỢP ÐỒNG MỞ TIỂU KHOẢN GIAO DỊCH KÝ QUỸ- TỔ CHỨC','Y',1,'1','P','CF1016','N','S','N','R','Y','Y','M','000','S',-1,'HỢP ÐỒNG MỞ TIỂU KHOẢN GIAO DỊCH KÝ QUỸ- TỔ CHỨC',null,'0','0','0','0','N','N','Y');
COMMIT;
/