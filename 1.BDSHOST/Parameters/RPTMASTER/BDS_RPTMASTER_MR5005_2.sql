﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'MR5005_2';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('MR5005_2','HOST','MR','12','5','5','60','5','5','BÁO CÁO TỔNG HỢP DỊCH VỤ KÝ QUỸ','Y',1,'1','L','MR5005_2','Y','S','N','R','N','N','M','000','S',-1,'BÁO CÁO TỔNG HỢP DỊCH VỤ KÝ QUỸ',null,'0','0','0','0','N','N','Y');
COMMIT;
/
