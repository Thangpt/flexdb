﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA3380';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA3380','HOST','CA','12','5','5','60','5','5','DANH SÁCH CHỜ XÁC NHẬN QUYỀN TỪ TRUNG TÂM LƯU KÝ(GIAO DỊCH 3380)','Y',1,'1','P','CA3380','Y','B','N','V','N','N','M','000','S',-1,'View corporate actions to send (wait for 3380)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
