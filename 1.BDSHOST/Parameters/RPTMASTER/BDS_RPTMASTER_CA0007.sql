﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA0007';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA0007','HOST','CA','12','5','5','60','5','5','DANH SÁCH CỔ PHẦN HẠN CHẾ CHUYỂN NHƯỢNG VÀ PHONG TỎA','Y',1,'1','L','CA0007','N','S','N','R','N','N','M','000','S',-1,'Danh sách cổ phần hạn chế chuyển nhượng và phong tỏa',null,'0','0','0','0','N','N','Y');
COMMIT;
/