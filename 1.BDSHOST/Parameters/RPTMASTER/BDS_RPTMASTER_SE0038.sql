--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE0038';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE0038','HOST','SE','12','5','5','60','5','5','YÊU CẦU GIẢI TỎA CHỨNG KHOÁN CẦM CỐ (20B/LK)','Y',1,'1','L','SE0038','Y','S','N','R','N','N','M','000','S',-1,'Yêu cầu giải tỏa chứng khoán cầm cố (20B/LK)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
