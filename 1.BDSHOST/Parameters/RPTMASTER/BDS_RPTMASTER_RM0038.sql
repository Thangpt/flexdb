﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'RM0038';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('RM0038','HOST','RM','12','5','5','60','5','5','BẢNG KÊ THANH TOÁN TIỀN PHÍ BÁN CK','Y',1,'1','P','RM0038','Y','S','N','R','N','Y','M','000','S',-1,'Bảng kê thanh toán phí tiền mua CK',null,'0','0','0','0','N','N','Y');
COMMIT;
/
