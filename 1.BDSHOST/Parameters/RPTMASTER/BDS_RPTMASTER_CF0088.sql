﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF0088';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF0088','HOST','CF','12','5','5','60','5','5','TRA CỨU ĐÓNG TIỂU KHOẢN (GIAO DỊCH 0088)','Y',1,'1','P','CFMAST','Y','A','N','V','N','N','M','000','S',-1,'View sub-account for closing (wait for 0088)',null,'0','0','0','0','N','N','Y');
COMMIT;
/