﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE2207';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE2207','HOST','SE','12','5','5','60','5','5','MÀN HÌNH THEO DÕI SỐ DƯ CHỨNG KHOÁN THEO MÔI GIỚI','Y',1,'1','P','SE2207','Y','A','N','V','N','N','M','000','S',-1,'View the securities by REMISER',null,'0','0','0','0','N','N','Y');
COMMIT;
/