﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE0035';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE0035','HOST','SE','12','5','5','60','5','5','DANH SÁCH NGƯỜI SỞ HỮU ĐỀ NGHỊ RÚT CHỨNG KHOÁN (11B/LK)','Y',1,'1','L','SE0035','Y','S','N','R','N','N','M','000','S',-1,'Danh sách người sở hữu đề nghị rút chứng khoán(11B/LK)',null,'0','0','0','0','N','N','Y');
COMMIT;
/