﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'MR3006';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('MR3006','HOST','MR','12','5','5','60','5','5','GIẤY ĐỀ NGHỊ GIẢI NGÂN KIÊM KHẾ ƯỚC NHẬN NỢ','Y',1,'1','P','MR3006','Y','S','N','R','Y','Y','M','000','S',-1,'GIẤY ĐỀ NGHỊ GIẢI NGÂN KIÊM KHẾ ƯỚC NHẬN NỢ',null,'0','0','0','0','N','N','Y');
COMMIT;
/