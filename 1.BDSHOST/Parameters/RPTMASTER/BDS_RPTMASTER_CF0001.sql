﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF0001';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF0001','HOST','CF','12','5','5','60','5','5','BÁO CÁO DANH SÁCH KHÁCH HÀNG MỞ TIỂU KHOẢN ĐANG HOẠT ĐỘNG','Y',1,'1','L','CF0001','Y','S','N','R','N','N','M','000','S',-1,'Báo cáo danh sách khách hàng mở Tiểu khoản đang hoạt động',null,'0','0','0','0','N','N','Y');
COMMIT;
/
