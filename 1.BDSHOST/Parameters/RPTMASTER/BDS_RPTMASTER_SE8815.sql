﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE8815';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE8815','HOST','SE','12','5','5','60','5','5','CHUYỂN HỒ SƠ GIAO DỊCH LÔ LẺ LÊN VSD (8815)','Y',1,'1','P','SE8815','Y','A','N','V','N','N','M','000','S',-1,'Send trade lot retail to VSD (8815)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
