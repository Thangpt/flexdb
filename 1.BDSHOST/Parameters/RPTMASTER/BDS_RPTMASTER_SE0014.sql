﻿--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE0014';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE0014','HOST','SE','12','5','5','60','5','5','DANH SÁCH KHÁCH HÀNG CÓ GIAO DỊCH CHỨNG KHOÁN','Y',1,'1','L','SE0014','N','S','N','R','N','N','M','000','S',-1,'Danh sách khách hàng có giao dịch chứng khoán',null,'0','0','0','0','N','N','Y');
COMMIT;
/
