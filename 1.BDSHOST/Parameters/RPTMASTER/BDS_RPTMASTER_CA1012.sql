﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA1012';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA1012','HOST','CA','12','5','5','60','5','5','BÁO CÁO CHI TRẢ LỢI TỨC CHỨNG QUYỀN','Y',1,'1','L','CA1012','Y','S','N','R','N','N','M','000','S',-1,'BENEFIT PAYMENT STATEMENT',null,'0','0','0','0','N','N','Y');
COMMIT;
/
