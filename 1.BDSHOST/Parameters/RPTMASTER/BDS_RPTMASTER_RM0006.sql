﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'RM0006';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('RM0006','HOST','RM','12','5','5','60','5','5','DANH SÁCH KHÁCH HÀNG MUA THIẾU TIỀN TRONG NGÀY (CẦN DÙNG BẢO LÃNH)','Y',1,'1','P','RM0006','Y','B','N','V','N','N','M','000','S',-1,'View customer using credit line in day',null,'0','0','0','0','N','N','Y');
COMMIT;
/