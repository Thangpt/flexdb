﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'MR4001';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('MR4001','HOST','MR','12','5','5','60','5','5','BÁO CÁO TỔNG HỢP DƯ NỢ VAY KÝ QUỸ','Y',1,'1','L','MR4001','Y','S','N','R','N','N','M','000','S',-1,'BÁO CÁO TỔNG HỢP DƯ NỢ VAY KÝ QUỸ',null,'0','0','0','0','N','N','Y');
COMMIT;
/