--
--
/
DELETE RPTMASTER WHERE RPTID = 'RE0320';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('RE0320','HOST','RE','12','5','5','60','5','5','TRA CỨU TÍNH HOA HỒNG (GIAO DỊCH 0320 ĐỂ CHỐT HOA HỒNG)','Y',1,'1','P','RE0320','N','A','N','V','N','N','M','000','S',-1,'View calculating commission for remiser (wait for 0320)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
