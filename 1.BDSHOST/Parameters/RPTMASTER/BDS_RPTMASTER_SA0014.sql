--
--
/
DELETE RPTMASTER WHERE RPTID = 'SA0014';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SA0014','HOST','SA','12','5','5','60','5','5','NAV NHOM MOI GIOI (CHI TIET TK)','Y',1,'1','L','SA0008','Y','S','N','R','N','N','M','000','S',-1,'NAV NHOM MOI GIOI (CHI TIET TK)',null,'0','0','0','0','N','N','N');
COMMIT;
/
