﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'MR0010';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('MR0010','HOST','MR','12','5','5','60','5','5','TRẠNG THÁI TÀI SẢN TIỂU KHOẢN TRƯỚC GIẢI NGÂN NGÀY CUỐI','Y',1,'1','P',null,'Y','A','N','V','N','N','M','000','S',-1,'View margin account in liquid status',null,'0','0','0','0','N','N','Y');
COMMIT;
/
