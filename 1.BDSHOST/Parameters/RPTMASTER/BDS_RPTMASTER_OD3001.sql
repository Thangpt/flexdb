﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD3001';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD3001','HOST','OD','12','5','5','60','5','5','Báo cáo đăng ký và hủy đăng ký dịch vụ kết nối Bloomberg','Y',1,'1','L','OD3001','Y','S','N','R','N','N','M','000','S',-1,'Báo cáo đăng ký và hủy đăng ký dịch vụ kết nối Bloomberg',null,'0','0','0','0','N','N','Y');
COMMIT;
/
