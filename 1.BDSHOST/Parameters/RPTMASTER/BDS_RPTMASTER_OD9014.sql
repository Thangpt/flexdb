--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD9014';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD9014','HOST','OD','12','5','5','60','5','5','DANH SÁCH CÁC LỆNH NẰM NGOÀI KHOẢNG TRẦN SÀN','Y',1,'1','P','OD9014','Y','B','N','V','N','N','M','000','S',-1,'View order not in ceiling floor',null,'0','0','0','0','N','N','Y');
COMMIT;
/
