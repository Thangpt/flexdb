﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CI0052';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CI0052','HOST','CI','12','5','5','60','5','5','BẢNG KÊ NHẬN CHUYỂN KHOẢN NGÂN HÀNG','Y',1,'1','L','CI0052','Y','S','N','R','N','N','M','000','S',-1,' Bảng kê nhận chuyển khoản ngân hàng ',null,'0','0','0','0','N','N','Y');
COMMIT;
/