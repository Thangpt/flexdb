﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA0006';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA0006','HOST','CA','12','5','5','60','5','5','DANH SÁCH NGƯỜI SỞ HỮU CHỨNG KHOÁN LƯU KÝ','Y',1,'1','L','CA0006','Y','S','N','R','N','N','M','000','S',-1,'Danh sách người sở hữu chứng khoán lưu ký',null,'0','0','0','0','N','N','Y');
COMMIT;
/