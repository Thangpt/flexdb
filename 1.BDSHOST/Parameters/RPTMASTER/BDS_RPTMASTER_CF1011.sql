﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF1011';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF1011','HOST','CF','12','5','5','60','5','5','DANH SÁCH ĐĂNG KÝ MỞ TKGD CÓ THÔNG TIN NHÀ ĐẦU TƯ','Y',1,'1','L','CF1003','Y','S','N','R','N','Y','M','000','S',-1,'DANH SÁCH ĐĂNG KÝ MỞ TKGD CÓ THÔNG TIN NHÀ ĐẦU TƯ ',null,'0','0','0','0','N','N','Y');
COMMIT;
/
