﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD8859';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD8859','HOST','OD','12','5','5','60','5','5','DANH SÁCH LỆNH GỬI LẠI LÊN SÀN','Y',1,'1','P','OD9982','Y','B','N','V','N','N','M','000','S',-1,'Resend Order(Failback)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
