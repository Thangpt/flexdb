﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'TD0006';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('TD0006','HOST','TD','12','5','5','60','5','5','BAO CAO GIAO DICH PHAT SINH','Y',1,'1','L','TD0006','Y','A','N','R','N','N','Y','000','S',-1,null,null,'0','0','0','0','N','N','Y');
COMMIT;
/