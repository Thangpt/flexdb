﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'TD0003';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('TD0003','HOST','TD','12','5','5','60','5','5','TRANG THAI SO DU GUI HO TRO LAI SUAT(KHONG CHAN CAREBY)','Y',1,'1','P',null,'Y','B','N','V','N','N','M','0  ','S',-1,'Trang thai so du gui ho tro lai suat(khong chan careby)',null,'0','0','0','0','N','N','Y');
COMMIT;
/