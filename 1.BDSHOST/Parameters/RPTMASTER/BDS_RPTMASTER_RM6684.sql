﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'RM6684';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('RM6684','HOST','RM','12','5','5','60','5','5','DANH SÁCH BẢNG KÊ BỊ LỖI CHỜ GỬI LẠI (6684)','Y',1,'1','P','RM6684','Y','A','N','V','V','V','M','000','S',-1,'View error EOD report waiting for resend (6684)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
