﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CI0061';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CI0061','HOST','CI','12','5','5','60','5','5','BẢNG KÊ CHUYỂN NHƯỢNG QUYỀN NHẬN TIỀN BÁN CK','Y',1,'1','L','CI0061','N','S','N','R','N','N','M','000','S',-1,'Bảng kê chuyển nhượng quyền nhận tiền bán CK',null,'0','0','0','0','N','N','Y');
COMMIT;
/
