--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD0014';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD0014','HOST','OD','12','5','5','60','5','5','BÁO CÁO DOANH SỐ MÔI GIỚI','Y',1,'1','L','OD0014','Y','S','N','R','N','N','M','000','S',-1,'Bao cao doanh so moi gioi',null,'0','0','0','0','N','N','Y');
COMMIT;
/
