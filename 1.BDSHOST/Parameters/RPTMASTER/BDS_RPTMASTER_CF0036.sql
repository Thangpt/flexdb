﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF0036';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF0036','HOST','CF','12','5','5','60','5','5','TẠO FILE EXCEL DANH SÁCH GIAO DỊCH LƯU KÝ CHO VSD','Y',1,'1','P','CF0036','Y','A','N','V','N','N','M','000','S',-1,'Export excel file to VSD',null,'0','0','0','0','N','N','Y');
COMMIT;
/
