﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF0009';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF0009','HOST','CF','12','5','5','60','5','5','BÁO CÁO VỀ TÌNH HÌNH ĐÓNG MỞ TÀI KHOẢN LƯU KÝ','Y',1,'1','P','CF0009','Y','S','N','R','N','N','M','000','S',-1,'Báo cáo về tình hình đóng mở tài khoản lưu ký',null,'0','0','0','0','N','N','Y');
COMMIT;
/
