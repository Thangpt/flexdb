﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF0100';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF0100','HOST','CF','12','5','5','60','5','5','MÀN HÌNH TRA SOÁT – ĐÁNH DẤU LỖI CÁC DEAL BẢO LÃNH VI PHẠM','Y',1,'1','P','CF0100','Y','A','N','V','N','N','M','000','S',-1,'MÀN HÌNH TRA SOÁT – ĐÁNH DẤU LỖI CÁC DEAL BẢO LÃNH VI PHẠM',null,'0','0','0','0','N','N','Y');
COMMIT;
/