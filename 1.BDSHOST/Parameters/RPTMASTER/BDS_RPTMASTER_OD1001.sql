﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD1001';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD1001','HOST','OD','12','5','5','60','5','5','BÁO CÁO KẾT QUẢ KHỚP LỆNH CỦA KHÁCH HÀNG','Y',1,'1','P','OD1001','N','S','N','R','N','Y','M','000','S',-1,'Báo cáo kết quả khớp lệnh của khách hàng',null,'0','0','0','0','N','N','Y');
COMMIT;
/