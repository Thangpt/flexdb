﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA3326';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA3326','HOST','CA','12','5','5','60','5','5','HUỶ ĐĂNG KÝ MUA CP PHÁT HÀNH THÊM KHÔNG CẮT TIỀN CI','Y',1,'1','P','CA3326','Y','A','N','V','N','N','M','000','S',-1,'Đăng ký mua CP phát hành thêm không cắt tiền CI',null,'0','0','0','0','N','N','Y');
COMMIT;
/