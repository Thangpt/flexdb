﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE0077';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE0077','HOST','SE','12','5','5','60','5','5','BẢNG KÊ DANH SÁCH NGƯỜI SỞ HỮU ĐỀ NGHỊ LƯU KÝ CHỨNG KHOÁN','Y',1,'1','L','SE0077','Y','S','N','R','N','N','M','000','S',-1,'Bảng kê Danh sách người sở hữu đề nghị lưu ký chứng khoán',null,'0','0','0','0','N','N','Y');
COMMIT;
/
