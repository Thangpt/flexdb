﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE2248';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE2248','HOST','SE','12','5','5','60','5','5','HOÀN TẤT CHUYỂN KHOẢN CHỨNG KHOÁN ĐÓNG TÀI KHOẢN (GIAO DỊCH 2248)','Y',1,'1','P','SSE','Y','B','N','V','N','N','M','000','S',-1,'View send depository center (wait for 2248) ',null,'0','0','0','0','N','N','Y');
COMMIT;
/
