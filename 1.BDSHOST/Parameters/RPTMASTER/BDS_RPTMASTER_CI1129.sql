﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CI1129';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CI1129','HOST','CI','12','5','5','60','5','5','DANH SÁCH CHỜ THỰC RÚT TIỀN MẶT TẠI NGÂN HÀNG','Y',1,'1','P','CI1129','Y','B','N','V','N','N','M','000','S',-1,'Cash withdraw (1129)',null,'0','0','0','0','N','N','Y');
COMMIT;
/