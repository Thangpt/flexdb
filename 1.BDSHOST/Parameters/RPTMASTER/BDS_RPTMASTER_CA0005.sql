﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA0005';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA0005','HOST','CA','12','5','5','60','5','5','LỊCH TRÌNH THỰC HIỆN QUYỀN MUA CỔ PHIẾU','Y',1,'1','L','CA0005','N','S','N','R','N','N','M','000','S',-1,'Lịch trình thực hiện quyền mua cổ phiếu',null,'0','0','0','0','N','N','Y');
COMMIT;
/
