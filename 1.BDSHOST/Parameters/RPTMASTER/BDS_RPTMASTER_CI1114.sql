﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CI1114';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CI1114','HOST','CI','12','5','5','60','5','5','TỪ CHỐI CHUYỂN KHOẢN TIỀN SANG NH (GIAO DỊCH 1114)','Y',1,'1','P','CI1114','Y','A','N','V','N','N','M','000','S',-1,'View pending transfer to other bank - REJECT (wait for 1114)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
