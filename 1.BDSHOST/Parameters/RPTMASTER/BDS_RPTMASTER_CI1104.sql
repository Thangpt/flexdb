﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CI1104';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CI1104','HOST','CI','12','5','5','60','5','5','DANH SÁCH GIAO DỊCH CHUYỂN KHOẢN TIỀN SANG NGÂN HÀNG CHỜ XUẤT ỦY NHIỆM CHI (GIAO DỊCH 1104)','Y',1,'1','P','PO','Y','A','N','V','N','N','M','000','S',-1,'View pending transfer to other bank (wait for 1104)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
