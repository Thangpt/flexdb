﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'RE0321';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('RE0321','HOST','RE','12','5','5','60','5','5','TRA CỨU THANH TOÁN HOA HỒNG (GIAO DỊCH 0321 ĐỂ THANH TOÁN HOA HỒNG)','Y',1,'1','P','RE0321','Y','A','N','V','N','N','M','000','S',-1,'View commission payment for remiser (wait for 0321)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
