﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'RM0058';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('RM0058','HOST','RM','12','5','5','60','5','5','BÁO CÁO VỀ SỰ THAY ĐỔI TRẠNG THÁI BẢNG KÊ','Y',1,'1','L','RM0058','Y','S','N','R','Y','Y','M','000','S',-1,'Báo cáo về sự thay đổi trạng thái bảng kê',null,'0','0','0','0','N','N','Y');
COMMIT;
/
