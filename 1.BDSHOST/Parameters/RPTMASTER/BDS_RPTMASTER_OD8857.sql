--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD8857';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD8857','HOST','OD','12','5','5','60','5','5','DANH SÁCH CÁC LỆNH BÁN ATO CÓ THỂ  GIẢI TỎA TRƯỚC KHI ĐẨY LÊN SÀN(GIAO DỊCH 8857)','Y',1,'1','P','OD9009','Y','B','N','V','N','N','M','000','S',-1,'Refuse ATO sell order(wait for 8857)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
