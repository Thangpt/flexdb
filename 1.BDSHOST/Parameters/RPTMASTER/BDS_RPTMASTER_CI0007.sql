﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CI0007';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CI0007','HOST','CI','12','5','5','60','5','5','BẢNG KÊ ĐÍNH KÈM GiẤY ĐỀ NGHỊ GIẢI NGÂN KIÊM KHẾ ƯỚC NHẬN NỢ','Y',1,'1','L','CI0007','Y','S','N','R','N','N','M','000','S',-1,'BẢNG KÊ ĐÍNH KÈM GiẤY ĐỀ NGHỊ GIẢI NGÂN KIÊM KHẾ ƯỚC NHẬN NỢ',null,'0','0','0','0','N','N','Y');
COMMIT;
/