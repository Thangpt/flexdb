﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF1002';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF1002','HOST','CF','12','5','5','60','5','5','SỔ CHI TIẾT TÀI KHOẢN TIỀN GIAO DỊCH CỦA NHÀ ĐẦU TƯ','Y',1,'1','L','CF1002','Y','S','N','R','N','Y','M','000','S',-1,' Sổ chi tiết tài khoản tiền giao dịch của nhà đầu tư ',null,'0','0','0','0','N','N','Y');
COMMIT;
/