﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SA0004';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SA0004','HOST','SA','12','5','5','60','5','5','SAO KÊ GIAO DỊCH PHÁT SINH','Y',1,'1','P','SA0004','Y','S','N','R','N','N','M','000','S',-1,'Sao kê giao dịch phát sinh',null,'0','0','0','0','N','N','Y');
COMMIT;
/
