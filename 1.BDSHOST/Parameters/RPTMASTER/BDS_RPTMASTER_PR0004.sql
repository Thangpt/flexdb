﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'PR0004';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('PR0004','HOST','PR','12','5','5','60','5','5','BÁO CÁO ÐÁNH D?U ROOM CHI TI?T CHO T?NG LO?I N?','Y',1,'1','L','PR0004','Y','S','N','R','N','N','M','000','S',-1,'BÁO CÁO ÐÁNH D?U ROOM CHI TI?T CHO T?NG LO?I N?',null,'0','0','0','0','N','N','Y');
COMMIT;
/
