﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE2290';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE2290','HOST','SE','12','5','5','60','5','5','HỦY HỒ SƠ CHUYỂN KHOẢN CHỨNG KHOÁN ĐÓNG TIỂU KHOẢN (GIAO DỊCH 2290)','Y',1,'1','P','SE9030','Y','B','N','V','N','N','M','000','S',-1,'Re-active pending to close SE account (wait for 2290)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
