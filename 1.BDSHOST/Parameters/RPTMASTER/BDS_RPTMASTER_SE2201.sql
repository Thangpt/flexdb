﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE2201';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE2201','HOST','SE','12','5','5','60','5','5','DANH SÁCH RÚT CHỨNG KHOÁN CHỜ XÁC NHẬN TỪ TTLK  (GIAO DỊCH 2201)','Y',1,'1','P','SE2201','Y','B','N','V','N','N','M','000','S',-1,'View pending to Withdraw (wait for 2201)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
