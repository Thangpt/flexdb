--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA1005';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA1005','HOST','CA','12','5','5','60','5','5','CHIA CỔ TỨC BẰNG CỔ PHIẾU (ĐỐI CHIẾU)','Y',1,'1','P','CA1005','Y','B','N','V','N','N','M','000','S',-1,'Chia cổ tức bằng cổ phiếu (đối chiếu)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
