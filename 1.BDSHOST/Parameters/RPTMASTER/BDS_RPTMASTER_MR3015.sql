﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'MR3015';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('MR3015','HOST','MR','12','5','5','60','5','5','KẾT QUẢ XỬ LÝ TÀI SẢN ĐẢM BẢO','Y',1,'1','L','MR3015','Y','S','N','R','N','N','M','000','S',-1,'KẾT QUẢ XỬ LÝ TÀI SẢN ĐẢM BẢO',null,'0','0','0','0','N','N','Y');
COMMIT;
/
