﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CI0033';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CI0033','HOST','CI','12','5','5','60','5','5','BÁO CÁO TÍNH PHÍ CHI TIẾT CHO TỪNG TÀI KHOẢN','Y',1,'1','L','CI0033','Y','S','N','R','N','N','M','000','S',-1,'Báo cáo tính phí chi tiết cho từng tài khoản',null,'0','0','0','0','N','N','Y');
COMMIT;
/
