﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA3301';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA3301','HOST','CA','12','5','5','60','5','5','MÀN HÌNH THEO DÕI LỊCH THỰC HIỆN QUYỀN THEO SỐ LƯU KÝ','Y',1,'1','P','CA3301','Y','A','N','V','N','N','M','000','S',-1,'View the CA scheduler by custody code',null,'0','0','0','0','N','N','Y');
COMMIT;
/
