--
--
/
DELETE RPTMASTER WHERE RPTID = 'DF0058';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('DF0058','HOST','DF','12','5','5','60','5','5','YÊU CẦU GIẢI TỎA CHỨNG KHOÁN CẦM CỐ VỚI VSD– 32/LK','Y',1,'1','P','DF0058','Y','S','N','R','N','N','M','000','S',-1,'Yêu cầu giải tỏa chứng khoán cầm cố với VSD– 32/LK',null,'0','0','0','0','N','N','Y');
COMMIT;
/
