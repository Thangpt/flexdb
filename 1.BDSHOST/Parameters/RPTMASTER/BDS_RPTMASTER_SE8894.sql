--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE8894';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE8894','HOST','SE','12','5','5','60','5','5','THANH TOÁN TIỀN GIAO DỊCH BÁN CHỨNG KHOÁN LÔ LẺ (GIAO DỊCH 8894)','Y',1,'1','P','SE8894','Y','B','N','V','N','N','M','000','S',-1,'Match cash order retail (8894)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
