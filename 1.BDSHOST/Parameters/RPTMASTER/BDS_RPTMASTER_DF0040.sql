﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'DF0040';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('DF0040','HOST','DF','12','5','5','60','5','5','BẢNG TỔNG HỢP THEO DÕI KHẾ ƯỚC VAY THEO KHÁCH HÀNG','Y',1,'1','L','DF0040','Y','S','N','R','N','Y','M','000','S',-1,'BẢNG TỔNG HỢP THEO DÕI KHẾ ƯỚC VAY THEO KHÁCH HÀNG',null,'0','0','0','0','N','N','Y');
COMMIT;
/
