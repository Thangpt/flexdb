﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA0001';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA0001','HOST','CA','12','5','5','60','5','5','BÁO CÁO CHỜ THỰC HIỆN QUYỀN CỦA KHÁCH HÀNG','Y',1,'1','L','CA0001','N','S','N','R','N','N','M','000','S',-1,'Báo cáo chờ thực hiện quyền của khách hàng',null,'0','0','0','0','N','N','Y');
COMMIT;
/