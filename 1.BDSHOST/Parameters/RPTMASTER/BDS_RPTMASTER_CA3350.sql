--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA3350';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA3350','HOST','CA','12','5','5','60','5','5','DS CHỜ PHÂN BỔ TIỀN VÀO TK-THUẾ TẠI CÔNG TY CHỨNG KHOÁN(GD 3350)','Y',1,'1','P','CA3350','Y','A','N','V','N','N','M','000','S',-1,'View corporate actions to execute-Stock Company (wait for 3350)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
