--
--
/
DELETE RPTMASTER WHERE RPTID = 'RE0385';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('RE0385','HOST','RE','12','5','5','60','5','5','TRA CỨU MÔI GIỚI CỦA NHÓM (GIAO DỊCH 0385 ĐỂ HỦY KHỎI NHÓM)','Y',1,'1','P','RE0385','Y','A','N','V','N','N','M','000','S',-1,'View remiser belong to group (wait for 0385 to remove from group)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
