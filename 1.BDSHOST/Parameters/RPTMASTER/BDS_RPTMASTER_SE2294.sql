﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE2294';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE2294','HOST','SE','12','5','5','60','5','5','HỦY XÁC NHẬN XIN RÚT CHỨNG KHOÁN DO TT TỪ CHỐI (GIAO DỊCH 2294)','Y',1,'1','P','SE2207','Y','B','N','V','N','N','M','000','S',-1,'Revert 2292 because Depository declined withdraw (wait for 2294)',null,'0','0','0','0','N','N','Y');
COMMIT;
/