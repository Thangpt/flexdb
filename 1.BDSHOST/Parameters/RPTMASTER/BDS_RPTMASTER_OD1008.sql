﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD1008';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD1008','HOST','OD','12','5','5','60','5','5','BÁO CÁO PHÁT SINH GIAO DỊCH THANH TOÁN BÙ TRỪ','Y',1,'1','P','OD1008','Y','S','N','R','N','N','M','000','S',-1,'Báo cáo phát sinh giao dịch thanh toán bù trừ',null,'0','0','0','0','N','N','Y');
COMMIT;
/
