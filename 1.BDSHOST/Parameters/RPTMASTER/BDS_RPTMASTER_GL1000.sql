﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'GL1000';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('GL1000','HOST','GL','12','5','5','60','5','5','BÁO CÁO RÚT/NỘP TIỀN MĂT NHÀ ĐẦU TƯ','Y',1,'1','L','GL1000','N','S','N','R','N','N','M','000','S',-1,'BÁO CÁO RÚT/NỘP TIỀN MĂT NHÀ ĐẦU TƯ',null,'0','0','0','0','N','N','Y');
COMMIT;
/
