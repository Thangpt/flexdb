--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD8892';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD8892','HOST','OD','12','5','5','60','5','5','TỪ CHỐI ĐẨY LỆNH LÊN SÀN','Y',1,'1','P','OD8892','Y','B','N','V','N','N','M','000','S',-1,'Refuse order',null,'0','0','0','0','N','N','Y');
COMMIT;
/
