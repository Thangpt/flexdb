﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CI0023';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CI0023','HOST','CI','12','5','5','60','5','5','BÁO CÁO DƯ NỢ UTTB CK (CHI TIẾT 1 TÀI KHOẢN)','Y',1,'1','L','CI0023','Y','S','N','R','N','N','M','000','S',-1,' Báo cáo dư nợ UTTB CK (chi tiết 1 tài khoản) ',null,'0','0','0','0','N','N','Y');
COMMIT;
/
