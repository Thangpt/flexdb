﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'LN0024';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('LN0024','HOST','LN','12','5','5','60','5','5','BÁO CÁO DANH SÁCH MÃ CK ĐẶT LỆNH KHI CẤP BẢO LÃNH','Y',1,'1','L','LN0024','Y','S','N','R','N','Y','M','000','S',-1,'BÁO CÁO DANH SÁCH MÃ CK ĐẶT LỆNH KHI CẤP BẢO LÃNH',null,'0','0','0','0','N','N','Y');
COMMIT;
/
