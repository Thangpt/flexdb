﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA0032';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA0032','HOST','CA','12','5','5','60','5','5','GIẤY ĐỀ NGHỊ CHUYỂN NHƯỢNG QUYỀN MUA CHỨNG KHOÁN (16/THQ)','Y',1,'1','P','CA0032','Y','S','N','R','N','N','M','000','S',-1,'Giấy đề nghị chuyển nhượng quyền mua chứng khoán (16/THQ)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
