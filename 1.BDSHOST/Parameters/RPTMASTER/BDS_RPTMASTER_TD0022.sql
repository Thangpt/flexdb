﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'TD0022';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('TD0022','HOST','TD','12','5','5','60','5','5','BAO CAO GIAO DICH TD HANG NGAY','Y',1,'1','P','TD0022','N','A','N','R','N','Y','M','000','S',-1,null,null,'0','0','0','0','N','N','Y');
COMMIT;
/