﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'LN0012';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('LN0012','HOST','LN','12','5','5','60','5','5','BÁO CÁO SỐ DƯ BVS GIẢI NGÂN DO TK KHÔNG ĐỦ TIỀN','Y',1,'1','L','LN0012','N','S','N','R','N','Y','M','000','S',-1,'Báo cáo số dư BVS giải ngân do TK không đủ tiền',null,'0','0','0','0','N','N','Y');
COMMIT;
/
