﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'RM6688';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('RM6688','HOST','RM','12','5','5','60','5','5','DANH SÁCH BẢNG KÊ CÓ THỂ XOÁ (6688)','Y',1,'1','P','RM6688','Y','A','N','V','N','N','M','000','S',-1,'Delete EOD report (6688)',null,'0','0','0','0','N','N','Y');
COMMIT;
/