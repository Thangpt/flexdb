﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'MR1811';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('MR1811','HOST','MR','12','5','5','60','5','5','DANH SÁCH TIỂU KHOẢN CHỜ THU HỒI HẠN MỨC T0 (GIAO DỊCH 1811)','Y',1,'1','P',null,'Y','B','N','V','N','N','M','000','S',-1,'View allocate guarantee T0 (waiting for 1811)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
