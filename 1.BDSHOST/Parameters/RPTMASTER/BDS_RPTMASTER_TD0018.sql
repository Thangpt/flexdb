﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'TD0018';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('TD0018','HOST','TD','12','5','5','60','5','5','BÁO CÁO SỐ DƯ TIỀN GỬI TIẾT KIỆM','Y',1,'1','L','TD0018','Y','S','N','R','N','Y','M','000','S',-1,null,null,'0','0','0','0','N','N','Y');
COMMIT;
/
