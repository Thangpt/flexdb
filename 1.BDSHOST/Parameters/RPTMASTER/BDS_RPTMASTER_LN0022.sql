﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'LN0022';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('LN0022','HOST','LN','12','5','5','60','5','5','BÁO CÁO VI PHẠM CAM KẾT BẢO LÃNH THEO SỐ TK','Y',1,'1','L','LN0022','Y','S','N','R','N','Y','M','000','S',-1,'BÁO CÁO VI PHẠM CAM KẾT BẢO LÃNH THEO SỐ TK',null,'0','0','0','0','N','N','Y');
COMMIT;
/
