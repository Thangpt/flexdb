--
--
/
DELETE RPTMASTER WHERE RPTID = 'DF0023';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('DF0023','HOST','DF','12','5','5','60','5','5','BÁO CÁO SỐ DƯ GIAO DỊCH NỢ CHƯA THANH LÝ DEAL','Y',1,'1','L','DF0023','N','S','N','R','N','Y','M','000','S',-1,'Báo cáo số dư giao dịch nợ chưa thanh lý deal',null,'0','0','0','0','N','N','Y');
COMMIT;
/
