﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD0067_1';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD0067_1','HOST','OD','12','5','5','60','5','5','BÁO CÁO TỔNG HỢP KẾT QUẢ BÙ TRỪ ĐA PHƯƠNG VÀ THANH TOÁN TIỀN (02/PL-TTBT)','Y',1,'1','L','OD0067_1','Y','S','N','R','N','N','M','000','S',-1,'Báo cáo tổng hợp kết quả bù trừ đa phương và thanh toán tiền (02/PL-TTBT)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
