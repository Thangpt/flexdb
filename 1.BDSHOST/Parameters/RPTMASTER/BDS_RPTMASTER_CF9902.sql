﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF9902';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF9902','HOST','CF','12','5','5','60','5','5','DANH SÁCH TÀI KHOẢN DO OT QUẢN LÝ','Y',1,'1','L','CF9902','N','S','N','R','N','N','M','000','S',-1,'Danh sách tài kho?n do OT qu?n lý',null,'0','0','0','0','N','N','Y');
COMMIT;
/