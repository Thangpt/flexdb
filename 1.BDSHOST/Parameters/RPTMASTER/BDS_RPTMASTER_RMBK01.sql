﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'RMBK01';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('RMBK01','HOST','RM','12','5','5','60','5','5','TẠO BẢNG KÊ CHUYỂN SANG NGÂN HÀNG','Y',1,'1','P','RMBK01','Y','A','N','V','N','N','M','000','S',-1,'Create EOD Report send to Bank',null,'0','0','0','0','N','N','Y');
COMMIT;
/
