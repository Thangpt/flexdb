﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF9009';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF9009','HOST','CF','12','5','5','60','5','5','BẢNG KÊ CHỨNG KHOÁN ÂM','Y',1,'1','P','CF9900','N','S','N','R','N','Y','M','000','S',-1,'BẢNG KÊ CHỨNG KHOÁN ÂM',null,'0','0','0','0','N','N','Y');
COMMIT;
/
