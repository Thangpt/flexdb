﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'LN0001';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('LN0001','HOST','LN','12','5','5','60','5','5','TRẠNG THÁI MÓN VAY','Y',1,'1','P','LN0001','Y','B','N','V','N','N','M','000','S',-1,'View loan accounts',null,'0','0','0','0','N','N','Y');
COMMIT;
/